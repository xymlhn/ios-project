//
//  QrCodeBind.h
//  qmcp
//
//  Created by 谢永明 on 16/6/29.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface QrCodeBindView : BaseView

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,copy) NSString *qrCodeUrl;

+ (instancetype)viewInstance;
@end
