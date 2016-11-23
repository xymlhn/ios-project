//
//  InventoryManager.m
//  qmcp
//
//  Created by 谢永明 on 16/8/25.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "InventoryManager.h"
#import "QMCPAPI.h"
#import "HttpUtil.h"
#import "MJExtension.h"
#import "CommoditySnapshot.h"

@interface InventoryManager()

@property (nonatomic,strong) NSMutableArray<SalesOrderSearchResult *> *resultList;

@end

@implementation InventoryManager

+ (InventoryManager *)getInstance {
    static InventoryManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
        if(shared_manager.resultList == nil){
            shared_manager.resultList = [NSMutableArray new];
        }
    });
    return shared_manager;
}

-(void)getSalesOrderSearchResult:(NSString *)phone
                     finishBlock:(SalesOrderSearchHandler)completion{
    NSString *URLString = [NSString stringWithFormat:@"%@%@?phoneNumber=%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERSEARCH,phone];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            _resultList = [SalesOrderSearchResult mj_objectArrayWithKeyValuesArray:obj];
            completion(_resultList,nil);
        }else{
            completion(nil,error);
        }
    }];
    
}



-(SalesOrderSearchResult *)getSalesOrderSearchResultByCode:(NSString *)code{
    SalesOrderSearchResult *result;
    for (int i = 0; i < _resultList.count; i++) {
        if([_resultList[i].code isEqualToString:code]){
            result = _resultList[i];
        }
    }
    return result;
}

-(SalesOrderSearchResult *)salesOrderChangeToSearchResult:(SalesOrder *)salesOrder{
    SalesOrderSearchResult *ssr = [SalesOrderSearchResult new];
    ssr.code = salesOrder.code;
    ssr.appointmentTime = salesOrder.appointmentTime;
    ssr.commodityNames = [salesOrder.commodityNames componentsJoinedByString:@","];
    ssr.storePricingReviewFlag = salesOrder.storePricingReviewFlag;
    return ssr;
}

-(void)appendSalesOrderSearchResult:(SalesOrderSearchResult *)salesOrderSearchResult{
    [_resultList enumerateObjectsUsingBlock:^(SalesOrderSearchResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.code isEqualToString:salesOrderSearchResult.code]) {
            *stop = YES;
            [_resultList removeObject:obj];
        }
    }];
    [_resultList addObject:salesOrderSearchResult];
}
@end
