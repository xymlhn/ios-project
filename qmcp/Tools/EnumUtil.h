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

@interface EnumUtil : NSObject

+(NSString *)salesOrderTypeString:(SalesOrderType)type;

+(NSString *)workOrderTypeString:(WorkOrderType)type;

@end
