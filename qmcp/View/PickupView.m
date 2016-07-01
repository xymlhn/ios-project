//
//  PickupView.m
//  qmcp
//
//  Created by 谢永明 on 16/7/1.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "PickupView.h"

@implementation PickupView

-(void)initView:(UIView *)rootView
{
    rootView.backgroundColor = [UIColor whiteColor];
    
    UIView *containView = [UIView new];
    [containView setBackgroundColor:[UIColor whiteColor]];
    [rootView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView).with.insets(UIEdgeInsetsMake(69, 5, 5, 5));
    }];
    
    _searchBar = [UISearchBar new];
    [containView addSubview:_searchBar];
    
    _tableView = [UITableView new];
    _tableView.rowHeight = 100;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor themeColor];
    [containView addSubview:_tableView];
    
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView).with.insets(UIEdgeInsetsMake(69, 5, 5, 5));
    }];
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
}
@end
