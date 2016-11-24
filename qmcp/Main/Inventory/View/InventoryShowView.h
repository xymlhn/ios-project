//
//  InventoryShowView.h
//  qmcp
//
//  Created by 谢永明 on 2016/11/24.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface InventoryShowView : BaseView
@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UIButton *cancelBtn;
+ (instancetype)viewInstance;
@end
