//
//  BusinessSalesOrderController.h
//  qmcp
//
//  Created by 谢永明 on 2016/9/22.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseViewController.h"

@interface BusinessSalesOrderController : BaseViewController

@property (copy, nonatomic) void(^doneBlock)(NSString *code);
+ (instancetype) doneBlock:(void(^)(NSString *code))block;

@end
