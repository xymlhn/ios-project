//
//  PickupNoticeView.m
//  qmcp
//
//  Created by 谢永明 on 16/7/7.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "PickupNoticeView.h"

@implementation PickupNoticeView

-(void)initView:(UIView *)rootView
{
    rootView.backgroundColor = [UIColor whiteColor];
    
    UIView *containView = [UIView new];
    [containView setBackgroundColor:[UIColor whiteColor]];
    [rootView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    _searchBar = [UISearchBar new];
    [_searchBar setPlaceholder:@"请输入物品编号"];
    [containView addSubview:_searchBar];
    
    _qrButton = [UILabel new];
    [_qrButton setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    _qrButton.text = @"";
    _qrButton.textColor = [UIColor nameColor];
    _qrButton.textAlignment = NSTextAlignmentCenter;
    [containView addSubview:_qrButton];

    _tableView = [UITableView new];
    _tableView.rowHeight = 30;
    _tableView.backgroundColor = [UIColor themeColor];
    [containView addSubview:_tableView];
    
    [_qrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containView.mas_top).with.offset(0);
        make.left.equalTo(containView.mas_left).with.offset(0);
        make.height.equalTo(@35);
        make.width.equalTo(@35);
    }];
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containView.mas_top).with.offset(0);
        make.left.equalTo(_qrButton.mas_right).with.offset(0);
        make.right.equalTo(containView.mas_right).with.offset(0);
        make.height.equalTo(@35);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.left.equalTo(containView.mas_left).with.offset(0);
        make.right.equalTo(containView.mas_right).with.offset(0);
        make.top.equalTo(_searchBar.mas_bottom).with.offset(0);
        make.bottom.equalTo(containView.mas_bottom).with.offset(0);
    }];
}
@end
