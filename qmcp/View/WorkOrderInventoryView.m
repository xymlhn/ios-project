//
//  WorkOrderInventoryView.m
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderInventoryView.h"

@implementation WorkOrderInventoryView

+ (instancetype)workOrderInventoryViewInstance:(UIView *)view{
    WorkOrderInventoryView *workOrderInventoryView = [WorkOrderInventoryView new];
    [workOrderInventoryView initView:view];
    return workOrderInventoryView;
}

-(void)initView:(UIView *)rootView
{
    rootView.backgroundColor = [UIColor whiteColor];
    _tableView = [UITableView new];
    _tableView.rowHeight = 50;
    _tableView.backgroundColor = [UIColor themeColor];
    [rootView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(rootView.mas_top).with.offset(0);
        make.left.equalTo(rootView.mas_left).with.offset(0);
        make.right.equalTo(rootView.mas_right).with.offset(0);
        make.bottom.equalTo(rootView.mas_bottom).with.offset(-40);
    }];
    [self initBottomView:rootView];
    
}
-(void)initBottomView:(UIView *)rootView
{
    UIView *bottomView = [UIView new];
    
    [rootView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(rootView.mas_bottom).with.offset(0);
        make.left.equalTo(rootView.mas_left).with.offset(0);
        make.right.equalTo(rootView.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:codeBottomLine];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(bottomView.mas_top).with.offset(0);
        make.left.equalTo(bottomView.mas_left).with.offset(0);
        make.right.equalTo(bottomView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    
    _addBtn = [UILabel new];
    [_addBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _addBtn.text = @"";
    _addBtn.textColor = [UIColor nameColor];
    _addBtn.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_addBtn];
    
    _signBtn = [UILabel new];
    [_signBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _signBtn.text = @"";
    _signBtn.textAlignment = NSTextAlignmentCenter;
    _signBtn.textColor = [UIColor nameColor];
    [bottomView addSubview:_signBtn];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(bottomView.mas_left);
        make.centerY.equalTo(bottomView.mas_centerY);
        
    }];
    
    [_signBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(bottomView.mas_right);
        make.left.equalTo(_addBtn.mas_right);
        make.width.equalTo(_addBtn.mas_width);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    
}

@end
