//
//  PickupItem.h
//  qmcp
//
//  Created by 谢永明 on 16/7/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Attachment.h"

typedef NS_ENUM(NSInteger, PickupStatus) {
    PickupStatusUnPickup = 10,//暂无
    PickupStatusWaitToPickup = 20,//待取
    PickupStatusHasPickup = 30,//已取
};

@interface PickupItem : NSObject
@property (nonatomic,copy) NSString *code;
@property (nonatomic,assign) PickupStatus pickupStatus;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) NSArray<Attachment *> *attachments;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,assign) BOOL isChoose;
@end
