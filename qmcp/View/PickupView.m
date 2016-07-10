//
//  PickupView.m
//  qmcp
//
//  Created by 谢永明 on 16/7/1.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "PickupView.h"
@interface PickupView()

@end
@implementation PickupView

-(void)initView:(UIView *)rootView
{
    rootView.backgroundColor = [UIColor whiteColor];
    
    UIView *containView = [UIView new];
    [containView setBackgroundColor:[UIColor whiteColor]];
    [rootView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView).with.insets(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    _headView = [UIView new];
    [_headView setBackgroundColor:[UIColor whiteColor]];
    [rootView addSubview:_headView];
    
    _codeText = [UILabel new];
    _codeText.text = @"订单编号";
    _codeText.font = [UIFont systemFontOfSize:15];//采用系统默认文字设置大小
    _codeText.textColor = [UIColor blackColor];
    [_headView addSubview:_codeText];
    
    _nameText = [UILabel new];
    _nameText.text = @"客户名称";
    _nameText.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    _nameText.textColor = [UIColor blackColor];
    [_headView addSubview:_nameText];
    
    _phoneText = [UILabel new];
    _phoneText.text = @"联系电话";
    _phoneText.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    _phoneText.textColor = [UIColor blackColor];
    [_headView addSubview:_phoneText];
    
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
    _tableView.rowHeight = 80;
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
    
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchBar.mas_bottom).with.offset(0);
        make.left.equalTo(containView.mas_left).with.offset(0);
        make.right.equalTo(containView.mas_right);
        make.height.equalTo(@40);
    }];
    
    [_codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_top).with.offset(5);
        make.centerX.equalTo(_headView.mas_centerX);
    }];
    
    
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeText.mas_bottom).with.offset(0);
        make.left.equalTo(_headView.mas_left).with.offset(15);
    }];

    
    [_phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeText.mas_bottom).with.offset(0);
        make.left.equalTo(_headView.mas_centerX).with.offset(15);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.equalTo(containView.mas_left).with.offset(0);
        make.right.equalTo(containView.mas_right).with.offset(0);
        make.top.equalTo(_headView.mas_bottom).with.offset(0);
        make.bottom.equalTo(containView.mas_bottom).with.offset(0);
    }];
    
    [self initBottomView:rootView];
}


-(void)initBottomView:(UIView *)rootView
{
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [rootView addSubview:bottomView];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:codeBottomLine];
    
    _signButton = [UILabel new];
    [_signButton setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _signButton.text = @"";
    _signButton.textColor = [UIColor nameColor];
    _signButton.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_signButton];
    
    
    UILabel *signLabel = [UILabel new];
    signLabel.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    signLabel.text = @"签名";
    signLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:signLabel];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(rootView.mas_bottom).with.offset(0);
        make.left.equalTo(rootView.mas_left).with.offset(0);
        make.right.equalTo(rootView.mas_right).with.offset(0);
        make.height.mas_equalTo(@50);
    }];
    
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(bottomView.mas_top).with.offset(0);
        make.left.equalTo(bottomView.mas_left).with.offset(0);
        make.right.equalTo(bottomView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    [_signButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(bottomView.mas_top).offset(3);
        make.centerX.equalTo(bottomView.mas_centerX);
    }];
    [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_signButton.mas_bottom);
        make.centerX.equalTo(_signButton.mas_centerX);
    }];
    
}
@end
