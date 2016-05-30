//
//  SalesOrderManager.m
//  qmcp
//
//  Created by 谢永明 on 16/4/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderManager.h"
#import "OSCAPI.h"
#import "HttpUtil.h"
#import "SalesOrderBind.h"
#import "NSObject+LKDBHelper.h"
#import "MJExtension.h"
#import "SalesOrderSnapshot.h"
#import "SalesOrderConfirm.h"
#import "Config.h"
#import "Utils.h"
#import "TMCache.h"
#import "MBProgressHUD.h"

NSString *const kBindCache = @"bind";
NSString *const kConfirmCache = @"confirm";

NSString *const kSalesOrderBindNotification = @"salesOrderBindUpdate";
NSString *const kSalesOrderGrabNotification = @"salesOrderGrabUpdate";

@interface SalesOrderManager()

@property(nonatomic,strong)NSMutableDictionary<NSString *,SalesOrderSnapshot *> *bindDict; //绑单

@property(nonatomic,strong)NSMutableDictionary<NSString *,SalesOrderSnapshot *> *grabDict; //接单

@end
@implementation SalesOrderManager

+ (SalesOrderManager *)getInstance {
    static SalesOrderManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
        shared_manager.bindDict = [[TMCache sharedCache] objectForKey:kBindCache];
        if(shared_manager.bindDict == nil)
        {
            shared_manager.bindDict = [NSMutableDictionary new];
        }
        shared_manager.grabDict = [[TMCache sharedCache] objectForKey:kConfirmCache];
        if(shared_manager.grabDict == nil)
        {
            shared_manager.grabDict = [NSMutableDictionary new];
        }
    });
    return shared_manager;
}

-(void)getSalesOrderBindByLastUpdateTime:(NSString *)lastupdateTime
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_SALESORDERBIND,lastupdateTime];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            [Config setSaleOrderBindTime:[Utils formatDate:[NSDate new]]];
            SalesOrderBind *salesOrderBind = [SalesOrderBind mj_objectWithKeyValues:obj];
            if(salesOrderBind.unbound.count == 0){
                
            }else{
                NSArray *array = salesOrderBind.haveBound;
                for (NSString *code in array) {
                    [_bindDict removeObjectForKey:code];
                }
                
                for (SalesOrderSnapshot *salesOrder in salesOrderBind.unbound) {
                    _bindDict[salesOrder.code] = salesOrder;
                }
                [[TMCache sharedCache] setObject:_bindDict forKey:kBindCache];
                
            }

            NSDictionary *dict = @{@"salesOrderBind":[_bindDict allValues]};
            NSNotification * notice = [NSNotification notificationWithName:kSalesOrderBindNotification object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
        }else{
            [self getSalesOrderBindByLastUpdateTime:[Config getSalesOrderBindTime]];
        }
    }];

}

-(void)getSalesOrderConfirmByLastUpdateTime:(NSString *)lastupdateTime
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_SALESORDERCONFIRM,lastupdateTime];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            [Config setSalesOrderGrabTime:[Utils formatDate:[NSDate new]]];
            SalesOrderConfirm *salesOrderConfirm = [SalesOrderConfirm mj_objectWithKeyValues:obj];
           
            for (NSString *code in salesOrderConfirm.haveConfirmed) {
                [_grabDict removeObjectForKey:code];
            }
            
            for (SalesOrderSnapshot *salesOrder in salesOrderConfirm.unconfirmed) {
                _grabDict[salesOrder.code] = salesOrder;
            }
            [[TMCache sharedCache] setObject:_grabDict forKey:kConfirmCache];
                
            NSDictionary *dict = @{@"salesOrderGrab":[_grabDict allValues]};
            NSNotification * notice = [NSNotification notificationWithName:kSalesOrderGrabNotification object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
        }else{
            [self getSalesOrderConfirmByLastUpdateTime:[Config getSalesOrderGrabTime]];
        }
    }];
    
}

-(void)removeGrabDictBySaleOrderCode:(NSString *)salesOrderCode
{
    [_grabDict removeObjectForKey:salesOrderCode];
    [[TMCache sharedCache] setObject:_grabDict forKey:kConfirmCache];
}

@end
