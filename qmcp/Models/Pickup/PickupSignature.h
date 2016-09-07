//
//  PickupSignature.h
//  qmcp
//
//  Created by 谢永明 on 16/7/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickupSignature : NSObject
@property (nonatomic,copy) NSString *salesOrderCode;
@property (nonatomic,copy) NSString *pickupTime;
@property (nonatomic,copy) NSString *signatureImageKey;
@property (nonatomic,strong) NSMutableArray<NSString *> *itemCodes;
@end
