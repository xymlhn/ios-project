//
//  PickupNoticeView.h
//  qmcp
//
//  Created by 谢永明 on 16/7/7.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface PickupNoticeView : BaseView
@property(nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UILabel *qrButton;

+ (instancetype)viewInstance;
@end
