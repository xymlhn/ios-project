//
//  CheckBoxView.m
//  qmcp
//
//  Created by 谢永明 on 16/7/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "CheckBoxView.h"

@implementation CheckBoxView

+ (instancetype)viewInstance{
    CheckBoxView *checkBoxView = [CheckBoxView new];
    return checkBoxView;
}


- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    _baseView = [UIView new];
    [self addSubview:_baseView];
    
    UIView *alphaView = [UIView new];
    alphaView.backgroundColor = [UIColor whiteColor];
    _baseView.backgroundColor = [UIColor blackColor];
    _baseView.alpha = 0.2;
    [self addSubview:alphaView];
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [alphaView addSubview:topView];
    
    _cancelBtn = [UIButton new];
    [_cancelBtn setTitleColor:[UIColor nameColor] forState:UIControlStateNormal];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [topView addSubview:_cancelBtn];
    
    _confirmBtn = [UIButton new];
    [_confirmBtn setTitleColor:[UIColor nameColor] forState:UIControlStateNormal];
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [topView addSubview:_confirmBtn];
    
    
    _tableView = [UITableView new];
    _tableView.rowHeight = 50;
    _tableView.backgroundColor = [UIColor whiteColor];
    [alphaView addSubview:_tableView];
    
    [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_centerY);
    }];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alphaView.mas_left).with.offset(10);
        make.right.equalTo(alphaView.mas_right).with.offset(-10);
        make.top.equalTo(alphaView.mas_top);
        make.height.equalTo(@40);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(topView.mas_left);;
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.right.equalTo(topView.mas_right);;
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_cancelBtn.mas_bottom);
        make.bottom.equalTo(alphaView.mas_bottom);
        make.left.equalTo(alphaView.mas_left);
        make.right.equalTo(alphaView.mas_right);
    }];
    
    
    
    return self;
}


@end
