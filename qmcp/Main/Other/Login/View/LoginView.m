//
//  LoginView.m
//  qmcp
//
//  Created by 谢永明 on 16/4/10.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

+ (instancetype)viewInstance{
    LoginView *loginView = [LoginView new];
    return loginView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];

    
    
    UIImageView *logoIcon = [UIImageView new];
    logoIcon.image = [UIImage imageNamed:@"login_logo"];
    [self addSubview:logoIcon];
  
    UILabel *logoWordText = [UILabel new];
    logoWordText.font = [UIFont systemFontOfSize:18];
    logoWordText.text = @"登录工作客户端";
    logoWordText.textColor = [UIColor arrowColor];
    [self addSubview:logoWordText];
    
    UIView *userNameView = [UIView new];
    userNameView.backgroundColor = [UIColor whiteColor];
    [self addSubview:userNameView];
    
    UILabel *userIcon = [UILabel new];
    [userIcon setFont:[UIFont fontWithName:@"FontAwesome" size:18]];
    userIcon.text = @"";
    userIcon.textColor = [UIColor appBlueColor];
    [userNameView addSubview:userIcon];
    
    UIView *userLine = [UIView new];
    userLine.backgroundColor = [UIColor lineColor];
    [userNameView addSubview:userLine];
    
    _userNameText = [UITextField new];
    _userNameText.clearButtonMode=UITextFieldViewModeWhileEditing;
    _userNameText.placeholder = @"请输入用户名";
    _userNameText.returnKeyType = UIReturnKeyNext;
    _userNameText.font = [UIFont systemFontOfSize:kShisipt];
    _userNameText.textColor = [UIColor colorWithRed:114.0/255 green:114.0/255 blue:114.0/255 alpha:1.0];
    [_userNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_userNameText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [userNameView addSubview:_userNameText];

    
    UIView *passwordView = [UIView new];
    passwordView.backgroundColor = [UIColor whiteColor];
    [self addSubview:passwordView];
    
    
    UILabel *paswordIcon = [UILabel new];
    [paswordIcon setFont:[UIFont fontWithName:@"FontAwesome" size:18]];
    paswordIcon.text = @"";
    paswordIcon.textColor = [UIColor appBlueColor];
    [passwordView addSubview:paswordIcon];
    
    _passWordText = [UITextField new];
    _passWordText.placeholder = @"请输入密码";
    _passWordText.returnKeyType = UIReturnKeyDone;
    _passWordText.clearButtonMode=UITextFieldViewModeWhileEditing;
    [_passWordText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _passWordText.font = [UIFont systemFontOfSize:kShisipt];
    _passWordText.textColor = [UIColor colorWithRed:114.0/255 green:114.0/255 blue:114.0/255 alpha:1.0];
    _passWordText.keyboardType = UIKeyboardAppearanceDefault;
    _passWordText.returnKeyType = UIReturnKeySend;
    _passWordText.secureTextEntry = YES;
    
    [passwordView addSubview:_passWordText];
    UIView *passwordLine = [UIView new];
    passwordLine.backgroundColor = [UIColor lineColor];
    [passwordView addSubview:passwordLine];
    
    _loginBtn = [UIButton new];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn.layer setMasksToBounds:YES];
    [_loginBtn.layer setCornerRadius:kBottomButtonCorner];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize: kShisipt];
    [_loginBtn setBackgroundColor: [UIColor appBlueColor]];
    [self addSubview:_loginBtn];

    
    [logoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(96);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [logoWordText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(logoIcon.mas_bottom).with.offset(33);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
   
    [userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@250);
        make.height.equalTo(@35);
        make.top.equalTo(logoWordText.mas_bottom).with.offset(45);
    }];
    
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(userNameView.mas_centerY);
        make.left.equalTo(userNameView.mas_left).with.offset(0);
    }];
    
    
    [_userNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIcon.mas_right).with.offset(15);
        make.right.equalTo(userNameView.mas_right).with.offset(-15);
        make.centerY.equalTo(userNameView.mas_centerY);
        
    }];

    [userLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(userNameView.mas_bottom).with.offset(0);
        make.left.equalTo(userNameView.mas_left).with.offset(0);
        make.right.equalTo(userNameView.mas_right).with.offset(0);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@250);
        make.top.equalTo(userNameView.mas_bottom).with.offset(25);
        make.height.equalTo(@35);
    }];
    
    [paswordIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(passwordView.mas_centerY);
        make.left.equalTo(passwordView.mas_left).with.offset(0);
    }];
    
    [_passWordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(paswordIcon.mas_right).with.offset(15);
        make.right.equalTo(passwordView.mas_right).with.offset(-15);
        make.centerY.equalTo(paswordIcon.mas_centerY);
        
    }];
    
    [passwordLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(passwordView.mas_bottom).with.offset(0);
        make.left.equalTo(passwordView.mas_left).with.offset(0);
        make.right.equalTo(passwordView.mas_right).with.offset(0);
        make.height.mas_equalTo(kLineHeight);
    }];

 
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).with.offset(67);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@250);
        make.height.equalTo(@40);
    }];

    return self;
}

@end
