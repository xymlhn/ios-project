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

-(void)getSalesOrderBind:(NSString *)lastupdateTime;

-(void)getSalesOrderConfirm:(NSString *)lastupdateTime;

-(void)grabSalesOrder:(NSString *)salesOrderCode;
@end
