//
//  WorkOrderInventoryEditController.h
//  qmcp
//
//  Created by 谢永明 on 16/4/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseWorkOrderViewController.h"
#import "ItemSnapshot.h"

@interface WorkOrderInventoryEditController : BaseWorkOrderViewController

@property (copy, nonatomic) void(^doneBlock)(ItemSnapshot *item);

+ (instancetype) doneBlock:(void(^)(ItemSnapshot *item))block;

@end
