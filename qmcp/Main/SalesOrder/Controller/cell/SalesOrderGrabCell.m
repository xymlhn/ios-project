//
//  SalesOrderGrabCell.m
//  qmcp
//
//  Created by 谢永明 on 16/4/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderGrabCell.h"
#import "SalesOrderMineCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "MJExtension.h"
#import "EnumUtil.h"
@implementation SalesOrderGrabCell
//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"gb";
    SalesOrderGrabCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[SalesOrderGrabCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.selectedBackgroundView.backgroundColor = [UIColor themeColor];
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    
    return self;
}

//重写属性的setter方法，给子控件赋值
- (void)setSalesOrderSnapshot:(SalesOrderSnapshot *)salesOrderSnapshot
{
    if(salesOrderSnapshot != nil){
        _typeText.text = [EnumUtil salesOrderTypeString:salesOrderSnapshot.type];
        if(salesOrderSnapshot.type == SalesOrderTypeOnsite){
            _typeText.backgroundColor = [UIColor nameColor];
        }else if(salesOrderSnapshot.type == SalesOrderTypeShop){
            _typeText.backgroundColor = [UIColor orangeColor];
        }else{
            _typeText.backgroundColor = [UIColor greenColor];
        }
        _commodityNameText.text = [salesOrderSnapshot.commodityNames componentsJoinedByString:@","];;
        _codeText.text = salesOrderSnapshot.code;
        _nameText.text = salesOrderSnapshot.addressSnapshot.contacts;
        _phoneText.text = salesOrderSnapshot.addressSnapshot.mobilePhone;
        NSString *title = @"接单";
        [_grabBtn setTitle:title forState:UIControlStateNormal];
    }
}

-(void)initView{
    static int border = 10;
    _typeText = [UILabel new];
    _typeText.textColor = [UIColor whiteColor];
    _typeText.textAlignment = NSTextAlignmentCenter;
    _typeText.backgroundColor = [UIColor nameColor];
    [self.contentView addSubview:_typeText];
    
    _commodityNameText = [UILabel new];
    _commodityNameText.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_commodityNameText];
    
    _codeText = [UILabel new];
    _codeText.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_codeText];
    
    _nameText = [UILabel new];
    _nameText.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_nameText];
    
    _phoneText = [UILabel new];
    _phoneText.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_phoneText];
    
    UILabel *userIcon = [UILabel new];
    [userIcon setFont:[UIFont fontWithName:@"FontAwesome" size:15]];
    userIcon.text = @"";
    userIcon.textColor = [UIColor nameColor];
    [self.contentView addSubview:userIcon];
    
    UILabel *phoneIcon = [UILabel new];
    [phoneIcon setFont:[UIFont fontWithName:@"FontAwesome" size:17]];
    phoneIcon.text = @"";
    phoneIcon.textColor = [UIColor nameColor];
    [self.contentView addSubview:phoneIcon];
    
    _grabBtn = [UIButton new];
    [_grabBtn setTitleColor:[UIColor nameColor] forState:UIControlStateNormal];
    [_grabBtn.layer setMasksToBounds:YES];
    [_grabBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [_grabBtn.layer setBorderWidth:1.0];
    _grabBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [_grabBtn setTitle:@"抢单" forState:UIControlStateNormal];
    [self.contentView addSubview:_grabBtn];
    
    [_typeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.height.equalTo(@60);
        make.left.equalTo(self.contentView.mas_left).with.offset(border);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [_codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeText.mas_right).with.offset(border);
        make.top.equalTo(_typeText.mas_top);
    }];
    
    [_commodityNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeText.mas_right).with.offset(border);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeText.mas_right).with.offset(border);
        make.bottom.equalTo(_typeText.mas_bottom);
    }];
    
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIcon.mas_right).with.offset(5);
        make.centerY.equalTo(userIcon.mas_centerY);
    }];
    
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameText.mas_right).with.offset(border);
        make.centerY.equalTo(userIcon.mas_centerY);
    }];
    
    [_phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneIcon.mas_right).with.offset(5);
        make.centerY.equalTo(phoneIcon.mas_centerY);
    }];
    
    [_grabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];
    
}

@end

