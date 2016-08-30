//
//  WorkOrderStepCell.h
//  qmcp
//
//  Created by 谢永明 on 16/3/30.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrderStep.h"

@interface WorkOrderStepCell : UITableViewCell

@property (nonatomic, strong) WorkOrderStep *workOrderStep;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
