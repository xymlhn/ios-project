//
//  WorkOrderStepEditController.h
//  qmcp
//
//  Created by 谢永明 on 16/4/2.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseViewController.h"
#import "WorkOrderStep.h"
@interface WorkOrderStepEditController : BaseViewController

@property (copy, nonatomic) void(^doneBlock)(WorkOrderStep *step,SaveType type);
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *stepCode;
@property (nonatomic, assign) SaveType type;
@property (nonatomic, assign) FuncType funcType;
+ (instancetype) doneBlock:(void(^)(WorkOrderStep *step,SaveType type))block;
@end
