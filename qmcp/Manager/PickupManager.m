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

@implementation PickupManager

+ (PickupManager *)getInstance {
    static PickupManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

-(void)itemCompleteByCode:(NSString *)itemCode finishBlock:(void (^)(NSDictionary *, NSError *))block{
    NSDictionary *dict = @{@"code":itemCode};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_ITEM_COMPLETE];
    [HttpUtil postFormData:URLString param:dict finish:^(NSDictionary *obj, NSError *error) {
        block(obj,error);
    }];
    
}
@end
