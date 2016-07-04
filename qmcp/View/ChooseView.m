//
//  ChooseView.m
//  qmcp
//
//  Created by 谢永明 on 16/7/3.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "ChooseView.h"

@implementation ChooseView
-(void)initView:(UIView *)rootView
{
    rootView.backgroundColor = [UIColor clearColor];
    
    UIView *alphaView = [UIView new];
    _baseView = [UIView new];
    alphaView.backgroundColor = [UIColor whiteColor];
    _baseView.backgroundColor = [UIColor blackColor];
    _baseView.alpha = 0.2;
    [rootView addSubview:_baseView];
    [rootView addSubview:alphaView];

    [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView);
    }];
    
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rootView.mas_left);
        make.right.equalTo(rootView.mas_right);
        make.bottom.equalTo(rootView.mas_bottom);
        make.top.equalTo(rootView.mas_centerY);
    }];
    
    _tableView = [UITableView new];
    _tableView.rowHeight = 80;
    _tableView.backgroundColor = [UIColor themeColor];
    [alphaView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(alphaView);
    }];

    
}

@end
