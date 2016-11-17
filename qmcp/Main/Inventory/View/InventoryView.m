//
//  WorkOrderInventoryView.m
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "InventoryView.h"

@implementation InventoryView

+ (instancetype)viewInstance{
    InventoryView *workOrderInventoryView = [InventoryView new];
    return workOrderInventoryView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = [UIColor whiteColor];
    _tableView = [UITableView new];
    _tableView.rowHeight = 50;
    _tableView.separatorColor = [UIColor lineColor];
    _tableView.backgroundColor = [UIColor themeColor];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-40);
    }];
    [self initBottomView];
    return self;
}

-(void)initBottomView
{
    UIView *bottomView = [UIView new];
    
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
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
