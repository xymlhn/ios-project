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
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor nameColor];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@300);
    }];
    
    UIImageView *logoIcon = [UIImageView new];
    logoIcon.image = [UIImage imageNamed:@"logo_word"];
    [topView addSubview:logoIcon];
    [logoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).with.offset(50);
        make.centerX.equalTo(topView.mas_centerX);
    }];
    
    
    UILabel *logoWordText = [UILabel new];
    logoWordText.font = [UIFont systemFontOfSize:20];//
    logoWordText.text = @"只为提供一流的贴心服务";
    logoWordText.textColor = [UIColor whiteColor];
    [topView addSubview:logoWordText];
    [logoWordText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(logoIcon.mas_bottom).with.offset(15);
        make.centerX.equalTo(topView.mas_centerX);
    }];

    
    UIView *userNameView = [UIView new];
    userNameView.backgroundColor = [UIColor whiteColor];
    userNameView.layer.cornerRadius = 4;
    userNameView.layer.masksToBounds = YES;
    [topView addSubview:userNameView];
    [userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(25);
        make.right.equalTo(self.mas_right).with.offset(-25);
        make.height.equalTo(@35);
        make.top.equalTo(logoWordText.mas_bottom).with.offset(30);
    }];
    
    UILabel *userIcon = [UILabel new];
    [userIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    userIcon.text = @"";
    userIcon.textColor = [UIColor blackColor];
    [userNameView addSubview:userIcon];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(userNameView.mas_centerY);
        make.left.equalTo(userNameView.mas_left).with.offset(10);
        make.width.equalTo(@20);
    }];
    _userNameText = [UITextField new];
    _userNameText.clearButtonMode=UITextFieldViewModeWhileEditing;
    _userNameText.placeholder = @"请输入用户名";
    _userNameText.font = [UIFont systemFontOfSize:18];
    [_userNameText setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_userNameText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [userNameView addSubview:_userNameText];
    [_userNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIcon.mas_right).with.offset(5);
        make.right.equalTo(userNameView.mas_right).with.offset(-5);
        make.centerY.equalTo(userNameView.mas_centerY);
        make.height.mas_equalTo(30);
        
    }];
    
    UIView *passwordView = [UIView new];
    passwordView.layer.cornerRadius = 4;
    passwordView.layer.masksToBounds = YES;
    passwordView.backgroundColor = [UIColor whiteColor];
    [topView addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(25);
        make.right.equalTo(self.mas_right).with.offset(-25);
        make.height.equalTo(@35);
        make.top.equalTo(userNameView.mas_bottom).with.offset(20);
    }];
    
    UILabel *paswordIcon = [UILabel new];
    [paswordIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    paswordIcon.text = @"";
    paswordIcon.textColor = [UIColor blackColor];
    [passwordView addSubview:paswordIcon];
    [paswordIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(passwordView.mas_centerY);
        make.left.equalTo(passwordView.mas_left).with.offset(10);
        make.width.equalTo(@20);
    }];
    
    _passWordText = [UITextField new];
    _passWordText.placeholder = @"请输入密码";
    _passWordText.clearButtonMode=UITextFieldViewModeWhileEditing;
    [_passWordText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    _passWordText.font = [UIFont systemFontOfSize:18];
    _passWordText.keyboardType = UIKeyboardAppearanceDefault;
    _passWordText.returnKeyType = UIReturnKeyDone;
    
    _passWordText.secureTextEntry = YES;
    [passwordView addSubview:_passWordText];
    [_passWordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(paswordIcon.mas_right).with.offset(5);
        make.right.equalTo(passwordView.mas_right).with.offset(-5);
        make.centerY.equalTo(passwordView.mas_centerY);
        make.height.mas_equalTo(30);
        
    }];
    
    UIImageView *circleIcon = [UIImageView new];
    circleIcon.image = [UIImage imageNamed:@"half_circle"];
    [self addSubview:circleIcon];
    [circleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@35);
    }];
    
    _loginBtn = [UIButton new];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn.layer setMasksToBounds:YES];
    [_loginBtn.layer setCornerRadius:5.0];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [_loginBtn setBackgroundColor: [UIColor nameColor]];
    [self addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(circleIcon.mas_bottom).with.offset(20);
        make.left.equalTo(self.mas_left).with.offset(25);
        make.right.equalTo(self.mas_right).with.offset(-25);
        make.height.equalTo(@40);
    }];
    
    _settingBtn = [UIButton new];
    [_settingBtn setTitle:@"设置" forState:UIControlStateNormal];
    [_settingBtn.layer setMasksToBounds:YES];
    [_settingBtn.layer setCornerRadius:5.0];
    [_settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _settingBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [_settingBtn setBackgroundColor: [UIColor orangeColor]];
    [self addSubview:_settingBtn];
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).with.offset(15);
        make.left.equalTo(self.mas_left).with.offset(25);
        make.right.equalTo(self.mas_right).with.offset(-25);
        make.height.equalTo(@40);
    }];
    return self;
}

@end
