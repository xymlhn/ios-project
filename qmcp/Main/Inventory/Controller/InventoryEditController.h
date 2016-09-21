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


@property (nonatomic, copy) NSString *salesOrderCode;

@property (nonatomic, copy) NSString *itemSnapshotCode;

@property (copy, nonatomic) void(^doneBlock)(BOOL isDelete, ItemSnapshot *item);

+ (instancetype) doneBlock:(void(^)(BOOL isDelete, ItemSnapshot *item))block;

@end
