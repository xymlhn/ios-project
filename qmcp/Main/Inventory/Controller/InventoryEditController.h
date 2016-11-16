//
//  WorkOrderInventoryEditController.h
//  qmcp
//
//  Created by 谢永明 on 16/4/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseViewController.h"
#import "ItemSnapshot.h"

@interface InventoryEditController : BaseViewController

@property (nonatomic, assign) SaveType saveType;

@property (nonatomic, copy) NSString *salesOrderCode;

@property (nonatomic, copy) NSString *itemSnapshotCode;

@property (copy, nonatomic) void(^doneBlock)(ItemSnapshot *item,SaveType type);

+ (instancetype) doneBlock:(void(^)(ItemSnapshot *item,SaveType type))block;

@end
