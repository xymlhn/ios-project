//
//  LoginController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/10.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "AppManager.h"
#import "SettingViewController.h"
#import "RootViewController.h"
#import "User.h"
#import "TMCache.h"
#import "AddressViewController.h"
@interface LoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property(nonatomic, strong) LoginView *loginView;

@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)loadView{
    _loginView = [LoginView new];
    self.view = _loginView;
}

-(void)bindListener{
    _loginView.userNameText.delegate = self;
    _loginView.passWordText.delegate = self;
    
    [_loginView.userNameText addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_loginView.passWordText addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    _loginView.loginBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self loginBtnClick];
        return [RACSignal empty];
    }];
    
}

/**
 *  用户名密码验证
 */
-(void)p_validUsernameAndPassword{
    RACSignal *validUsernameSignal = [_loginView.userNameText.rac_textSignal
                                      map:^id(NSString *text) {
                                          return @([self p_isValidUsername:text]);
                                      }];
    RAC(_loginView.userNameText, textColor) =[validUsernameSignal map:^id(NSNumber *usernameValid){
        return[usernameValid boolValue] ? [UIColor blackColor]:[UIColor redColor];
    }];
    
    RACSignal *validPasswordSignal = [_loginView.passWordText.rac_textSignal
                                      map:^id(NSString *text) {
                                          return @([self p_isValidPassword:text]);
                                      }];
    RACSignal *signUpActiveSignal =
    [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal]
                      reduce:^id(NSNumber*usernameValid, NSNumber *passwordValid){
                          return @([usernameValid boolValue]&&[passwordValid boolValue]);
                      }];
    [signUpActiveSignal subscribeNext:^(NSNumber*signupActive){
        _loginView.loginBtn.backgroundColor = [signupActive boolValue] ? [UIColor nameColor] : [UIColor grayColor];
        _loginView.loginBtn.enabled = [signupActive boolValue];
    }];
}

/**
 * 用户名验证
 *
 *  @param text 用户名
 *
 *  @return bool
 */
-(BOOL)p_isValidUsername:(NSString *)text{
    NSString * regex = @"^[A-Za-z0-9-_@]{1,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:text];
    return isMatch;
}

/**
 *  密码验证
 *
 *  @param text 密码
 *
 *  @return bool
 */
-(BOOL)p_isValidPassword:(NSString *)text{
    return text.length > 0;
}

-(void)loginBtnClick{
    NSString *username = _loginView.userNameText.text;
    NSString *password = _loginView.passWordText.text;
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hub.detailsLabel.text = @"正在登录";
    
    // 请求参数
    NSDictionary *dic = @{ @"user":username,@"pwd":password};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_LOGIN];
    
    [HttpUtil postFormData:URLString param:dic finish:^(NSDictionary *obj, NSString *error) {
        if(!error){
            // 字典转模型
            User *account = [User mj_objectWithKeyValues:obj];
            if(account.authenticated){
                [Config saveUserName:username andPassword:password];
                [Config saveLoginStatus:true];
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                hub.detailsLabel.text = [NSString stringWithFormat:@"登录成功"];
                [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
                [[AppManager getInstance]setUser:account];
                [[TMCache sharedCache] setObject:account forKey:@"user"];
                UIStoryboard *discoverSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                RootViewController *discoverNav = [discoverSB instantiateViewControllerWithIdentifier:@"Nav"];
                [self presentViewController:discoverNav animated:YES completion:nil];
            }else{
                
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                hub.detailsLabel.text = [NSString stringWithFormat:@"账号或密码错误"];
                [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
            }
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
    }];

}
-(void)loadData{
    NSArray *accountAndPassword = [Config getUserNameAndPassword];
    _loginView.userNameText.text = accountAndPassword? accountAndPassword[0] : @"";
    _loginView.passWordText.text = accountAndPassword? accountAndPassword[1] : @"";
    [self p_validUsernameAndPassword];
}
#pragma mark - 键盘操作

- (void)hidenKeyboard{
    [_loginView.userNameText resignFirstResponder];
    [_loginView.passWordText resignFirstResponder];
}

- (void)returnOnKeyboard:(UITextField *)sender{
    if (sender == _loginView.userNameText) {
        [_loginView.passWordText becomeFirstResponder];
    } else if (sender == _loginView.passWordText) {
        [self hidenKeyboard];
        if (_loginView.loginBtn.enabled) {
            [self loginBtnClick];
        }else{
            [self hidenKeyboard];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (![_loginView.userNameText isFirstResponder] && ![_loginView.passWordText isFirstResponder]) {
        return NO;
    }
    return YES;
}


@end
