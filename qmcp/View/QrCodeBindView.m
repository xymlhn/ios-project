//
//  QrCodeBind.m
//  qmcp
//
//  Created by 谢永明 on 16/6/29.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "QrCodeBindView.h"
#import "Utils.h"

@implementation QrCodeBindView

-(void)initView:(UIView *)rootView
{
    rootView.backgroundColor = [UIColor clearColor];

    UIView *alphaView = [UIView new];
    _baseView = [UIView new];
    alphaView.backgroundColor = [UIColor whiteColor];
    _baseView.backgroundColor = [UIColor blackColor];
    _baseView.alpha = 0.2;
    [rootView addSubview:_baseView];
    [rootView addSubview:alphaView];

    _imageView = [UIImageView new];
    [alphaView addSubview:_imageView];
    
    _confirmBtn = [UIButton new];
    [_confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmBtn.layer setMasksToBounds:YES];
    [_confirmBtn.layer setCornerRadius:5.0];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [_confirmBtn setBackgroundColor: [UIColor nameColor]];
    [alphaView addSubview:_confirmBtn];

    _cancelBtn = [UIButton new];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn.layer setMasksToBounds:YES];
    [_cancelBtn.layer setCornerRadius:5.0];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [_cancelBtn setBackgroundColor: [UIColor orangeColor]];
    [alphaView addSubview:_cancelBtn];

    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootView.mas_centerX);
        make.centerY.equalTo(rootView.mas_centerY);
        make.width.equalTo(@250);
        make.height.equalTo(@300);
    }];
    
    [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView);
    }];
    
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alphaView.mas_top).with.offset(30);
        make.width.equalTo(@200);
        make.height.equalTo(@200);
        make.centerX.equalTo(alphaView.mas_centerX);

    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(alphaView).with.offset(-20);
        make.right.equalTo(rootView.mas_centerX).with.offset(-20);
        make.width.equalTo(@65);
        make.height.equalTo(@35);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(alphaView).with.offset(-20);
        make.left.equalTo(rootView.mas_centerX).with.offset(20);
        make.width.equalTo(@65);
        make.height.equalTo(@35);
    }];
}

-(void)setQrCodeUrl:(NSString *)qrCodeUrl{
    _imageView.image = [Utils createQRCodeFromString:qrCodeUrl];
}
@end
