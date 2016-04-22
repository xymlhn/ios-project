//
//  PickupItemSignature.h
//  qmcp
//
//  Created by 谢永明 on 16/4/14.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickupItemSignature : NSObject

@property (nonatomic, copy) NSString *salesOrderCode;

@property (nonatomic, copy) NSString *pickupTime;

@property (nonatomic, copy) NSArray *itemCodes;

@property (nonatomic, copy) NSString *signatureImageKey;

@end
