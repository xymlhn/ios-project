//
//  EnumUtil.h
//  qmcp
//
//  Created by 谢永明 on 16/4/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SalesOrderSnapshot.h"
#import "WorkOrder.h"
#import "PchHeader.h"
#import "FormTemplateBrife.h"
#import "PickupItem.h"

@interface EnumUtil : NSObject

+(NSString *)salesOrderTypeString:(SalesOrderType)type;

+(NSString *)workOrderTypeString:(WorkOrderType)type;

+(NSString *)formSortString:(FormSort)type;

+(NSString *)pickupStatusString:(PickupStatus)type;

+(NSString *)exceptionTypeString:(int)type;
@end
