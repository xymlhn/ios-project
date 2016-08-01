//
//  WorkOrderFormView.h
//  qmcp
//
//  Created by 谢永明 on 16/7/23.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface WorkOrderFormView : BaseView

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,strong) UIButton *completeBtn;


+ (instancetype)viewInstance;
@end
