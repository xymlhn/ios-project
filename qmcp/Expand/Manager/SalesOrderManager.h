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


+ (SalesOrderManager *) getInstance;

/**
 *  获取绑单数据
 *
 *  @param lastupdateTime 时间
 */
-(void)getSalesOrderMineByLastUpdateTime:(NSString *)lastupdateTime
                             finishBlock:(SalesOrderCompletion)completion;

/**
 *  获取接单数据
 *
 *  @param lastupdateTime 时间
 */
-(void)getSalesOrderConfirmByLastUpdateTime:(NSString *)lastupdateTime
                                finishBlock:(SalesOrderCompletion)completion;


/**
 根据类型获取订单

 @param isMine isMine description

 @return 订单列表
 */
- (NSMutableArray *)sortSalesOrder:(BOOL)isMine;
@end
