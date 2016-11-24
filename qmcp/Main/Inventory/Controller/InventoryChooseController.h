//
//  InventoryChooseController.h
//  qmcp
//
//  Created by 谢永明 on 16/8/29.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseViewController.h"

@interface InventoryChooseController : BaseViewController

@property (nonatomic, copy) NSString *itemSnapshotCode;

@property (copy, nonatomic) void(^doneBlock)(NSMutableArray *commodies);

+ (instancetype) doneBlock:(void(^)(NSMutableArray *commodies))block;
@end
