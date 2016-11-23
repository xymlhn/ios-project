//
//  AgressPriceChangeView.m
//  qmcp
//
//  Created by 谢永明 on 2016/11/22.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "AgreePriceChangeView.h"

@implementation AgreePriceChangeView


+ (instancetype)viewInstance{
    AgreePriceChangeView *checkBoxView = [AgreePriceChangeView new];
    return checkBoxView;
}


- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    _baseView = [UIView new];
    [self addSubview:_baseView];
    
    UIView *alphaView = [UIView new];
    alphaView.backgroundColor = [UIColor whiteColor];
    _baseView.backgroundColor = [UIColor blackColor];
    _baseView.alpha = 0.2;
    [self addSubview:alphaView];
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor grayColor];
    [alphaView addSubview:topView];
    
    _cancelBtn = [UIButton new];
    [_cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [topView addSubview:_cancelBtn];
    
    _priceText = [UITextField new];
    _priceText.font = [UIFont systemFontOfSize:12];
    _priceText.placeholder = @"请输入价格";
    _priceText.borderStyle=UITextBorderStyleRoundedRect;
    _priceText.textColor = [UIColor blackColor];
    [alphaView addSubview:_priceText];
    
    _remarkText = [UITextView new];
    _remarkText.font = [UIFont systemFontOfSize:12];
    _remarkText.textColor = [UIColor blackColor];
    _remarkText.layer.borderColor = [UIColor arrowColor].CGColor;
    _remarkText.layer.borderWidth = 0.5;
    _remarkText.layer.cornerRadius =5.0;
    [alphaView addSubview:_remarkText];
    
    _saveBtn = [UIButton new];
    _saveBtn.layer.masksToBounds = YES;
    _saveBtn.backgroundColor = [UIColor nameColor];
    _saveBtn.layer.cornerRadius = 3.0;
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [alphaView addSubview:_saveBtn];
    
    [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_centerY);
    }];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alphaView.mas_left).with.offset(0);
        make.right.equalTo(alphaView.mas_right).with.offset(0);
        make.top.equalTo(alphaView.mas_top);
        make.height.equalTo(@30);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.right.equalTo(topView.mas_right).with.offset(-kPaddingLeftWidth);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    
    [_priceText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(topView.mas_bottom).with.offset(10);
        make.left.equalTo(alphaView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(alphaView.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(@30);
    }];
    
    [_remarkText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_priceText.mas_bottom).with.offset(10);
        make.left.equalTo(alphaView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(alphaView.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(@60);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_remarkText.mas_bottom).with.offset(10);
        make.left.equalTo(alphaView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(alphaView.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(@30);
    }];
    return self;
}

@end
