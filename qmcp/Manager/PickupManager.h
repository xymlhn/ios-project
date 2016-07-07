//
//  PickupManager.h
//  qmcp
//
//  Created by 谢永明 on 16/7/7.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickupManager : NSObject

+ (PickupManager *)getInstance;

/**
 *  完成物品
 *
 *  @param itemCode 物品code
 *  @param block    回调
 */
-(void)itemCompleteByCode:(NSString *)itemCode finishBlock:(void (^)(NSDictionary *, NSError *))block;

@end
