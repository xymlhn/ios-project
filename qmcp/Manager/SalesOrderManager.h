//
//  SalesOrderManager.h
//  qmcp
//
//  Created by 谢永明 on 16/4/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalesOrderManager : NSObject

extern NSString *const kSalesOrderBindNotification;
extern NSString *const kSalesOrderGrabNotification;

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

-(void)removeGrabDictBySaleOrderCode:(NSString *)salesOrderCode;


@end
