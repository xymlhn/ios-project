//
//  InventoryChooseView.m
//  qmcp
//
//  Created by 谢永明 on 16/8/29.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "InventoryChooseView.h"

@implementation InventoryChooseView

+ (instancetype)viewInstance{
    InventoryChooseView *searchView = [InventoryChooseView new];
    return searchView;
}
- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = [UIColor whiteColor];
    [self setupView];
    return self;
}

-(void)setupView{
    _tableView = [UITableView new];
    _tableView.rowHeight = 45;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    _carBtn = [UIButton new];
    _carBtn.layer.masksToBounds = YES;
    _carBtn.backgroundColor = [UIColor nameColor];
    _carBtn.layer.cornerRadius = 3.0;
    [_carBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _carBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_carBtn setTitle:@"购物车" forState:UIControlStateNormal];
    [self addSubview:_carBtn];
    
    [_carBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.mas_bottom).with.offset(-kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@30);
    }];
}



@end
