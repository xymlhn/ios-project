//
//  SalesOrderBindCell.m
//  qmcp
//
//  Created by 谢永明 on 16/4/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderBindCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "MJExtension.h"
#import "EnumUtil.h"
@implementation SalesOrderBindCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"gb";
    SalesOrderBindCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[SalesOrderBindCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
        _commodityNameText.text = [salesOrderSnapshot.commodityNames componentsJoinedByString:@","];;
        _codeText.text = salesOrderSnapshot.code;
        _nameText.text = salesOrderSnapshot.addressSnapshot.contacts;
        _phoneText.text = salesOrderSnapshot.addressSnapshot.mobilePhone;
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
    
}

@end
