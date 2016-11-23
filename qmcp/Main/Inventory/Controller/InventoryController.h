//
//  WorkOrderInventoryController.h
//  qmcp
//
//  Created by 谢永明 on 16/4/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface InventoryController : BaseViewController

@property (nonatomic,copy) NSString *salesOrderCode;

@property (copy, nonatomic) void(^doneBlock)(BOOL signFlag);

+ (instancetype) doneBlock:(void(^)(BOOL signFlag))block;
@end
