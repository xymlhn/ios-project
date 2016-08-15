//
//  InventorySearchView.h
//  qmcp
//
//  Created by 谢永明 on 16/8/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface InventorySearchView : BaseView
@property(nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,strong) UITableView *tableView;

+ (instancetype)viewInstance;
@end
