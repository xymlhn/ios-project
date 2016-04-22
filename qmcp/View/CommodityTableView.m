//
//  CommodityTableView.m
//  qmcp
//
//  Created by 谢永明 on 16/4/20.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "CommodityTableView.h"

@implementation CommodityTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView:self];
    }
    return self;
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
    
}

+ (instancetype)defaultPopupView{
    return [[CommodityTableView alloc]initWithFrame:CGRectMake(0, 0, 200, 210)];
}

@end
