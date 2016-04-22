//
//  WorkOrderListTableViewCell.h
//  qmcp
//
//  Created by 谢永明 on 16/3/25.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkOrder;
@interface WorkOrderListCell : UITableViewCell

@property(nonatomic,strong)UIView *middleView;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *bottomView;

@property (nonatomic, strong) WorkOrder *workOrder;
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
