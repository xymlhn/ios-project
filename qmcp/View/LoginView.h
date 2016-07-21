//
//  LoginView.h
//  qmcp
//
//  Created by 谢永明 on 16/4/10.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"
@interface LoginView : BaseView

@property (nonatomic,strong) UITextField *userNameText;
@property (nonatomic,strong) UITextField *passWordText;

@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *settingBtn;

+ (instancetype)loginViewInstance:(UIView *)view;
@end
