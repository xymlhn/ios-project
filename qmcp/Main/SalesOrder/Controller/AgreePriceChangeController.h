//
//  AgreePeiceChangeController.h
//  qmcp
//
//  Created by 谢永明 on 2016/11/22.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseViewController.h"

@interface AgreePriceChangeController : BaseViewController

@property (copy, nonatomic) void(^doneBlock)(NSString *price,NSString *remark);

+ (instancetype) doneBlock:(void(^)(NSString *price,NSString *remark))block;
@end
