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
    _tableView.rowHeight = 30;
    _tableView.backgroundColor = [UIColor themeColor];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-40);
    }];
    [self initBottomView];

}

-(void)initBottomView{
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor grayColor];
    [self addSubview:_bottomView];
    
    _numberLabel = [UILabel new];
    _numberLabel.font = [UIFont systemFontOfSize:12];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.text = @"0";
    _numberLabel.backgroundColor = [UIColor redColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_numberLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:12];
    _priceLabel.textColor = [UIColor whiteColor];
    [_bottomView addSubview:_priceLabel];
    
    UILabel *angleIcon = [UILabel new];
    [angleIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    angleIcon.text = @"";
    angleIcon.textColor = [UIColor blackColor];
    [_bottomView addSubview:angleIcon];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    [angleIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.left.equalTo(_bottomView.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(angleIcon.mas_right).with.offset(0);
        make.top.equalTo(_bottomView.mas_top).with.offset(5);
        make.height.equalTo(@15);
        make.width.equalTo(@15);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.left.equalTo(_numberLabel.mas_right).with.offset(kPaddingLeftWidth);
    }];

}

@end
