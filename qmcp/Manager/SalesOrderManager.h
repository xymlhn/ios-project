//
//  SalesOrderManager.h
//  qmcp
//
//  Created by 谢永明 on 16/4/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalesOrderManager : NSObject

+ (SalesOrderManager *) getInstance;

/**
 *  获取绑单数据
 *
 *  @param lastupdateTime 时间
 */
-(void)getSalesOrderBind:(NSString *)lastupdateTime;

/**
 *  获取接单数据
 *
 *  @param lastupdateTime 时间
 */
-(void)getSalesOrderConfirm:(NSString *)lastupdateTime;

/**
 *  接单按钮点击进行接单
 *
 *  @param salesOrderCode 订单code
 */
-(void)grabSalesOrder:(NSString *)salesOrderCode;
@end
