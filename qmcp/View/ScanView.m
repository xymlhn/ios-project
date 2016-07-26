//
//  ScanView.m
//  qmcp
//
//  Created by 谢永明 on 16/7/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "ScanView.h"

@implementation ScanView

+ (instancetype)scanViewInstance:(UIView *)view{
    ScanView *scanView = [ScanView new];
    [scanView setupView:view];
    return scanView;
}

-(void)setupView:(UIView *)rootView
{
    rootView.backgroundColor = [UIColor whiteColor];
    UIView *containView = [UIView new];
    [rootView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(rootView.mas_top).with.offset(100);
        make.left.equalTo(rootView.mas_left).with.offset(10);
        make.right.equalTo(rootView.mas_right).with.offset(-10);
        make.height.equalTo(@50);
    }];
    
    _scanText = [UITextField new];
    _scanText.font = [UIFont systemFontOfSize:12];//
    _scanText.textColor = [UIColor blackColor];
    _scanText.placeholder=@"请输入二维码";
    _scanText.borderStyle=UITextBorderStyleRoundedRect;
    
    _scanBtn = [UIButton new];
    [_scanBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_scanBtn.layer setMasksToBounds:YES];
    [_scanBtn.layer setCornerRadius:3.0];
    [_scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _scanBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [_scanBtn setBackgroundColor: [UIColor nameColor]];
    [containView addSubview:_scanBtn];
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(containView.mas_centerY);
        make.width.equalTo(@50);
        make.right.equalTo(containView.mas_right).with.offset(-10);
    }];
    
    [containView addSubview:_scanText];
    [_scanText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(containView.mas_centerY);
        make.right.equalTo(_scanBtn.mas_left).with.offset(-10);
        make.left.equalTo(containView.mas_left).with.offset(10);
        
    }];
}
@end
