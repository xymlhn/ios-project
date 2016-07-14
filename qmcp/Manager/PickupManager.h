//
//  PickupManager.h
//  qmcp
//
//  Created by 谢永明 on 16/7/7.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PickupSignature.h"
#import "PchHeader.h"

@interface PickupManager : NSObject

+ (PickupManager *)getInstance;

/**
 *  完成物品
 *
 *  @param itemCode 物品code
 *  @param block    回调
 */
-(void)itemCompleteByCode:(NSString *)itemCode finishBlock:(CompletionHandler)completion;

/**
 *  获取待取物品信息
 *
 *  @param itemCode 物品code
 *  @param block    回调
 */
-(void)getPickupItemByCode:(NSString *)itemCode finishBlock:(CompletionHandler)completion;

/**
 *  提交取件物品
 *
 *  @param pickupSignature model
 *  @param block           回调
 */
-(void)postPickupSignature:(PickupSignature *)pickupSignature finishBlock:(CompletionHandler)completion;
@end
