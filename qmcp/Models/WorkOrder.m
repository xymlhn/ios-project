//
//  WorkOrder.m
//  qmcp
//
//  Created by 谢永明 on 16/3/11.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrder.h"

@implementation WorkOrder

+ (NSString*)getPrimaryKey
{
    return @"code";
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"processDetail":@"WorkOrderStep",
             @"commoditySnapshots":@"CommoditySnapshot"};
}
@end
