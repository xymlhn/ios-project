//
//  SearchView.h
//  qmcp
//
//  Created by 谢永明 on 16/7/2.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface SearchView : BaseView
@property(nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,strong) UITableView *tableView;

+ (instancetype)searchViewInstance:(UIView *)view;
@end
