//
//  SalesOrderBind.m
//  qmcp
//
//  Created by 谢永明 on 16/4/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderMine.h"
#import "MJExtension.h"
@implementation SalesOrderMine

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"uncompleted":@"SalesOrder",
             @"haveCompleted":[NSString class]};
}
@end
