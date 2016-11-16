//
//  SalesOrderStepEditController.h
//  qmcp
//
//  Created by 谢永明 on 2016/9/23.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseViewController.h"
#import "WorkOrderStep.h"
@interface SalesOrderStepEditController : BaseViewController

@property (nonatomic,copy) NSString *code;

@property (nonatomic, copy) NSString *stepId;

@property (nonatomic, assign) SaveType saveType;

@property (copy, nonatomic) void(^doneBlock)(WorkOrderStep *step,SaveType type);

+ (instancetype) doneBlock:(void(^)(WorkOrderStep *step,SaveType type))block;
@end
