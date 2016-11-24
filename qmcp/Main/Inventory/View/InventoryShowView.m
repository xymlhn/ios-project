//
//  InventoryShowView.m
//  qmcp
//
//  Created by 谢永明 on 2016/11/24.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "InventoryShowView.h"

@implementation InventoryShowView

+ (instancetype)viewInstance{
    InventoryShowView *searchView = [InventoryShowView new];
    return searchView;
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
    topView.backgroundColor = [UIColor grayColor];
    [alphaView addSubview:topView];
    
    _cancelBtn = [UIButton new];
    [_cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [topView addSubview:_cancelBtn];
    
    _tableView = [UITableView new];
    _tableView.rowHeight = 30;
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
        make.left.equalTo(alphaView.mas_left).with.offset(0);
        make.right.equalTo(alphaView.mas_right).with.offset(0);
        make.top.equalTo(alphaView.mas_top);
        make.height.equalTo(@30);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.right.equalTo(topView.mas_right).with.offset(-kPaddingLeftWidth);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(topView.mas_bottom).with.offset(0);
        make.left.equalTo(alphaView.mas_left).with.offset(0);
        make.right.equalTo(alphaView.mas_right).with.offset(0);
        make.bottom.equalTo(alphaView.mas_bottom).with.offset(0);
    }];
    return self;
}

@end
