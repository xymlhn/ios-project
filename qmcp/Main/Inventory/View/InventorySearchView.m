//
//  InventorySearchView.m
//  qmcp
//
//  Created by 谢永明 on 16/8/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "InventorySearchView.h"

@implementation InventorySearchView

+ (instancetype)viewInstance{
    InventorySearchView *searchView = [InventorySearchView new];
    return searchView;
}
- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *containView = [UIView new];
    [containView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _searchBar = [UISearchBar new];
    _searchBar.placeholder = @"请输入";
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [containView addSubview:_searchBar];
    
    _tableView = [UITableView new];
    _tableView.rowHeight = 80;
    _tableView.backgroundColor = [UIColor whiteColor];
    [containView addSubview:_tableView];
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containView.mas_top).with.offset(0);
        make.left.equalTo(containView.mas_left).with.offset(0);
        make.right.equalTo(containView.mas_right).with.offset(0);
        make.height.equalTo(@50);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_searchBar.mas_bottom).with.offset(0);
        make.left.equalTo(containView.mas_left).with.offset(0);
        make.right.equalTo(containView.mas_right).with.offset(0);
        make.bottom.equalTo(containView.mas_bottom).with.offset(0);
    }];
    return self;
}

@end
