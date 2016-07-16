//
//  CheckBoxView.m
//  qmcp
//
//  Created by 谢永明 on 16/7/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "CheckBoxView.h"

@implementation CheckBoxView

-(void)initView:(UIView *)rootView
{
    rootView.backgroundColor = [UIColor clearColor];
    _baseView = [UIView new];
     [rootView addSubview:_baseView];
    
    UIView *alphaView = [UIView new];
    alphaView.backgroundColor = [UIColor whiteColor];
    _baseView.backgroundColor = [UIColor blackColor];
    _baseView.alpha = 0.2;
    [rootView addSubview:alphaView];
    
    _cancelBtn = [UIButton new];
    [_cancelBtn setTitleColor:[UIColor nameColor] forState:UIControlStateNormal];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [alphaView addSubview:_cancelBtn];
    
    _confirmBtn = [UIButton new];
    [_confirmBtn setTitleColor:[UIColor nameColor] forState:UIControlStateNormal];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [alphaView addSubview:_confirmBtn];
    
    
    _tableView = [UITableView new];
    _tableView.rowHeight = 50;
    _tableView.backgroundColor = [UIColor themeColor];
    [alphaView addSubview:_tableView];
    
    [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView);
    }];
    
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rootView.mas_left);
        make.right.equalTo(rootView.mas_right);
        make.bottom.equalTo(rootView.mas_bottom);
        make.top.equalTo(rootView.mas_centerY);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alphaView.mas_top).with.offset(10);
        make.left.equalTo(alphaView.mas_left).with.offset(10);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alphaView.mas_top).with.offset(10);
        make.right.equalTo(alphaView.mas_right).with.offset(-10);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_cancelBtn.mas_bottom);
        make.bottom.equalTo(alphaView.mas_bottom);
        make.left.equalTo(alphaView.mas_left);
        make.right.equalTo(alphaView.mas_right);
    }];
    
}
@end
