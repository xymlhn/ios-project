//
//  AgressPriceChangeView.h
//  qmcp
//
//  Created by 谢永明 on 2016/11/22.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface SalesOrderAgreePriceView : BaseView

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) UITextField *priceText;

@property (nonatomic,strong) UITextView *remarkText;

@property (nonatomic, strong) UIButton *saveBtn;


+ (instancetype)viewInstance;
@end
