//
//  SignView.h
//  qmcp
//
//  Created by 谢永明 on 16/7/4.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"
#import "PJRSignatureView.h"

@interface SignView : BaseView
@property (nonatomic,strong) PJRSignatureView *signatureView;

@property (nonatomic,strong) UILabel *saveBtn;
@property (nonatomic,strong) UILabel *clearBtn;
@property (nonatomic,strong) UILabel *cancelBtn;

+ (instancetype)viewInstance;
@end
