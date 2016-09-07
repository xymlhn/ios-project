//
//  SalesOrderBind.m
//  qmcp
//
//  Created by 谢永明 on 16/4/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderBind.h"
#import "MJExtension.h"
@implementation SalesOrderBind

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"unbound":@"SalesOrderSnapshot",
             @"haveBound":[NSString class]};
}
@end
