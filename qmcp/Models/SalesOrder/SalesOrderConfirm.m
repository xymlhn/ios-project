//
//  SalesOrderConfirm.m
//  qmcp
//
//  Created by 谢永明 on 16/4/17.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderConfirm.h"
#import "MJExtension.h"
@implementation SalesOrderConfirm
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"unconfirmed":@"SalesOrderSnapshot",
             @"haveConfirmed":[NSString class]};
}
@end
