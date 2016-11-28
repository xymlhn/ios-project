//
//  BusinessSalesOrderView.h
//  qmcp
//
//  Created by 谢永明 on 2016/9/22.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface BusinessSalesOrderView : BaseView

@property (nonatomic, strong) UILabel *phoneTitle;
@property (nonatomic, strong) UITextField *phoneValue;

@property (nonatomic, strong) UILabel *nameTitle;
@property (nonatomic, strong) UITextField *nameValue;

@property (nonatomic, strong) UILabel *addressTitle;
@property (nonatomic, strong) UITextField *addressValue;

@property (nonatomic, strong) UILabel *remarkTitle;
@property (nonatomic, strong) UITextView *remarkValue;

@property (nonatomic, strong) UIButton *orderButton;
@property (nonatomic, strong) UIButton *delBtn;


+ (instancetype)viewInstance;
@end
