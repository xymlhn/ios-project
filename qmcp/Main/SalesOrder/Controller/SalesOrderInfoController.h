//
//  SalesOrderInfoController.h
//  qmcp
//
//  Created by 谢永明 on 2016/9/23.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseViewController.h"

@interface SalesOrderInfoController : BaseViewController

@property (copy, nonatomic) void(^doneBlock)(NSString *code);

+ (instancetype) doneBlock:(void(^)(NSString *code))block;

@property (nonatomic,copy) NSString *code;
@end
