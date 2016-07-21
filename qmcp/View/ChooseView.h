//
//  ChooseView.h
//  qmcp
//
//  Created by 谢永明 on 16/7/3.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface ChooseView : BaseView
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UITableView *tableView;

+ (instancetype)chooseViewInstance:(UIView *)view;
@end
