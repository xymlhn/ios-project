//
//  SalesOrderManager.h
//  qmcp
//
//  Created by 谢永明 on 16/4/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PchHeader.h"
#import "SalesOrderSnapshot.h"

@interface SalesOrderManager : NSObject

+ (SalesOrderManager *) getInstance;

/**
 *  获取绑单数据
 *
 *  @param lastupdateTime 时间
 */
-(void)getSalesOrderBindByLastUpdateTime:(NSString *)lastupdateTime
                             finishBlock:(CompletionHandler)completion;

/**
 *  获取接单数据
 *
 *  @param lastupdateTime 时间
 */
-(void)getSalesOrderConfirmByLastUpdateTime:(NSString *)lastupdateTime
                                finishBlock:(CompletionHandler)completion;

/**
 *  根据订单code删除接单字典中salesOrder
 *
 *  @param salesOrderCode 订单code
 */
-(void)removeGrabDictSalesOrderSnapshotByCode:(NSString *)salesOrderCode;

/**
 *  根据订单code删除绑单字典中salesOrder
 *
 *  @param salesOrderCode 订单code
 */
-(void)removeBindDictSalesOrderSnapshotByCode:(NSString *)salesOrderCode;

/**
 *  根据订单code更新绑定字典中的salesOrder
 *
 *  @param salesOrderSnapshot salesOrder
 */

-(void)updateGrabDictSalesOrderSnapshot:(SalesOrderSnapshot *)salesOrderSnapshot;
@end
