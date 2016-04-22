//
//  EnumUtil.m
//  qmcp
//
//  Created by 谢永明 on 16/4/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "EnumUtil.h"

@implementation EnumUtil

+(NSString *)salesOrderTypeString:(SalesOrderType)type
{
    NSString *str = @"";
    switch (type) {
        case SalesOrderTypeShop:
            str = @"到店";
            break;
        case SalesOrderTypeOnsite:
            str = @"上门";
        default:
            break;
    }
    return str;
}

+(NSString *)workOrderTypeString:(WorkOrderType)type
{
    NSString *str = @"";
    switch (type) {
        case WorkOrderTypeOnsite:
            str = @"上门";
            break;
        case WorkOrderTypeService:
            str = @"服务";
            break;
        case WorkOrderTypeInventory:
            str = @"清点";
            break;
        default:
            break;
    }
    return str;
}
@end
