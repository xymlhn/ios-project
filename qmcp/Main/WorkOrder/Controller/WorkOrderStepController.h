//
//  WorkOrderStepController.h
//  qmcp
//
//  Created by 谢永明 on 16/3/30.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WorkOrderStepController : BaseViewController

@property(nonatomic, copy) NSString *code;
@property (nonatomic, assign) FuncType funcType;
@end
