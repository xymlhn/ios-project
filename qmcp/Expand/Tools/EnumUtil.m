//
//  EnumUtil.m
//  qmcp
//
//  Created by 谢永明 on 16/4/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "EnumUtil.h"

@implementation EnumUtil

+(NSString *)salesOrderTypeString:(SalesOrderType)type{
    NSString *str = @"";
    switch (type) {
        case SalesOrderTypeShop:
            str = @"到店";
            break;
        case SalesOrderTypeOnsite:
            str = @"上门";
            break;
        case SalesOrderTypeRemote:
            str = @"远程";
            break;
        default:
            break;
    }
    return str;
}

+(NSString *)workOrderTypeString:(WorkOrderType)type{
    NSString *str = @"";
    switch (type) {
        case WorkOrderTypeOnsite:
            str = @"上门";
            break;
        case WorkOrderTypeService:
            str = @"服务";
            break;
        default:
            break;
    }
    return str;
}

+(NSString *)formSortString:(FormSort)type{
    NSString *str = @"";
    switch (type) {
        case FormSortCreate:
            str = @"创建";
            break;
        case FormSortUpdate:
            str = @"编辑";
            break;
        case FormSortComplete:
            str = @"完成";
            break;
        default:
            break;
    }
    return str;
}

+(NSString *)pickupStatusString:(PickupStatus)type{
    NSString *str = @"";
    switch (type) {
        case PickupStatusUnPickup:
            str = @"暂无";
            break;
        case PickupStatusWaitToPickup:
            str = @"待取";
            break;
        case PickupStatusHasPickup:
            str = @"已取";
            break;
        default:
            break;
    }
    return str;
}

+(NSString *)exceptionTypeString:(int)type{
    NSString *str = @"";

    switch (type) {
        case ExceptionTypeNotLogin: {
            str = @"未登录";
            break;
        }
        case ExceptionTypeNoPermission: {
            str = @"未授权";
            break;
        }
        case ExceptionTypeNOUrl: {
            str = @"url错误";
            break;
        }
        case ExceptionTypeCommon: {
            str = @"服务器异常";
            break;
        }
        default:
            break;
    }
    return str;
}

@end
