//
//  BusinessSalesOrderView.m
//  qmcp
//
//  Created by 谢永明 on 2016/9/22.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BusinessSalesOrderView.h"

@implementation BusinessSalesOrderView


+ (instancetype)viewInstance{
    BusinessSalesOrderView *searchView = [BusinessSalesOrderView new];
    return searchView;
}
- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = [UIColor whiteColor];
    
    _phoneTitle = [UILabel new];
    _phoneTitle.font = [UIFont systemFontOfSize:12];
    _phoneTitle.text = @"客户电话";
    _phoneTitle.textColor = [UIColor blackColor];
    [self addSubview:_phoneTitle];
    
    
    UIView *phone = [UIView new];
    phone.backgroundColor = [UIColor whiteColor];
    phone.layer.borderColor = [UIColor grayColor].CGColor;
    phone.layer.borderWidth = 1.0;
    phone.layer.cornerRadius = 5.0;
    phone.layer.masksToBounds = YES;
    [self addSubview:phone];
    
    _phoneValue = [UITextField new];
    _phoneValue.font = [UIFont systemFontOfSize:13];
    _phoneValue.placeholder = @"必填";
    _phoneValue.textColor = [UIColor blackColor];
    [phone addSubview:_phoneValue];
    
    _nameTitle = [UILabel new];
    _nameTitle.font = [UIFont systemFontOfSize:12];
    _nameTitle.text = @"客户名";
    _nameTitle.textColor = [UIColor blackColor];
    [self addSubview:_nameTitle];
    
    UIView *name = [UIView new];
    name.backgroundColor = [UIColor whiteColor];
    name.layer.borderColor = [UIColor grayColor].CGColor;
    name.layer.borderWidth = 1.0;
    name.layer.cornerRadius = 5.0;
    name.layer.masksToBounds = YES;
    [self addSubview:name];
    
    _nameValue = [UITextField new];
    _nameValue.font = [UIFont systemFontOfSize:13];
    _nameValue.placeholder = @"必填";
    _nameValue.textColor = [UIColor blackColor];
    [name addSubview:_nameValue];
    
    _addressTitle = [UILabel new];
    _addressTitle.font = [UIFont systemFontOfSize:12];
    _addressTitle.text = @"客户地址";
    _addressTitle.textColor = [UIColor blackColor];
    [self addSubview:_addressTitle];
    
    UIView *address = [UIView new];
    address.backgroundColor = [UIColor whiteColor];
    address.layer.borderColor = [UIColor grayColor].CGColor;
    address.layer.borderWidth = 1.0;
    address.layer.cornerRadius = 5.0;
    address.layer.masksToBounds = YES;
    [self addSubview:address];
    
    _addressValue = [UITextField new];
    _addressValue.font = [UIFont systemFontOfSize:13];
    _addressValue.placeholder = @"必填";
    _addressValue.textColor = [UIColor blackColor];
    [address addSubview:_addressValue];
    
    _remarkTitle = [UILabel new];
    _remarkTitle.font = [UIFont systemFontOfSize:12];
    _remarkTitle.text = @"备注";
    _remarkTitle.textColor = [UIColor blackColor];
    [self addSubview:_remarkTitle];

    
    _remarkValue = [UITextView new];
    _remarkValue.font = [UIFont systemFontOfSize:13];
    _remarkValue.textColor = [UIColor blackColor];
    _remarkValue.layer.borderColor = [UIColor grayColor].CGColor;
    _remarkValue.layer.borderWidth =1.0;
    _remarkValue.layer.cornerRadius =5.0;
    [self addSubview:_remarkValue];
    
    _orderButton = [UIButton new];
    [_orderButton setTitle:@"下单" forState:UIControlStateNormal];
    _orderButton.backgroundColor = [UIColor grayColor];
    [_orderButton.layer setMasksToBounds:YES];
    _orderButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _orderButton.layer.borderWidth =1.0;
    _orderButton.layer.cornerRadius =5.0;
    [self addSubview:_orderButton];
    
    [_phoneTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneTitle.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@30);
    }];
    
    [_phoneValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(phone.mas_left).with.offset(5);
        make.right.equalTo(phone.mas_right).with.offset(0);
        make.centerY.equalTo(phone.mas_centerY);
    }];
    
    [_nameTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(phone.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameTitle.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@30);
        
    }];
    
    [_nameValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(name.mas_left).with.offset(5);
        make.right.equalTo(name.mas_right).with.offset(0);
        make.centerY.equalTo(name.mas_centerY);
    }];
    
    
    [_addressTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(name.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressTitle.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@30);
    }];
    
    
    [_addressValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(address.mas_left).with.offset(5);
        make.right.equalTo(address.mas_right).with.offset(0);
        make.centerY.equalTo(address.mas_centerY);
    }];
    
    [_remarkTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(address.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    [_remarkValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_remarkTitle.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@60);
    }];

    [_orderButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_remarkValue.mas_bottom).with.offset(20);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.mas_equalTo(@50);
    }];
    return self;
}


@end
