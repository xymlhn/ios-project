//
//  WorkOrderFormView.m
//  qmcp
//
//  Created by 谢永明 on 16/7/23.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderFormView.h"

@implementation WorkOrderFormView

+ (instancetype)viewInstance:(UIView *)view{
    WorkOrderFormView *workOrderFormView = [WorkOrderFormView new];
    [workOrderFormView setupView:view];
    return workOrderFormView;
}

-(void)setupView:(UIView *)rootView{
    _tableView = [UITableView new];
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor themeColor];
    _tableView.separatorStyle = NO;
    [rootView addSubview:_tableView];
  
    
    _saveBtn = [UIButton new];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    _saveBtn.backgroundColor = [UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:1.000];
    [rootView addSubview:_saveBtn];
    
    _completeBtn = [UIButton new];
    [_completeBtn setTitle:@"完结" forState:UIControlStateNormal];
    _completeBtn.backgroundColor = [UIColor grayColor];
    [rootView addSubview:_completeBtn];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(rootView.mas_left);
        make.right.equalTo(rootView.mas_right);
        make.top.equalTo(rootView.mas_top);
        make.bottom.equalTo(_saveBtn.mas_top);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rootView.mas_bottom);
        make.left.equalTo(rootView.mas_left);
        make.right.equalTo(rootView.mas_centerX);
        make.height.equalTo(@50);
    }];
    
    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rootView.mas_bottom);
        make.left.equalTo(rootView.mas_centerX);
        make.right.equalTo(rootView.mas_right);
        make.height.equalTo(@50);
    }];
}
@end
