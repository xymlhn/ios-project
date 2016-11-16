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
#import "CommodityStep.h"

@interface WorkOrderManager : NSObject

extern NSString *const WorkOrderUpdateNotification;

+ (WorkOrderManager *) getInstance;

/**
 *  获取步骤
 *
 *  @param commodityDict 名字
 *
 *  @return 步骤数组
 */
-(NSMutableArray *)getCommodityByCommodityCode:(NSMutableDictionary<NSString *,NSString *> *)commodityDict;
/**
 *  根据时间点获取工单
 *
 *  @param dateStr 时间戳
 */
-(void) getWorkOrderByLastUpdateTime:(NSString *) dateStr;

/**
 *  根据时间点获取服务常用步骤
 *
 *  @param dateStr 时间戳
 */
-(void) getCommodityStepByLastUpdateTime:(NSString *) dateStr;



/**
 *  根据工单code获取工单
 *
 *  @param itemCode 工单code
 *  @param block 回调
 */
-(void)getWorkOrderByItemCode:(NSString *)itemCode
                  finishBlock:(CompletionHandler)completion;


/**
 *  提交附件
 *
 *  @param attachment 附件model
 *  @param block      回调
 */
-(void)postAttachment:(Attachment *)attachment
          finishBlock:(CompletionHandler)completion;

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
-(void)searchWorkOrderWithString:(NSString *)string
                    andCondition:(BOOL)condition
                     finishBlock:(CompletionHandler)completion;
@end
