//
//  WorkOrderStepView.m
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderStepView.h"

@implementation WorkOrderStepView

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
    
    _cameraBtn = [UILabel new];
    [_cameraBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _cameraBtn.text = @"";
    _cameraBtn.textColor = [UIColor nameColor];
    _cameraBtn.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_cameraBtn];
   
    
    _addBtn = [UILabel new];
    [_addBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _addBtn.text = @"";
    _addBtn.textColor = [UIColor nameColor];
    _addBtn.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_addBtn];
   
    _infoBtn = [UILabel new];
    [_infoBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _infoBtn.text = @"";
    _infoBtn.textColor = [UIColor nameColor];
    _infoBtn.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_infoBtn];
    
    _saveBtn = [UILabel new];
    [_saveBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _saveBtn.text = @"";
    _saveBtn.textAlignment = NSTextAlignmentCenter;
    _saveBtn.textColor = [UIColor nameColor];
    [bottomView addSubview:_saveBtn];
    
    [_infoBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(bottomView).with.offset(0);
        make.centerY.equalTo(bottomView);
    }];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_infoBtn);
        make.left.equalTo(_infoBtn.mas_right);
        make.centerY.equalTo(bottomView);
    }];
    
    [_cameraBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_addBtn);
        make.left.equalTo(_addBtn.mas_right);
        make.centerY.equalTo(bottomView);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_cameraBtn);
        make.left.equalTo(_cameraBtn.mas_right);
        make.right.equalTo(bottomView);
        make.centerY.equalTo(bottomView);
    }];
}

@end
