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

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *containerView;
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

@property (nonatomic,strong) UIView   *remarkView;
@property (nonatomic,strong) UILabel  *remarkTitle;
@property (nonatomic,strong) UILabel  *remarkValue;

@property (nonatomic,strong) UIView   *saleOrderCodeView;
@property (nonatomic,strong) UILabel  *saleOrderCodeTitle;
@property (nonatomic,strong) UILabel  *saleOrderCodeValue;

@property (nonatomic,strong) UIView   *saleOrderServiceView;
@property (nonatomic,strong) UILabel  *saleOrderServiceTitle;
@property (nonatomic,strong) UILabel  *saleOrderServiceValue;

@property (nonatomic,strong) UIView   *saleOrderTotalView;
@property (nonatomic,strong) UILabel  *saleOrderTotalTitle;
@property (nonatomic,strong) UILabel  *saleOrderTotalValue;

@property (nonatomic,strong) UIView   *agreePriceView;
@property (nonatomic,strong) UILabel  *agreePriceTitle;
@property (nonatomic,strong) UILabel  *agreePriceValue;
@property (nonatomic, strong) UIButton *agreeBtn;

@property (nonatomic,strong) UIView   *saleOrderPayStatusView;
@property (nonatomic,strong) UILabel  *saleOrderPayStatusTitle;
@property (nonatomic,strong) UILabel  *saleOrderPayStatusValue;

@property (nonatomic, strong) UIImageView *inventoryImage;
@property (nonatomic, strong) UIImageView *progressImage;
@property (nonatomic, strong) UIImageView *payImage;

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UIView *orderView;

@property (nonatomic,strong) UIButton *starBtn;

@property (nonatomic,strong ) UILabel     *stepBtn;
@property (nonatomic,strong ) UILabel     *refreshBtn;
@property (nonatomic,strong ) UILabel     *formBtn;
@property (nonatomic,strong ) UILabel     *cameraBtn;
@property (nonatomic,strong ) UILabel     *qrCodeBtn;
@property (nonatomic,strong ) UILabel     *inventoryBtn;

@property (nonatomic, strong) SalesOrder *salesOrder;


+ (instancetype)viewInstance;

@end
