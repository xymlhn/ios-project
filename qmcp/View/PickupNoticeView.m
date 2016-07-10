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
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [containView addSubview:topView];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [topView addSubview:codeBottomLine];
    
    _searchBar = [UISearchBar new];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [_searchBar setPlaceholder:@"请输入物品编号"];
    [topView addSubview:_searchBar];
    
    _qrButton = [UILabel new];
    [_qrButton setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _qrButton.text = @"";
    _qrButton.textColor = [UIColor nameColor];
    _qrButton.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:_qrButton];
    
    _tableView = [UITableView new];
    _tableView.rowHeight = 30;
    _tableView.backgroundColor = [UIColor themeColor];
    [containView addSubview:_tableView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containView.mas_top).with.offset(5);
        make.left.equalTo(containView.mas_left);
        make.right.equalTo(containView.mas_right);
        make.height.equalTo(@50);
    }];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(topView.mas_bottom).with.offset(-3);
        make.left.equalTo(topView.mas_left).with.offset(0);
        make.right.equalTo(topView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    [_qrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(topView.mas_left).with.offset(5);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.equalTo(@30);
        make.height.equalTo(@40);
        
    }];
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_qrButton.mas_right).with.offset(0);
        make.right.equalTo(topView.mas_right).with.offset(5);
        make.centerY.equalTo(topView.mas_centerY).with.offset(-2);
        make.height.equalTo(@50);
    }];
    

    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.left.equalTo(containView.mas_left).with.offset(0);
        make.right.equalTo(containView.mas_right).with.offset(0);
        make.top.equalTo(_searchBar.mas_bottom).with.offset(0);
        make.bottom.equalTo(containView.mas_bottom).with.offset(0);
    }];
}
@end
