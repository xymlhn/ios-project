//
//  SalesOrderManager.h
//  qmcp
//
//  Created by 谢永明 on 16/4/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PchHeader.h"
#import "SalesOrder.h"

@interface SalesOrderManager : NSObject

extern NSString *const SalesOrderUpdateNotification;
+ (SalesOrderManager *) getInstance;

/**
 *  获取绑单数据
 *
 *  @param lastupdateTime 时间
 */
-(void)getSalesOrderMineByLastUpdateTime:(NSString *)lastupdateTime
                             finishBlock:(SalesOrderCompletion)completion;


/**
 获取接单数据

 @param completion <#completion description#>
 */
-(void)getSalesOrderConfirm:(SalesOrderCompletion)completion;


/**
 根据类型获取订单

 @param isMine isMine description

 @return 订单列表
 */
- (NSMutableArray *)getAllSalesOrder;

/**
 跟新我的订单

 @param salesOrder 订单
 @return bool
 */
-(BOOL)saveOrUpdateSalesOrder:(SalesOrder *)salesOrder;
@end
