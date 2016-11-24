//
//  QrCodeIdentityView.m
//  qmcp
//
//  Created by 谢永明 on 16/7/3.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "QrCodeIdentityView.h"
#import "Utils.h"

@implementation QrCodeIdentityView

+ (instancetype)viewInstance{
    QrCodeIdentityView *qrCodeIdentityView = [QrCodeIdentityView new];
    return qrCodeIdentityView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *alphaView = [UIView new];
    _baseView = [UIView new];
    alphaView.backgroundColor = [UIColor whiteColor];
    _baseView.backgroundColor = [UIColor blackColor];
    _baseView.alpha = 0.2;
    [self addSubview:_baseView];
    [self addSubview:alphaView];
    
    _imageView = [UIImageView new];
    [alphaView addSubview:_imageView];
    
    UILabel *tips = [UILabel new];
    tips.font = [UIFont systemFontOfSize:12];//
    tips.text = @"扫一扫验证身份";
    tips.textColor = [UIColor blackColor];
    [alphaView addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(alphaView.mas_centerX);
        make.top.equalTo(alphaView.mas_top).with.offset(10);
    }];
    
    _confirmBtn = [UIButton new];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn.layer setMasksToBounds:YES];
    [_confirmBtn.layer setCornerRadius:5.0];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [_confirmBtn setBackgroundColor: [UIColor nameColor]];
    [alphaView addSubview:_confirmBtn];
    
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@250);
        make.height.equalTo(@300);
    }];
    
    [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alphaView.mas_top).with.offset(30);
        make.width.equalTo(@200);
        make.height.equalTo(@200);
        make.centerX.equalTo(alphaView.mas_centerX);
        
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(alphaView).with.offset(-20);
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.width.equalTo(@60);
        make.height.equalTo(@32);
    }];
    return self;
    
}

-(void)setQrCodeUrl:(NSString *)qrCodeUrl{
    _imageView.image = [Utils createQRCodeFromString:qrCodeUrl];
}

@end
