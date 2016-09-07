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

@property LoginView *loginView;

@end

@implementation LoginViewController
- (void) viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)loadView
{
    _loginView = [LoginView new];
    self.view = _loginView;
}

-(void)bindListener
{
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
    
    _loginView.settingBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SettingViewController *setting = [SettingViewController new];
        [self.navigationController pushViewController:setting animated:YES];
        return [RACSignal empty];
    }];

}
/**
 *  用户名密码验证
 */
-(void)validUsernameAndPassword
{
    RACSignal *validUsernameSignal = [_loginView.userNameText.rac_textSignal
                                      map:^id(NSString *text) {
                                          return @([self isValidUsername:text]);
                                      }];
    RAC(_loginView.userNameText, textColor) =[validUsernameSignal map:^id(NSNumber *usernameValid){
        return[usernameValid boolValue] ? [UIColor blackColor]:[UIColor redColor];
    }];
    
    RACSignal *validPasswordSignal = [_loginView.passWordText.rac_textSignal
                                      map:^id(NSString *text) {
                                          return @([self isValidPassword:text]);
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
-(BOOL)isValidUsername:(NSString *)text
{
    NSString * regex = @"^[A-Za-z0-9@]{1,20}$";
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
-(BOOL)isValidPassword:(NSString *)text
{
    return text.length > 0;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (![_loginView.userNameText isFirstResponder] && ![_loginView.userNameText isFirstResponder]) {
        return NO;
    }
    return YES;
}

-(void)loadData{
    NSArray *accountAndPassword = [Config getOwnAccountAndPassword];
    _loginView.userNameText.text = accountAndPassword? accountAndPassword[0] : @"";
    _loginView.passWordText.text = accountAndPassword? accountAndPassword[1] : @"";
    [self validUsernameAndPassword];
}
#pragma mark - 键盘操作

- (void)hidenKeyboard
{
    [_loginView.userNameText resignFirstResponder];
    [_loginView.passWordText resignFirstResponder];
}

- (void)returnOnKeyboard:(UITextField *)sender
{
    if (sender == _loginView.userNameText) {
        [_loginView.passWordText becomeFirstResponder];
    } else if (sender == _loginView.passWordText) {
        [self hidenKeyboard];
        if (_loginView.loginBtn.enabled) {
            [self loginBtnClick];
        }
    }
}

-(void)loginBtnClick
{
    NSString *username = _loginView.userNameText.text;
    NSString *password = _loginView.passWordText.text;
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在登录";
    hub.userInteractionEnabled = NO;
    
    [[AppManager getInstance] loginWithUserName:username andPassword:password finishBlock:^(id data, NSString *error) {
        if(!error){
            // 字典转模型
            User *account = [User mj_objectWithKeyValues:data];
            if(account.isAuthenticated){
                [Config saveOwnAccount:username andPassword:password];
                [Config saveLoginStatus:true];
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                hub.labelText = [NSString stringWithFormat:@"登录成功"];
                [hub hide:YES afterDelay:kEndSucceedDelayTime];
                [[AppManager getInstance]setUser:account];
                [[TMCache sharedCache] setObject:account forKey:@"user"];
                UIStoryboard *discoverSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                RootViewController *discoverNav = [discoverSB instantiateViewControllerWithIdentifier:@"Nav"];
                [self presentViewController:discoverNav animated:YES completion:nil];
            }else{
                
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                hub.labelText = [NSString stringWithFormat:@"账号或密码错误"];
                [hub hide:YES afterDelay:kEndFailedDelayTime];
            }
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kEndFailedDelayTime];
        }
    }];
}

@end
