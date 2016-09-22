//
//  QrCodeBindController.h
//  qmcp
//
//  Created by 谢永明 on 16/6/29.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseViewController.h"

@interface QrCodeImageController : BaseViewController

@property (nonatomic,copy) NSString *qrCodeUrl;
@property (nonatomic,copy) NSString *salesOrderCode;
@property (copy, nonatomic) void(^doneBlock)(NSString *value);

+ (instancetype) doneBlock:(void(^)(NSString *value))block;
@end
