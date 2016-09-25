//
//  WorkOrderFormController.h
//  qmcp
//
//  Created by 谢永明 on 16/6/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WorkOrderFormController : BaseViewController

@property (nonatomic,copy)NSString *formTemplateId;
@property(nonatomic, copy) NSString *workOrderCode;
@end
