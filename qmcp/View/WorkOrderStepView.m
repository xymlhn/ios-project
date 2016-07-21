//
//  WorkOrderStepView.m
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderStepView.h"

@implementation WorkOrderStepView

+ (instancetype)workOrderStepViewInstance:(UIView *)view{
    WorkOrderStepView *workOrderStepView = [WorkOrderStepView new];
    [workOrderStepView initView:view];
    return workOrderStepView;
}

-(void)initView:(UIView *)rootView
{
    _tableView = [UITableView new];
    _tableView.rowHeight = 100;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor themeColor];
    rootView.backgroundColor = [UIColor whiteColor];
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
    bottomView.backgroundColor = [UIColor whiteColor];
    [rootView addSubview:bottomView];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:codeBottomLine];
    
    
    _addBtn = [UILabel new];
    [_addBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _addBtn.text = @"";
    _addBtn.textColor = [UIColor nameColor];
    _addBtn.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_addBtn];
   
    UILabel *addLabel = [UILabel new];
    addLabel.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    addLabel.text = @"步骤";
    addLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:addLabel];
    
    _saveBtn = [UILabel new];
    [_saveBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _saveBtn.text = @"";
    _saveBtn.textAlignment = NSTextAlignmentCenter;
    _saveBtn.textColor = [UIColor nameColor];
    [bottomView addSubview:_saveBtn];
    
    UILabel *saveLabel = [UILabel new];
    saveLabel.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    saveLabel.text = @"保存";
    saveLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:saveLabel];
    
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
   
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_saveBtn);
        make.left.equalTo(bottomView.mas_left);
        make.right.equalTo(_saveBtn.mas_left);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addBtn.mas_bottom);
        make.centerX.equalTo(_addBtn.mas_centerX);
    }];
    
   
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_addBtn);
        make.left.equalTo(_addBtn.mas_right);
        make.right.equalTo(bottomView.mas_right);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    
    [saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_saveBtn.mas_bottom);
        make.centerX.equalTo(_saveBtn.mas_centerX);
    }];

    
}

@end
