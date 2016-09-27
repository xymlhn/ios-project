//
//  SalesOrderInfoView.h
//  qmcp
//
//  Created by 谢永明 on 2016/9/23.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"
#import "SalesOrder.h"
@interface SalesOrderInfoView : BaseView

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

@property (nonatomic,strong ) UILabel     *stepBtn;
@property (nonatomic,strong ) UILabel     *saveBtn;
@property (nonatomic,strong ) UILabel     *formBtn;
@property (nonatomic,strong ) UILabel     *cameraBtn;
@property (nonatomic,strong ) UILabel     *qrCodeBtn;

@property (nonatomic,strong) UIView *view;
@property (nonatomic, strong) SalesOrder *salesOrder;


+ (instancetype)viewInstance;

@end
