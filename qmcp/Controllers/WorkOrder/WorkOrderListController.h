//
//  WorkOrderControllerViewController.h
//  qmcp
//
//  Created by 谢永明 on 16/3/29.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrder.h"
#import "BaseWorkOrderViewController.h"

/**
    这里继承BaseViewController 会导致tabbar字体消失
 */
@interface WorkOrderListController : UIViewController

- (instancetype)initWithStatus:(WorkOrderStatus)status;

@end
