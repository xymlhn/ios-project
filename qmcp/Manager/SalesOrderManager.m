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

-(void)getSalesOrderBind:(NSString *)lastupdateTime
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
            [self getSalesOrderBind:[Config getSalesOrderBindTime]];
        }
    }];

}

-(void)getSalesOrderConfirm:(NSString *)lastupdateTime
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_SALESORDERCONFIRM,lastupdateTime];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            [Config setSalesOrderGrabTime:[Utils formatDate:[NSDate new]]];
            SalesOrderConfirm *salesOrderConfirm = [SalesOrderConfirm mj_objectWithKeyValues:obj];
            if(salesOrderConfirm.unconfirmed.count == 0){
                
            }else{
                for (NSString *code in salesOrderConfirm.haveConfirmed) {
                    [_grabDict removeObjectForKey:code];
                }
                
                for (SalesOrderSnapshot *salesOrder in salesOrderConfirm.unconfirmed) {
                    _grabDict[salesOrderConfirm.unconfirmed] = salesOrder;
                }
                [[TMCache sharedCache] setObject:_grabDict forKey:kConfirmCache];
                
            }
            
            [self notifyGrabUIChange];
            
        }else{
            [self getSalesOrderConfirm:[Config getSalesOrderGrabTime]];
        }
    }];
    
}

-(void)grabSalesOrder:(NSString *)salesOrderCode
{
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"抢单中...";
    hub.userInteractionEnabled = NO;
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_SALESORDERGRAB,salesOrderCode];
    NSDictionary *dict = @{@"grab":[NSNumber numberWithBool:YES]};
    [HttpUtil post:URLString param:dict finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            [_grabDict removeObjectForKey:salesOrderCode];
            [[TMCache sharedCache] setObject:_grabDict forKey:kConfirmCache];
            [self notifyGrabUIChange];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = [NSString stringWithFormat:@"抢单成功"];
            [hub hide:YES afterDelay:0.5];
        }else{
            NSString *message = @"";
            if(obj == nil){
                message =@"抢单失败";
            }else{
                message = [obj valueForKey:@"message"];
            }
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = message;
            [hub hide:YES afterDelay:0.5];
        }
    }];
    
}

/**
 *  通知接单界面
 */
-(void)notifyGrabUIChange
{
    NSDictionary *dict = @{@"salesOrderGrab":[_grabDict allValues]};
    NSNotification * notice = [NSNotification notificationWithName:kSalesOrderGrabNotification object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

@end
