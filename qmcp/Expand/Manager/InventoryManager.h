//
//  InventoryManager.h
//  qmcp
//
//  Created by 谢永明 on 16/8/25.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SalesOrderSearchResult.h"
#import "SalesOrder.h"
typedef void(^SalesOrderSearchHandler)(NSMutableArray<SalesOrderSearchResult *> *array, NSString *error);
@interface InventoryManager : NSObject
@property (nonatomic,strong) NSString *currentSalesOrderCode;
+ (InventoryManager *)getInstance;

/**
 *  根据号码获取订单
 *
 *  @param phone      号码
 *  @param completion 回调
 */
-(void)getSalesOrderSearchResult:(NSString *)phone
                     finishBlock:(SalesOrderSearchHandler)completion;

/**
 *  根据订单code获取订单
 *
 *  @param code 订单code
 *
 *  @return 订单
 */
-(SalesOrderSearchResult *)getSalesOrderSearchResultByCode:(NSString *)code;


/**
 添加清点订单

 @param result 清点订单

 @return bool
 */
-(SalesOrderSearchResult *)salesOrderChangeToSearchResult:(SalesOrder *) salesOrder;


/**
 添加salesOrderResult

 @param salesOrderSearchResult salesOrderSearchResult description
 */
-(void)appendSalesOrderSearchResult:(SalesOrderSearchResult *)salesOrderSearchResult;
@end
