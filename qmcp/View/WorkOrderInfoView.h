//
//  WorkOrderInfoView.h
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"

@interface WorkOrderInfoView : BaseView

@property (nonatomic,strong) UIView   *containView;

@property (nonatomic,strong) UIView   *codeView;

@property (nonatomic,strong) UILabel  *codeContent;

@property (nonatomic,strong) UIView   *userView;
@property (nonatomic,strong) UILabel  *userNameText;
@property (nonatomic,strong) UILabel  *passwordText;

@property (nonatomic,strong) UIView   *locationView;
@property (nonatomic,strong) UILabel  *locationText;

@property (nonatomic,strong) UIView   *typeView;
@property (nonatomic,strong) UILabel  *typeText;
@property (nonatomic,strong) UILabel  *statusText;

@property (nonatomic,strong) UIView   *appointmentTimeView;
@property (nonatomic,strong) UILabel  *appointmentTimeText;

@property (nonatomic,strong) UIView   *serviceView;
@property (nonatomic,strong) UILabel  *serviceText;

@property (nonatomic,strong) UIView   *remarkView;
@property (nonatomic,strong) UILabel  *remarkText;

@property (nonatomic,strong) UIButton *starBtn;

@end
