//
//  ChooseView.m
//  qmcp
//
//  Created by 谢永明 on 16/7/3.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "ChooseView.h"

@implementation ChooseView

+ (instancetype)viewInstance{
    ChooseView *chooseView = [ChooseView new];
    return chooseView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = [UIColor clearColor];
    
    UIView *alphaView = [UIView new];
    _baseView = [UIView new];
    alphaView.backgroundColor = [UIColor whiteColor];
    _baseView.backgroundColor = [UIColor blackColor];
    _baseView.alpha = 0.2;
    [self addSubview:_baseView];
    [self addSubview:alphaView];
    
    [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.mas_centerY);
    }];
    
    _tableView = [UITableView new];
    _tableView.rowHeight = 80;
    _tableView.backgroundColor = [UIColor themeColor];
    [alphaView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(alphaView);
    }];
    
    return self;
}


@end
