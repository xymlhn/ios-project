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
#import "PchHeader.h"

@interface WorkOrderManager : NSObject

extern NSString *const WorkOrderUpdateNotification;

+ (WorkOrderManager *) getInstance;

/**
 *  根据时间点获取工单
 *
 *  @param dateStr 时间戳
 */
-(void) getWorkOrderByLastUpdateTime:(NSString *) dateStr;

/**
 *  上传工单一般步骤
 *
 *  @param workOrder 工单
 *  @param steps     工单步骤
 */
- (void)postWorkOrderStepWithCode:(NSString *)code andParams:(NSDictionary *)params finishBlock:(CompletionHandler)completion;

/**
 *  上传清点单数据
 *
 *  @param params     参数
 *  @param completion 回调
 */
-(void)postWorkOrderInventoryWithCode:(NSString *) code andParams:(NSDictionary *)params finishBlock:(CompletionHandler)completion;


/**
 *  更新
 *
 *  @param workOrderCode 工单code
 *  @param params        请求参数
 *  @param block         回调
 */
-(void)updateTimeStampWithCode:(NSString *)code andParams:(NSDictionary *)params finishBlock:(CompletionHandler)completion;

/**
 *  根据工单code获取工单
 *
 *  @param itemCode 工单code
 *  @param block 回调
 */
-(void)getWorkOrderByItemCode:(NSString *)itemCode finishBlock:(CompletionHandler)completion;


/**
 *  提交附件
 *
 *  @param attachment 附件model
 *  @param block      回调
 */
-(void)postAttachment:(Attachment *)attachment finishBlock:(CompletionHandler)completion;

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

/**
 *  根据工单code,获取工单
 *
 *  @param code 工单code
 */
-(void)getWorkOrderByCode:(NSString *)code;

/**
 *  搜索工单
 *
 *  @param string    字符
 *  @param condition 是否包含历史工单
 *  @param block     回调
 */
-(void)searchWorkOrderWithString:(NSString *)string andCondition:(BOOL)condition finishBlock:(CompletionHandler)completion;
@end
