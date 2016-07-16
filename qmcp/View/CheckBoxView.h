//
//  CheckBoxView.h
//  qmcp
//
//  Created by 谢永明 on 16/7/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface CheckBoxView : BaseView

@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *confirmBtn;
@end
