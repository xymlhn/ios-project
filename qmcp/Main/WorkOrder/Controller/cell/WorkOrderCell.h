//
//  WorkOrderCell.h
//  qmcp
//
//  Created by 谢永明 on 16/6/20.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrder.h"
@interface WorkOrderCell : UITableViewCell

@property (nonatomic, strong) WorkOrder *workOrder;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
