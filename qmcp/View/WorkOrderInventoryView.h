//
//  WorkOrderInventoryView.h
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface WorkOrderInventoryView : BaseView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)UILabel *addBtn;
@property (nonatomic,strong)UILabel *signBtn;

@end
