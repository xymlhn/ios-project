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
-(void) getWorkOrderByLastUpdateTime:(NSString *) dateStr;

/**
 *  上传工单步骤
 *
 *  @param workOrder 工单
 *  @param steps     工单步骤
 */
- (void)postWorkOrderStepWithURL:(NSString *)URLString andParams:(NSDictionary *)params finishBlock:(void (^)(NSDictionary *, NSError *))block;

/**
 *  完成该订单所有的工单步骤,可以取件了
 *
 *  @param workOrderCode 工单code
 */
- (void)completeAllStepsWithURL:(NSString *)URLString andParams:(NSDictionary *)params finishBlock:(void (^)(NSDictionary *, NSError *))block;

/**
 *  更新
 *
 *  @param workOrderCode 工单code
 *  @param params        请求参数
 *  @param block         回调
 */
-(void)updateTimeStampWithURL:(NSString *)URLString andParams:(NSDictionary *)params finishBlock:(void (^)(NSDictionary *, NSError *))block;

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

/**
 *  提交附件
 *
 *  @param attachment 附件model
 *  @param block      回调
 */
-(void)postAttachment:(Attachment *)attachment finishBlock:(void (^)(NSDictionary *, NSError *))block;

/**
 *  从数据库获取工单显示
 */
- (void)sortAllWorkOrder;

/**
 *  根据code查找工单
 *
 *  @param code 工单code
 *
 *  @return 工单
 */
-(WorkOrder *)findWorkOrderByCode:(NSString *)code;
@end
