//
//  LoginController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/10.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "ReactiveCocoa.h"
#import "Config.h"
#import "AppManager.h"
#import "SettingViewController.h"
@interface LoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property LoginView *loginView;

@end

@implementation LoginViewController

-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    _loginView = [LoginView new];
    [_loginView initView:self.view];
    
    [self setUpSubviews];
    
    NSArray *accountAndPassword = [Config getOwnAccountAndPassword];
    _loginView.userNameText.text = accountAndPassword? accountAndPassword[0] : @"";
    _loginView.passWordText.text = accountAndPassword? accountAndPassword[1] : @"";
    [self validUsernameAndPassword];
}

-(void)bindListener
{
    
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
    NSString * regex = @"^[A-Za-z0-9@]{1,15}$";
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

- (void)setUpSubviews
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
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (![_loginView.userNameText isFirstResponder] && ![_loginView.userNameText isFirstResponder]) {
        return NO;
    }
    return YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
-(void)loadData{}
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
    [[AppManager getInstance] login:self userName:username password:password];
}

@end
