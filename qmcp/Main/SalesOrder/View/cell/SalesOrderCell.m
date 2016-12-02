//
//  SalesOrderGrabCell.m
//  qmcp
//
//  Created by 谢永明 on 16/4/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderCell.h"
#import "SalesOrderCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "MJExtension.h"
#import "EnumUtil.h"
@implementation SalesOrderCell
//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuseId = @"SalesOrderCell";
    SalesOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[SalesOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.selectedBackgroundView.backgroundColor = [UIColor themeColor];
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    
    return self;
}

//重写属性的setter方法，给子控件赋值
- (void)setSalesOrder:(SalesOrder *)salesOrder{
    if(salesOrder != nil){
        
        switch (salesOrder.type) {
            case SalesOrderTypeShop:
                _typeImage.image = [UIImage imageNamed:@"type_daodian"];
                break;
            case SalesOrderTypeOnsite:
                _typeImage.image = [UIImage imageNamed:@"type_shangmen"];
                break;
            case SalesOrderTypeRemote:
                _typeImage.image = [UIImage imageNamed:@"type_yuancheng"];
                break;
            default:
                break;
        }
        _commodityNameText.text = [salesOrder.commodityNames componentsJoinedByString:@","];;
        _codeText.text = salesOrder.code;
        _appointmentTimeText.text = salesOrder.appointmentTime;
        [_grabBtn setTitle:@"接单" forState:UIControlStateNormal];
        _inventoryImage.image = [UIImage imageNamed:salesOrder.signedFlag ?@"list_inentory_success":@"list_inentory_failed"];
        _progressImage.image = [UIImage imageNamed:salesOrder.processingFlag ?@"list_progress_success":@"list_progress_failed"];
        _payImage.image = [UIImage imageNamed:salesOrder.paidFlag ?@"list_pay_success":@"list_pay_failed"];
        [_unreadImage setHidden:salesOrder.isRead];
    }
}

-(void)initView{
    _typeImage = [UIImageView new];
    [self.contentView addSubview:_typeImage];
    
    _unreadImage = [UIImageView new];
    _unreadImage.image = [UIImage imageNamed:@"salesorder_new"];
    [self.contentView addSubview:_unreadImage];
    
    UILabel *codeTitle = [UILabel new];
    codeTitle.font = [UIFont systemFontOfSize:kShisanpt];
    codeTitle.text = @"订单编号 ";
    codeTitle.textColor = [UIColor arrowColor];
    [self.contentView addSubview:codeTitle];
    
    _codeText = [UILabel new];
    _codeText.font = [UIFont systemFontOfSize:kShisanpt];
    _codeText.textColor = [UIColor secondTextColor];
    [self.contentView addSubview:_codeText];
    
    UILabel *appointmentTimeTitle = [UILabel new];
    appointmentTimeTitle.font = [UIFont systemFontOfSize:kShisanpt];
    appointmentTimeTitle.text = @"预约时间 ";
    appointmentTimeTitle.textColor = [UIColor arrowColor];
    [self.contentView addSubview:appointmentTimeTitle];
    
    _appointmentTimeText = [UILabel new];
    _appointmentTimeText.font = [UIFont systemFontOfSize:kShisanpt];
    _appointmentTimeText.textColor = [UIColor secondTextColor];
    [self.contentView addSubview:_appointmentTimeText];
    
    _commodityNameText = [UILabel new];
    _commodityNameText.font = [UIFont systemFontOfSize:kShisipt];
    _commodityNameText.textColor = [UIColor secondTextColor];
    _commodityNameText.numberOfLines = 2;
    [self.contentView addSubview:_commodityNameText];
    
    _inventoryImage = [UIImageView new];
    [self.contentView addSubview:_inventoryImage];
    
    _progressImage = [UIImageView new];
    [self.contentView addSubview:_progressImage];
    
    _payImage = [UIImageView new];
    [self.contentView addSubview:_payImage];
    
    _grabBtn = [UIButton new];
    [_grabBtn setTitleColor:[UIColor nameColor] forState:UIControlStateNormal];
    [_grabBtn.layer setMasksToBounds:YES];
    [_grabBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [_grabBtn.layer setBorderWidth:1.0];
    _grabBtn.layer.borderColor=[UIColor grayColor].CGColor;
    [_grabBtn setTitle:@"抢单" forState:UIControlStateNormal];
    [_grabBtn setHidden:YES];
    [self.contentView addSubview:_grabBtn];
    
    [_unreadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@9);
        make.height.equalTo(@10);
        make.left.equalTo(self.contentView.mas_left).with.offset(13);
        make.top.equalTo(self.contentView.mas_top).with.offset(17);
    }];
    
    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeftWidth);
        make.top.equalTo(self.contentView.mas_top).with.offset(kPaddingTopWidth);
    }];
    
    [codeTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_typeImage.mas_top).with.offset(0);
        make.left.equalTo(_typeImage.mas_right).with.offset(kPaddingLeftWidth);

    }];
    
    [_codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeTitle.mas_right).with.offset(0);
        make.top.equalTo(codeTitle.mas_top);
    }];
    
    [appointmentTimeTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_codeText.mas_bottom).with.offset(2);
        make.left.equalTo(codeTitle.mas_left).with.offset(0);
    }];
    
    
    [_appointmentTimeText mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(appointmentTimeTitle.mas_right).with.offset(0);
        make.top.equalTo(appointmentTimeTitle.mas_top);
    }];
    
    [_commodityNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(appointmentTimeTitle.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeftWidth);
        make.top.equalTo(_appointmentTimeText.mas_bottom).with.offset(kPaddingLeftWidth);
        
    }];
    
    [_inventoryImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-15);
        make.left.equalTo(codeTitle.mas_left).with.offset(0);
        make.width.mas_equalTo(@14);
        make.height.mas_equalTo(@14);
    }];
    [_progressImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-15);
        make.left.equalTo(_inventoryImage.mas_right).with.offset(2);
        make.width.mas_equalTo(@14);
        make.height.mas_equalTo(@14);
    }];
    [_payImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-15);
        make.left.equalTo(_progressImage.mas_right).with.offset(2);
        make.width.mas_equalTo(@14);
        make.height.mas_equalTo(@14);
    }];
    
    [_grabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];
    
}
@end
