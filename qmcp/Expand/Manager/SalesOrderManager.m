//
//  SalesOrderManager.m
//  qmcp
//
//  Created by 谢永明 on 16/4/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderManager.h"
#import "QMCPAPI.h"
#import "HttpUtil.h"
#import "SalesOrderMine.h"
#import "NSObject+LKDBHelper.h"
#import "MJExtension.h"
#import "SalesOrder.h"
#import "SalesOrderConfirm.h"
#import "Config.h"
#import "Utils.h"
#import "TMCache.h"
#import "MBProgressHUD.h"

NSString *const SalesOrderUpdateNotification = @"salesOrderUpdate";
@interface SalesOrderManager()

@end
@implementation SalesOrderManager

+ (SalesOrderManager *)getInstance {
    static SalesOrderManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

-(void)getSalesOrderMineByLastUpdateTime:(NSString *)lastupdateTime
                             finishBlock:(SalesOrderCompletion)completion{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERMINE,lastupdateTime];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            [Config setSaleOrderMineTime:[Utils formatDate:[NSDate new]]];
            SalesOrderMine *salesOrderMine = [SalesOrderMine mj_objectWithKeyValues:obj];
            if(salesOrderMine.uncompleted.count == 0){
                
            }else{
                NSArray *array = salesOrderMine.haveCompleted;
                for (NSString *code in array) {
                    NSString *where = [NSString stringWithFormat:@"code = '%@'",code];
                    [SalesOrder deleteWithWhere:where];

                }
                
                for (SalesOrder *salesOrder in salesOrderMine.uncompleted) {
                    salesOrder.addressSnapshot.code = salesOrder.code;
                    salesOrder.isMine = YES;
                    [salesOrder.salesOrderCommoditySnapshots enumerateObjectsUsingBlock:^(CommoditySnapshot * _Nonnull css, NSUInteger idx, BOOL * _Nonnull stop) {
                        css.code = [NSUUID UUID].UUIDString;
                    }];
                    [salesOrder saveToDB];
                }
                
            }

            completion([self sortSalesOrder:YES],nil);
            
        }else{
            completion(nil,error);
        }
    }];

}


- (NSMutableArray *)sortSalesOrder:(BOOL)isMine{
    
    NSString *salesOrderWhere = [NSString stringWithFormat:@"isMine = '%@'",[NSNumber numberWithBool:isMine]];
    NSMutableArray *salesOrders = [SalesOrder searchWithWhere:salesOrderWhere];

    [salesOrders sortUsingComparator:^NSComparisonResult(SalesOrder *  _Nonnull obj1, SalesOrder *  _Nonnull obj2) {
        int a1 = [[obj1.code componentsSeparatedByString:@"-"][1] intValue];
        int a2 = [[obj2.code componentsSeparatedByString:@"-"][1] intValue];
        return a1 < a2;
    }];
    return salesOrders;
}

-(void)getSalesOrderConfirmByLastUpdateTime:(NSString *)lastupdateTime
                                finishBlock:(SalesOrderCompletion)completion{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERCONFIRM,lastupdateTime];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            [Config setSalesOrderGrabTime:[Utils formatDate:[NSDate new]]];
            SalesOrderConfirm *salesOrderConfirm = [SalesOrderConfirm mj_objectWithKeyValues:obj];
           
            for (NSString *code in salesOrderConfirm.haveAssign) {
                NSString *where = [NSString stringWithFormat:@"code = '%@'",code];
                [SalesOrder deleteWithWhere:where];
            }
            NSArray<SalesOrder *> *unArr = [SalesOrder mj_objectArrayWithKeyValuesArray:salesOrderConfirm.unassigned];
            for (SalesOrder *salesOrder in unArr) {
                salesOrder.addressSnapshot.code = salesOrder.code;
                [salesOrder.salesOrderCommoditySnapshots enumerateObjectsUsingBlock:^(CommoditySnapshot * _Nonnull css, NSUInteger idx, BOOL * _Nonnull stop) {
                    css.code = [NSUUID UUID].UUIDString;
                }];
                salesOrder.isMine = NO;
                [salesOrder saveToDB];
            }
            
            completion([self sortSalesOrder:NO],nil);
            
        }else{
            completion([self sortSalesOrder:NO],error);
        }
    }];
    
}


@end
