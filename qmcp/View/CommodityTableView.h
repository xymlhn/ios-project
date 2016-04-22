//
//  CommodityTableView.h
//  qmcp
//
//  Created by 谢永明 on 16/4/20.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface CommodityTableView : UIView

@property (nonatomic, strong) UITableView *tableView;
+ (instancetype)defaultPopupView;
@end
