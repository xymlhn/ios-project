//
//  WorkOrderInfoView.h
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"
#import "WorkOrder.h"

@interface WorkOrderInfoView : BaseView

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UIView *orderView;

@property (nonatomic,strong) UIView   *nameView;
@property (nonatomic,strong) UILabel  *nameTitle;
@property (nonatomic,strong) UILabel  *nameValue;

@property (nonatomic,strong) UIView   *phoneView;
@property (nonatomic,strong) UILabel  *phoneTitle;
@property (nonatomic,strong) UILabel  *phoneValue;

@property (nonatomic,strong) UIView   *addressView;
@property (nonatomic,strong) UILabel  *addressTitle;
@property (nonatomic,strong) UILabel  *addressValue;

@property (nonatomic,strong) UIView   *appointmentTimeView;
@property (nonatomic,strong) UILabel  *appointmentTimeTitle;
@property (nonatomic,strong) UILabel  *appointmentTimeValue;

@property (nonatomic,strong) UIView   *saleOrderCodeView;
@property (nonatomic,strong) UILabel  *saleOrderCodeTitle;
@property (nonatomic,strong) UILabel  *saleOrderCodeValue;

@property (nonatomic,strong) UIView   *saleOrderServiceView;
@property (nonatomic,strong) UILabel  *saleOrderServiceTitle;
@property (nonatomic,strong) UILabel  *saleOrderServiceValue;

@property (nonatomic,strong) UIView   *saleOrderChargeView;
@property (nonatomic,strong) UILabel  *saleOrderChargeTitle;
@property (nonatomic,strong) UILabel  *saleOrderChargeValue;

@property (nonatomic,strong) UIView   *saleOrderProgressView;
@property (nonatomic,strong) UILabel  *saleOrderProgressTitle;
@property (nonatomic,strong) UILabel  *saleOrderProgressValue;

@property (nonatomic,strong) UIView   *saleOrderPhoneView;
@property (nonatomic,strong) UILabel  *saleOrderPhoneTitle;
@property (nonatomic,strong) UILabel  *saleOrderPhoneValue;

@property (nonatomic,strong) UIView   *saleOrderRemarkView;
@property (nonatomic,strong) UILabel  *saleOrderRemarkTitle;
@property (nonatomic,strong) UILabel  *saleOrderRemarkValue;

@property (nonatomic,strong) UIButton *starBtn;

@property (nonatomic,strong ) UILabel     *stepBtn;
@property (nonatomic,strong ) UILabel     *saveBtn;
@property (nonatomic,strong ) UILabel     *formBtn;
@property (nonatomic,strong ) UILabel     *cameraBtn;
@property (nonatomic,strong ) UILabel     *qrCodeBtn;

@property (nonatomic,strong) UIView *view;
@property (nonatomic,strong) WorkOrder *workOrder;

+ (instancetype)viewInstance;
@end
