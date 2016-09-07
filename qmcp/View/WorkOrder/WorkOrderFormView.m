//
//  WorkOrderFormView.m
//  qmcp
//
//  Created by 谢永明 on 16/7/23.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderFormView.h"

@implementation WorkOrderFormView

+ (instancetype)viewInstance{
    WorkOrderFormView *workOrderFormView = [WorkOrderFormView new];
    return workOrderFormView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    _tableView = [UITableView new];
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor themeColor];
    _tableView.separatorStyle = NO;
    [self addSubview:_tableView];
    
    
    _saveBtn = [UIButton new];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    _saveBtn.backgroundColor = [UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:1.000];
    [self addSubview:_saveBtn];
    
    _completeBtn = [UIButton new];
    [_completeBtn setTitle:@"完结" forState:UIControlStateNormal];
    _completeBtn.backgroundColor = [UIColor grayColor];
    [self addSubview:_completeBtn];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(_saveBtn.mas_top);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_centerX);
        make.height.equalTo(@50);
    }];
    
    [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_centerX);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@50);
    }];

    return self;
}

@end
