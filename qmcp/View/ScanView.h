//
//  ScanView.h
//  qmcp
//
//  Created by 谢永明 on 16/7/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface ScanView : BaseView
@property (nonatomic, strong) UITextField *scanText;
@property (nonatomic, strong) UIButton *scanBtn;

+ (instancetype)viewInstance;
@end
