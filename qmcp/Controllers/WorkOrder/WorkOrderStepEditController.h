//
//  WorkOrderStepEditController.h
//  qmcp
//
//  Created by 谢永明 on 16/4/2.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseWorkOrderViewController.h"
#import "WorkOrderStep.h"
@interface WorkOrderStepEditController : BaseWorkOrderViewController

@property (copy, nonatomic) void(^doneBlock)(WorkOrderStep *step,bool isDelete);

+ (instancetype) doneBlock:(void(^)(WorkOrderStep *step,bool isDelete))block;
@end
