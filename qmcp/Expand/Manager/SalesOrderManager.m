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

-(BOOL)saveOrUpdateSalesOrder:(SalesOrder *)salesOrder{
    salesOrder.addressSnapshot.code = salesOrder.code;
    [salesOrder.salesOrderCommoditySnapshots enumerateObjectsUsingBlock:^(CommoditySnapshot * _Nonnull css, NSUInteger idx, BOOL * _Nonnull stop) {
        css.code = [NSUUID UUID].UUIDString;
    }];
    return [salesOrder saveToDB];
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
                    [self saveOrUpdateSalesOrder:salesOrder];
                }
                
            }

            completion([self getAllSalesOrder],nil);
            
        }else{
            completion(nil,error);
        }
    }];

}


- (NSMutableArray *)getAllSalesOrder{
    
    NSMutableArray *salesOrders = [SalesOrder searchWithWhere:nil];

    [salesOrders sortUsingComparator:^NSComparisonResult(SalesOrder *  _Nonnull obj1, SalesOrder *  _Nonnull obj2) {
        int a1 = [[obj1.code componentsSeparatedByString:@"-"][1] intValue];
        int a2 = [[obj2.code componentsSeparatedByString:@"-"][1] intValue];
        return a1 < a2;
    }];
    return salesOrders;
}

-(void)getSalesOrderConfirm:(SalesOrderCompletion)completion{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERCONFIRM];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            NSMutableArray<SalesOrder *> *salesOrders = [SalesOrder mj_objectArrayWithKeyValuesArray:obj];
            [salesOrders sortUsingComparator:^NSComparisonResult(SalesOrder *  _Nonnull obj1, SalesOrder *  _Nonnull obj2) {
                int a1 = [[obj1.code componentsSeparatedByString:@"-"][1] intValue];
                int a2 = [[obj2.code componentsSeparatedByString:@"-"][1] intValue];
                return a1 < a2;
            }];
            completion(salesOrders,nil);
            
        }else{
            completion(nil,error);
        }
    }];
    
}


@end
