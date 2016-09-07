//
//  QrCodeIdentityView.h
//  qmcp
//
//  Created by 谢永明 on 16/7/3.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface QrCodeIdentityView : BaseView

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,copy) NSString *qrCodeUrl;


+ (instancetype)viewInstance;
@end
