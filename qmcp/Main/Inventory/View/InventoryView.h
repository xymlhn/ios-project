//
//  WorkOrderInventoryView.h
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface InventoryView : BaseView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)UIButton *addBtn;
@property (nonatomic,strong)UIButton *signBtn;

+ (instancetype)viewInstance;
@end
