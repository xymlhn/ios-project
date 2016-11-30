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
    _phoneTitle.font = [UIFont systemFontOfSize:kShisanpt];
    _phoneTitle.text = @"客户电话";
    _phoneTitle.textColor = [UIColor mainTextColor];
    [self addSubview:_phoneTitle];
    
    
    UIView *phone = [UIView new];
    phone.backgroundColor = [UIColor whiteColor];
    phone.layer.borderColor = [UIColor cornerLineColor].CGColor;
    phone.layer.borderWidth = kLineHeight;
    phone.layer.cornerRadius = kEditViewCorner;
    phone.layer.masksToBounds = YES;
    [self addSubview:phone];
    
    _phoneValue = [UITextField new];
    _phoneValue.keyboardType = UIKeyboardTypePhonePad;
    _phoneValue.font = [UIFont systemFontOfSize:kShisanpt];
    _phoneValue.placeholder = @"必填";
    [_phoneValue setValue:[UIColor arrowColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneValue setValue:[UIFont systemFontOfSize:kShisipt] forKeyPath:@"_placeholderLabel.font"];
    _phoneValue.returnKeyType = UIReturnKeyNext;
    _phoneValue.textColor = [UIColor mainTextColor];
    [phone addSubview:_phoneValue];
    
    _nameTitle = [UILabel new];
    _nameTitle.font = [UIFont systemFontOfSize:kShisanpt];
    _nameTitle.text = @"客户名";
    _nameTitle.textColor = [UIColor mainTextColor];
    [self addSubview:_nameTitle];
    
    UIView *name = [UIView new];
    name.backgroundColor = [UIColor whiteColor];
    name.layer.borderColor = [UIColor cornerLineColor].CGColor;
    name.layer.borderWidth = kLineHeight;
    name.layer.cornerRadius = kEditViewCorner;
    name.layer.masksToBounds = YES;
    [self addSubview:name];
    
    _nameValue = [UITextField new];
    _nameValue.font = [UIFont systemFontOfSize:kShisanpt];
    _nameValue.placeholder = @"必填";
    [_nameValue setValue:[UIColor arrowColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_nameValue setValue:[UIFont systemFontOfSize:kShisipt] forKeyPath:@"_placeholderLabel.font"];
    _nameValue.returnKeyType = UIReturnKeyNext;
    _nameValue.textColor = [UIColor mainTextColor];
    [name addSubview:_nameValue];
    
    _addressTitle = [UILabel new];
    _addressTitle.font = [UIFont systemFontOfSize:kShisanpt];
    _addressTitle.text = @"客户地址";
    _addressTitle.textColor = [UIColor mainTextColor];
    [self addSubview:_addressTitle];
    
    UIView *address = [UIView new];
    address.backgroundColor = [UIColor whiteColor];
    address.layer.borderColor = [UIColor cornerLineColor].CGColor;
    address.layer.borderWidth = kLineHeight;
    address.layer.cornerRadius = kEditViewCorner;
    address.layer.masksToBounds = YES;
    [self addSubview:address];
    
    _addressValue = [UITextField new];
    _addressValue.font = [UIFont systemFontOfSize:kShisanpt];
    _addressValue.placeholder = @"必填";
    [_addressValue setValue:[UIColor arrowColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_addressValue setValue:[UIFont systemFontOfSize:kShisipt] forKeyPath:@"_placeholderLabel.font"];
    _addressValue.returnKeyType = UIReturnKeyNext;
    _addressValue.textColor = [UIColor mainTextColor];
    [address addSubview:_addressValue];
    
    _remarkTitle = [UILabel new];
    _remarkTitle.font = [UIFont systemFontOfSize:kShisanpt];
    _remarkTitle.text = @"备注";
    _remarkTitle.textColor = [UIColor mainTextColor];
    [self addSubview:_remarkTitle];
    
    _remarkValue = [UITextView new];
    _remarkValue.returnKeyType = UIReturnKeyDone;
    _remarkValue.font = [UIFont systemFontOfSize:kShisanpt];
    _remarkValue.textColor = [UIColor mainTextColor];
    _remarkValue.layer.borderColor = [UIColor cornerLineColor].CGColor;
    _remarkValue.layer.borderWidth = kLineHeight;
    _remarkValue.layer.cornerRadius =kEditViewCorner;
    [self addSubview:_remarkValue];
    
    [_phoneTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneTitle.mas_bottom).with.offset(4);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.mas_equalTo(kEditViewHeight);
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
        make.top.equalTo(_nameTitle.mas_bottom).with.offset(4);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.mas_equalTo(kEditViewHeight);
        
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
        make.top.equalTo(_addressTitle.mas_bottom).with.offset(4);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.mas_equalTo(kEditViewHeight);
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
        make.height.equalTo(@126);
    }];
    
    [self setupBottomView];
    return self;
}

//底部按钮
-(void)setupBottomView{
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor lineColor];
    [bottomView addSubview:codeBottomLine];
    
    _delBtn = [UIButton new];
    [_delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _delBtn.titleLabel.font = [UIFont systemFontOfSize:kShiwupt];
    [_delBtn setTitle:@"取消" forState:UIControlStateNormal];
    _delBtn.backgroundColor = [UIColor appBlueColor];
    [_delBtn.layer setMasksToBounds:YES];
    _delBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _delBtn.layer.borderWidth = kLineHeight;
    _delBtn.layer.cornerRadius = kBottomButtonCorner;
    [bottomView addSubview:_delBtn];
    
    _orderButton = [UIButton new];
    [_orderButton setTitle:@"下单" forState:UIControlStateNormal];
    _orderButton.titleLabel.font = [UIFont systemFontOfSize:kShiwupt];
    _orderButton.backgroundColor = [UIColor buttonDisableColor];
    [_orderButton.layer setMasksToBounds:YES];
    _orderButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _orderButton.layer.borderWidth = kLineHeight;
    _orderButton.layer.cornerRadius = kBottomButtonCorner;
    [self addSubview:_orderButton];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(kBottomHeight);
    }];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(bottomView.mas_top).with.offset(0);
        make.left.equalTo(bottomView.mas_left).with.offset(0);
        make.right.equalTo(bottomView.mas_right).with.offset(0);
        make.height.mas_equalTo(kLineHeight);
    }];
    [_orderButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(bottomView.mas_left).offset(kPaddingLeftWidth*2);
        make.right.equalTo(bottomView.mas_centerX).offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(kBottomButtonHeight);
    }];
    [_delBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(bottomView.mas_centerX).offset(kPaddingLeftWidth);
        make.right.equalTo(bottomView.mas_right).offset(-kPaddingLeftWidth*2);
        make.height.mas_equalTo(kBottomButtonHeight);
    }];
}

@end
