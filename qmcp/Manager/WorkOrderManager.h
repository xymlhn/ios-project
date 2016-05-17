//
//  WorkOrderManager.h
//  qmcp
//
//  Created by 谢永明 on 16/3/17.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkOrder.h"
#import "Attachment.h"

@interface WorkOrderManager : NSObject

extern NSString *const kWorkOrderUpdateNotification;

+ (WorkOrderManager *) getInstance;

/**
 *  根据时间点获取工单
 *
 *  @param dateStr 时间戳
 */
-(void) getAllWorkOrder:(NSString *) dateStr;

/**
 *  上传工单步骤
 *
 *  @param workOrder 工单
 *  @param steps     工单步骤
 */
- (void)postWorkOrderStep:(WorkOrder *)workOrder andStep:(NSArray *)steps isComplete:(BOOL)isComplete isCompleteAll:(BOOL)isCompleteAll;

/**
 *  完成该订单所有的工单步骤,可以取件了
 *
 *  @param workOrderCode 工单code
 */
- (void)completeAllSteps:(NSString *)workOrderCode;

/**
 *  更新时间戳
 *
 *  @param workOrderCode 工单code
 *  @param timeStamp     时间戳枚举
 *  @param time          时间
 */
-(void)updateTimeStamp :(NSString *)workOrderCode timeStamp:(WorkOrderTimeStamp)timeStamp time:(NSString *)time;

/**
 *  根据工单code获取工单
 *
 *  @param itemCode 工单code
 */
-(void)getWorkOrderByItemCode:(NSString *)itemCode;

/**
 *  上传取件数据
 */
-(void)postPickUpItem;

@end
