//
//  PickupManager.m
//  qmcp
//
//  Created by 谢永明 on 16/7/7.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "PickupManager.h"
#import "OSCAPI.h"
#import "HttpUtil.h"
#import "PickupSignature.h"
#import "MJExtension.h"

@implementation PickupManager

+ (PickupManager *)getInstance {
    static PickupManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

-(void)itemCompleteByCode:(NSString *)itemCode finishBlock:(CompletionHandler)completion{
    NSDictionary *dict = @{@"code":itemCode};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_ITEM_COMPLETE];
    [HttpUtil postFormData:URLString param:dict finish:^(NSDictionary *obj, NSString *error) {
        completion(obj,error);
    }];
    
}

-(void)getPickupItemByCode:(NSString *)itemCode finishBlock:(CompletionHandler)completion{

    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_PICKUPITEM,itemCode];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        completion(obj,error);
    }];
}

-(void)postPickupSignature:(PickupSignature *)pickupSignature finishBlock:(CompletionHandler)completion{
    NSDictionary *obj = [pickupSignature mj_keyValues];
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_PICKUPSIGNATURE];
    [HttpUtil post:URLString param:obj finish:^(NSDictionary *obj, NSString *error) {
        completion(obj,error);
    }];
}
@end
