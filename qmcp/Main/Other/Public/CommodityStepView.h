//
//  CommodityStepView.h
//  qmcp
//
//  Created by 谢永明 on 16/9/1.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface CommodityStepView : BaseView
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UITableView *tableView;

+ (instancetype)viewInstance;
@end
