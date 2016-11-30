//
//  AgressPriceChangeView.m
//  qmcp
//
//  Created by 谢永明 on 2016/11/22.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderAgreePriceView.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>
@implementation SalesOrderAgreePriceView


+ (instancetype)viewInstance{
    SalesOrderAgreePriceView *checkBoxView = [SalesOrderAgreePriceView new];
    return checkBoxView;
}


- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
   
    _priceText = [UITextField new];
    _priceText.font = [UIFont systemFontOfSize:12];
    _priceText.placeholder = @"请输入价格";
    _priceText.borderStyle=UITextBorderStyleRoundedRect;
    _priceText.textColor = [UIColor blackColor];
    [self addSubview:_priceText];
    
    _remarkText = [UITextView new];
    _remarkText.font = [UIFont systemFontOfSize:12];
    _remarkText.textColor = [UIColor blackColor];
    _remarkText.layer.borderColor = [UIColor arrowColor].CGColor;
    _remarkText.layer.borderWidth = 0.5;
    _remarkText.layer.cornerRadius =5.0;
    _remarkText.placeholder = @"必填项";
    _remarkText.placeholderColor = [UIColor lightGrayColor];
    [self addSubview:_remarkText];
    
    _saveBtn = [UIButton new];
    _saveBtn.layer.masksToBounds = YES;
    _saveBtn.backgroundColor = [UIColor nameColor];
    _saveBtn.layer.cornerRadius = 3.0;
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self addSubview:_saveBtn];

    [_priceText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(15);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(@30);
    }];
    
    [_remarkText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_priceText.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(@60);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_remarkText.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(@30);
    }];
    return self;
}

@end
