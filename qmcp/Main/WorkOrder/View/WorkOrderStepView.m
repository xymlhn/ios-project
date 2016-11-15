//
//  WorkOrderStepView.m
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderStepView.h"

@implementation WorkOrderStepView

+ (instancetype)viewInstance{
    WorkOrderStepView *workOrderStepView = [WorkOrderStepView new];
    
    return workOrderStepView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor themeColor];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self);
    }];
    
    _addBtn = [UILabel new];
    [_addBtn setFont:[UIFont fontWithName:@"FontAwesome" size:60]];
    _addBtn.text = @"";
    _addBtn.textColor = [UIColor nameColor];
    _addBtn.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_addBtn];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.mas_right).with.offset(-30);
        make.bottom.equalTo(self.mas_bottom).with.offset(-50);
    }];
    return self;
    
}

@end
