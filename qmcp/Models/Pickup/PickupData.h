//
//  PickupData.h
//  qmcp
//
//  Created by 谢永明 on 16/7/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressSnapshot.h"
#import "PickupItem.h"

@interface PickupData : NSObject
@property (nonatomic,copy) NSString *salesOrderCode;
@property (nonatomic,strong) AddressSnapshot *addressSnapshot;

@property (nonatomic,strong) NSArray<PickupItem *> *items;

@end
