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
- (void)postWorkOrderStep:(WorkOrder *)workOrder andStep:(NSArray *)steps;

-(void)updateTimeStamp :(NSString *)workOrderCode timeStamp:(WorkOrderTimeStamp)timeStamp time:(NSString *)time;

-(void)postPickUpItem;

-(void)getWorkOrderByItemCode:(NSString *)itemCode;

@end
