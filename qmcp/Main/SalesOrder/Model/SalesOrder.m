//
//  SalesOrder.m
//  qmcp
//
//  Created by 谢永明 on 2016/9/22.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrder.h"

@implementation SalesOrder
+ (NSString*)getPrimaryKey
{
    return @"code";
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"itemSnapshots":@"ItemSnapshot",
             @"salesOrderCommoditySnapshots":@"CommoditySnapshot"};
}
@end
