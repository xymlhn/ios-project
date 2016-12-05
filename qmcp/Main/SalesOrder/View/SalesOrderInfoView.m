//
//  SalesOrderInfoView.m
//  qmcp
//
//  Created by 谢永明 on 2016/9/23.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderInfoView.h"
#import "EnumUtil.h"
@implementation SalesOrderInfoView

+ (instancetype)viewInstance{
    SalesOrderInfoView *workOrderInfoView = [SalesOrderInfoView new];
    return workOrderInfoView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = NO;
    [self addSubview:_scrollView];

    [self setupOrderStatus];
    [self setupCustomer];
    [self setupSalesOrder];
    [self setupOnSiteBtn];

    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.bottom.mas_equalTo(_starBtn.mas_bottom).offset(kBottomHeight);
    }];
    return self;
}

-(NSMutableArray<UIImageView *> *)tabView{
    if (_tabView == nil) {
        _tabView = [NSMutableArray new];
    }
    return _tabView;
}

-(void)setSalesOrder:(SalesOrder *)salesOrder{

    _remarkValue.text = salesOrder.remark;
    _saleOrderServiceValue.text = salesOrder.organizationName;
    _appointmentTimeValue.text = salesOrder.appointmentTime;
    _addressValue.text = salesOrder.addressSnapshot.fullAddress ;
    _phoneValue.text = salesOrder.addressSnapshot.mobilePhone;
    _nameValue.text = salesOrder.addressSnapshot.contacts;
    _saleOrderCodeValue.text = salesOrder.code;
    _saleOrderTotalValue.text = [NSString stringWithFormat:@"%.2lf   ",salesOrder.totalAmount];
    _saleOrderPayStatusValue.text = [EnumUtil payStatusString:salesOrder.paymentStatus];
    _saleOrderServiceValue.text = [salesOrder.commodityNames componentsJoinedByString:@","];
    _agreePriceValue.text = salesOrder.agreementPrice == nil ? @"待定" : salesOrder.agreementPrice;
    
    _inventoryImage.image = [UIImage imageNamed:salesOrder.signedFlag ? @"sales_inventory_success":@"sales_inventory_fail"];
    _progressImage.image = [UIImage imageNamed:salesOrder.processingFlag ? @"sales_progress_success":@"sales_progress_fail"];
    _payImage.image = [UIImage imageNamed:salesOrder.paidFlag ? @"sales_pay_success":@"sales_pay_fail"];
    [self.tabView removeAllObjects];
    switch (salesOrder.type) {
        case SalesOrderTypeOnsite:
            [self initServiceBottomView];
            switch (salesOrder.onSiteStatus) {
                case OnSiteStatusNone:
                case OnSiteStatusWaiting:
                case OnSiteStatusNotDepart:
                    [_starBtn setTitle:@"出发" forState:UIControlStateNormal];
                    break;
                case OnSiteStatusOnRoute:
                    [_starBtn setTitle:@"到达" forState:UIControlStateNormal];
                    break;
                default:
                    [self p_updateConstraints];
                    [_starBtn setHidden:YES];
                    break;
            }
            
            break;
        case SalesOrderTypeShop:
            [self p_updateConstraints];
            [self initServiceBottomView];
            [_starBtn setHidden:YES];
            break;
        case SalesOrderTypeRemote:
            [self p_updateConstraints];
            [self initServiceBottomView];
            [_starBtn setHidden:YES];
            break;
        default:
            break;
    }
    
}

-(void)p_updateConstraints{
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.bottom.mas_equalTo(_orderView.mas_bottom).offset(kBottomHeight);
    }];
}

//订单状态
-(void)setupOrderStatus{
    
    _statusView = [UIView new];
    _statusView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_statusView];
    
    UILabel *topLabel = [UILabel new];
    topLabel.font = [UIFont systemFontOfSize:18];
    topLabel.text = @"订单状态";
    topLabel.textColor = [UIColor secondTextColor];
    [_statusView addSubview:topLabel];
    
    _inventoryImage = [UIImageView new];
    _inventoryImage.image = [UIImage imageNamed:@"default－portrait"];
    [_statusView addSubview:_inventoryImage];
    
    _progressImage = [UIImageView new];
    _progressImage.image = [UIImage imageNamed:@"default－portrait"];
    [_statusView addSubview:_progressImage];
    
    _payImage = [UIImageView new];
    _payImage.image = [UIImage imageNamed:@"default－portrait"];
    [_statusView addSubview:_payImage];

    [_statusView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_scrollView.mas_top).with.offset(0);
        make.left.equalTo(_scrollView.mas_left).with.offset(0);
        make.right.equalTo(_scrollView.mas_right).with.offset(0);
        make.height.mas_equalTo(@113);
    }];
    
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_statusView.mas_top).with.offset(kPaddingTopWidth);
        make.left.equalTo(_statusView.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    [_inventoryImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(topLabel.mas_bottom).with.offset(kPaddingTopWidth);
        make.left.equalTo(topLabel.mas_left).with.offset(0);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@50);
    }];
    
    [_progressImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(topLabel.mas_bottom).with.offset(kPaddingTopWidth);
        make.left.equalTo(_inventoryImage.mas_right).with.offset(kPaddingTopWidth);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@50);
    }];
    
    [_payImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(topLabel.mas_bottom).with.offset(kPaddingTopWidth);
        make.left.equalTo(_progressImage.mas_right).with.offset(kPaddingTopWidth);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@50);
    }];
}

//客户信息
-(void)setupCustomer{
    UIView *separateView = [UIView new];
    separateView.backgroundColor = [UIColor themeColor];
    [_scrollView addSubview:separateView];
    
    _customView = [UIView new];
    _customView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_customView];
    
    _nameView = [UIView new];
    _nameView.backgroundColor = [UIColor whiteColor];
    [_customView addSubview:_nameView];
    
    _nameTitle = [UILabel new];
    _nameTitle.font = [UIFont systemFontOfSize:kShisipt];
    _nameTitle.text = @"客户名称";
    _nameTitle.textColor = [UIColor secondTextColor];
    [_nameView addSubview:_nameTitle];
    
    _nameValue = [UILabel new];
    _nameValue.font = [UIFont systemFontOfSize:kShisipt];
    _nameValue.text = @"";
    _nameValue.textColor = [UIColor mainTextColor];
    [_nameView addSubview:_nameValue];
    
    UIView *nameLine = [UIView new];
    nameLine.backgroundColor = [UIColor lineColor];
    [_nameView addSubview:nameLine];
    
    _phoneView = [UIView new];
    _phoneView.backgroundColor = [UIColor whiteColor];
    [_customView addSubview:_phoneView];
    
    _phoneTitle = [UILabel new];
    _phoneTitle.font = [UIFont systemFontOfSize:kShisipt];
    _phoneTitle.text = @"联系方式";
    _phoneTitle.textColor = [UIColor secondTextColor];
    [_phoneView addSubview:_phoneTitle];
    
    _phoneValue = [UILabel new];
    _phoneValue.font = [UIFont systemFontOfSize:kShisipt];
    _phoneValue.text = @"";
    _phoneValue.textColor = [UIColor mainTextColor];
    [_phoneView addSubview:_phoneValue];
    
    UIView *phoneLine = [UIView new];
    phoneLine.backgroundColor = [UIColor lineColor];
    [_phoneView addSubview:phoneLine];
    
    _addressView = [UIView new];
    _addressView.backgroundColor = [UIColor whiteColor];
    [_customView addSubview:_addressView];
    
    _addressTitle = [UILabel new];
    _addressTitle.font = [UIFont systemFontOfSize:kShisipt];
    _addressTitle.text = @"客户地址";
    _addressTitle.textColor = [UIColor secondTextColor];
    [_addressView addSubview:_addressTitle];
    
    _addressValue = [UILabel new];
    _addressValue.font = [UIFont systemFontOfSize:kShisipt];
    _addressValue.text = @"1234564";
    _addressValue.textColor = [UIColor mainTextColor];
    [_addressView addSubview:_addressValue];
    
    UIView *addressLine = [UIView new];
    addressLine.backgroundColor = [UIColor lineColor];
    [_addressView addSubview:addressLine];
    
    _appointmentTimeView = [UIView new];
    _appointmentTimeView.backgroundColor = [UIColor whiteColor];
    [_customView addSubview:_appointmentTimeView];
    
    _appointmentTimeTitle = [UILabel new];
    _appointmentTimeTitle.font = [UIFont systemFontOfSize:kShisipt];
    _appointmentTimeTitle.text = @"预约时间";
    _appointmentTimeTitle.textColor = [UIColor secondTextColor];
    [_appointmentTimeView addSubview:_appointmentTimeTitle];
    
    _appointmentTimeValue = [UILabel new];
    _appointmentTimeValue.font = [UIFont systemFontOfSize:kShisipt];
    _appointmentTimeValue.text = @"";
    _appointmentTimeValue.textColor = [UIColor mainTextColor];
    [_appointmentTimeView addSubview:_appointmentTimeValue];
    
    UIView *appointmentTimeLine = [UIView new];
    appointmentTimeLine.backgroundColor = [UIColor lineColor];
    [_appointmentTimeView addSubview:appointmentTimeLine];
    
    _remarkView = [UIView new];
    _remarkView.backgroundColor = [UIColor whiteColor];
    [_customView addSubview:_remarkView];
    
    _remarkTitle = [UILabel new];
    _remarkTitle.font = [UIFont systemFontOfSize:kShisipt];
    _remarkTitle.text = @"客户备注";
    _remarkTitle.textColor = [UIColor secondTextColor];
    [_remarkView addSubview:_remarkTitle];
    
    _remarkValue = [UILabel new];
    _remarkValue.font = [UIFont systemFontOfSize:kShisipt];
    _remarkValue.text = @"";
    _remarkValue.textColor = [UIColor mainTextColor];
    [_remarkView addSubview:_remarkValue];
    
    [separateView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_statusView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@10);
    }];
    
    [_customView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(separateView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self .mas_right).with.offset(0);
        make.height.mas_equalTo(@205);
    }];
    
    [_nameView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_customView.mas_top).with.offset(0);
        make.left.equalTo(_customView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(_customView.mas_right).with.offset(0);
        make.height.mas_equalTo(kEditHeight);
    }];
    
    [_nameTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_nameView.mas_centerY);
        make.left.equalTo(_nameView.mas_left).with.offset(0);
    }];
    [_nameValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_nameView.mas_centerY);
        make.left.equalTo(_nameTitle.mas_right).with.offset(kEditLeftWidth);
    }];
    
    [nameLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_nameView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    [_phoneView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_nameView.mas_bottom).with.offset(0);
        make.left.equalTo(_customView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(_customView.mas_right).with.offset(0);
        make.height.mas_equalTo(kEditHeight);
    }];
    
    [_phoneTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_phoneView.mas_centerY);
        make.left.equalTo(_phoneView.mas_left).with.offset(0);
    }];
    [_phoneValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_phoneView.mas_centerY);
        make.left.equalTo(_phoneTitle.mas_right).with.offset(kEditLeftWidth);
    }];
    
    [phoneLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_phoneView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    [_addressView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_phoneView.mas_bottom).with.offset(0);
        make.left.equalTo(_customView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(_customView.mas_right).with.offset(0);
        make.height.mas_equalTo(kEditHeight);
    }];
    
    [_addressTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_addressView.mas_left).with.offset(0);
        make.centerY.equalTo(_addressView.mas_centerY);
    }];
    [_addressValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_addressView.mas_centerY);
        make.left.equalTo(_addressTitle.mas_right).with.offset(kEditLeftWidth);
    }];
    [addressLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_addressView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(kLineHeight);
    }];
    [_appointmentTimeView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_addressView.mas_bottom).with.offset(0);
        make.left.equalTo(_customView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(_customView.mas_right).with.offset(0);
        make.height.mas_equalTo(kEditHeight);
    }];
    
    [_appointmentTimeTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_appointmentTimeView.mas_centerY);
        make.left.equalTo(_appointmentTimeView.mas_left).with.offset(0);
    }];
    [_appointmentTimeValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_appointmentTimeView.mas_centerY);
        make.left.equalTo(_appointmentTimeTitle.mas_right).with.offset(kEditLeftWidth);
    }];
    [appointmentTimeLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_appointmentTimeView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    [_remarkView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_appointmentTimeView.mas_bottom).with.offset(0);
        make.left.equalTo(_customView.mas_left).with.offset(0);
        make.right.equalTo(_customView.mas_right).with.offset(0);
        make.height.mas_equalTo(kEditHeight);
    }];
    
    [_remarkTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_remarkView.mas_centerY);
        make.left.equalTo(_remarkView.mas_left).with.offset(kPaddingLeftWidth);
    }];
    [_remarkValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_remarkView.mas_centerY);
        make.left.equalTo(_remarkTitle.mas_right).with.offset(kEditLeftWidth);
    }];
    
}

//订单信息
-(void)setupSalesOrder{
    UIView *separateView = [UIView new];
    separateView.backgroundColor = [UIColor themeColor];
    [_scrollView addSubview:separateView];
    
    _orderView = [UIView new];
    _orderView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_orderView];
    
    _saleOrderCodeView = [UIView new];
    _saleOrderCodeView.backgroundColor = [UIColor whiteColor];
    [_orderView addSubview:_saleOrderCodeView];
    
    _saleOrderCodeTitle = [UILabel new];
    _saleOrderCodeTitle.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderCodeTitle.text = @"订单编号";
    _saleOrderCodeTitle.textColor = [UIColor secondTextColor];
    [_saleOrderCodeView addSubview:_saleOrderCodeTitle];
    
    _saleOrderCodeValue = [UILabel new];
    _saleOrderCodeValue.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderCodeValue.text = @"";
    _saleOrderCodeValue.textColor = [UIColor mainTextColor];
    [_saleOrderCodeView addSubview:_saleOrderCodeValue];
    
    UIView *codeLine = [UIView new];
    codeLine.backgroundColor = [UIColor lineColor];
    [_saleOrderCodeView addSubview:codeLine];
    
    _saleOrderServiceView = [UIView new];
    _saleOrderServiceView.backgroundColor = [UIColor whiteColor];
    [_orderView addSubview:_saleOrderServiceView];
    
    _saleOrderServiceTitle= [UILabel new];
    _saleOrderServiceTitle.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderServiceTitle.text = @"订单服务";
    _saleOrderServiceTitle.textColor = [UIColor secondTextColor];
    [_saleOrderServiceView addSubview:_saleOrderServiceTitle];
    
    _saleOrderServiceValue = [UILabel new];
    _saleOrderServiceValue.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderServiceValue.text = @"";
    _saleOrderServiceValue.textColor = [UIColor mainTextColor];
    [_saleOrderServiceView addSubview:_saleOrderServiceValue];
    
    UIView *serviceLine = [UIView new];
    serviceLine.backgroundColor = [UIColor lineColor];
    [_saleOrderServiceView addSubview:serviceLine];
    
    _saleOrderTotalView = [UIView new];
    _saleOrderTotalView.backgroundColor = [UIColor whiteColor];
    [_orderView addSubview:_saleOrderTotalView];
    
    _saleOrderTotalTitle = [UILabel new];
    _saleOrderTotalTitle.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderTotalTitle.text = @"订单总额";
    _saleOrderTotalTitle.textColor = [UIColor secondTextColor];
    [_saleOrderTotalView addSubview:_saleOrderTotalTitle];
    
    _saleOrderTotalValue = [UILabel new];
    _saleOrderTotalValue.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderTotalValue.text = @"";
    _saleOrderTotalValue.textColor = [UIColor mainTextColor];
    [_saleOrderTotalView addSubview:_saleOrderTotalValue];
    
    UIView *totalLine = [UIView new];
    totalLine.backgroundColor = [UIColor lineColor];
    [_saleOrderTotalView addSubview:totalLine];
    
    _agreePriceView = [UIView new];
    _agreePriceView.backgroundColor = [UIColor whiteColor];
    [_orderView addSubview:_agreePriceView];
    
    _agreePriceTitle = [UILabel new];
    _agreePriceTitle.font = [UIFont systemFontOfSize:kShisipt];
    _agreePriceTitle.text = @"协议价格";
    _agreePriceTitle.textColor = [UIColor secondTextColor];
    [_agreePriceView addSubview:_agreePriceTitle];
    
    _agreePriceValue = [UILabel new];
    _agreePriceValue.font = [UIFont systemFontOfSize:kShisipt];
    _agreePriceValue.text = @"";
    _agreePriceValue.textColor = [UIColor mainTextColor];
    [_agreePriceView addSubview:_agreePriceValue];
    
    _agreeBtn = [UIButton new];
    _agreeBtn.layer.masksToBounds = YES;
    _agreeBtn.backgroundColor = [UIColor appBlueColor];
    _agreeBtn.layer.cornerRadius = kBottomButtonCorner;
    [_agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:kShierpt];
    [_agreeBtn setTitle:@"修改" forState:UIControlStateNormal];
    [self addSubview:_agreeBtn];
    
    UIView *agreeLine = [UIView new];
    agreeLine.backgroundColor = [UIColor lineColor];
    [_agreePriceView addSubview:agreeLine];
    
    _saleOrderPayStatusView = [UIView new];
    _saleOrderPayStatusView.backgroundColor = [UIColor whiteColor];
    [_orderView addSubview:_saleOrderPayStatusView];
    
    _saleOrderPayStatusTitle = [UILabel new];
    _saleOrderPayStatusTitle.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderPayStatusTitle.text = @"支付状态";
    _saleOrderPayStatusTitle.textColor = [UIColor secondTextColor];
    [_saleOrderPayStatusView addSubview:_saleOrderPayStatusTitle];
    
    _saleOrderPayStatusValue = [UILabel new];
    _saleOrderPayStatusValue.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderPayStatusValue.text = @"";
    _saleOrderPayStatusValue.textColor = [UIColor mainTextColor];
    [_saleOrderPayStatusView addSubview:_saleOrderPayStatusValue];
    
    [separateView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_customView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@10);
    }];
    
    [_orderView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(separateView.mas_bottom).with.offset(0);
        make.left.equalTo(_scrollView.mas_left).with.offset(0);
        make.right.equalTo(_scrollView.mas_right).with.offset(0);
        make.height.mas_equalTo(@205);
    }];
    
    [_saleOrderCodeView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_orderView.mas_top).with.offset(0);
        make.left.equalTo(_orderView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(_orderView.mas_right).with.offset(0);
        make.height.mas_equalTo(kEditHeight);
    }];
    
    [_saleOrderCodeTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderCodeView.mas_centerY);
        make.left.equalTo(_saleOrderCodeView.mas_left).with.offset(0);
    }];
    [_saleOrderCodeValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderCodeView.mas_centerY);
        make.left.equalTo(_saleOrderCodeTitle.mas_right).with.offset(kEditLeftWidth);
    }];
    
    [codeLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_saleOrderCodeView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    [_saleOrderServiceView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_saleOrderCodeView.mas_bottom).with.offset(0);
        make.left.equalTo(_orderView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(_orderView.mas_right).with.offset(0);
        make.height.mas_equalTo(kEditHeight);
    }];
    
    [_saleOrderServiceTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderServiceView.mas_centerY);
        make.left.equalTo(_saleOrderServiceView.mas_left).with.offset(0);
    }];
    [_saleOrderServiceValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderServiceView.mas_centerY);
        make.left.equalTo(_saleOrderServiceTitle.mas_right).with.offset(kEditLeftWidth);
    }];
    
    [serviceLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_saleOrderServiceView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    [_saleOrderTotalView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_saleOrderServiceView.mas_bottom).with.offset(0);
        make.left.equalTo(_orderView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(_orderView.mas_right).with.offset(0);
        make.height.mas_equalTo(kEditHeight);
    }];
    
    [_saleOrderTotalTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderTotalView.mas_centerY);
        make.left.equalTo(_saleOrderTotalView.mas_left).with.offset(0);
    }];
    [_saleOrderTotalValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderTotalView.mas_centerY);
        make.left.equalTo(_saleOrderTotalTitle.mas_right).with.offset(kEditLeftWidth);
    }];
    
    [totalLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_saleOrderTotalView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    [_agreePriceView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_saleOrderTotalView.mas_bottom).with.offset(0);
        make.left.equalTo(_orderView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(_orderView.mas_right).with.offset(0);
        make.height.mas_equalTo(kEditHeight);
    }];
    
    [_agreePriceTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_agreePriceView.mas_centerY);
        make.left.equalTo(_agreePriceView.mas_left).with.offset(0);
    }];
    [_agreePriceValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_agreePriceView.mas_centerY);
        make.left.equalTo(_agreePriceTitle.mas_right).with.offset(kEditLeftWidth);
    }];
    
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_agreePriceView.mas_centerY);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.width.equalTo(@69);
        make.height.equalTo(@26);
    }];
    
    [agreeLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_agreePriceView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    [_saleOrderPayStatusView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_agreePriceView.mas_bottom).with.offset(0);
        make.left.equalTo(_orderView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(_orderView.mas_right).with.offset(0);
        make.height.mas_equalTo(kEditHeight);
    }];
    
    [_saleOrderPayStatusTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderPayStatusView.mas_centerY);
        make.left.equalTo(_saleOrderPayStatusView.mas_left).with.offset(0);
    }];
    [_saleOrderPayStatusValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderPayStatusView.mas_centerY);
        make.left.equalTo(_saleOrderPayStatusTitle.mas_right).with.offset(kEditLeftWidth);
    }];
    
}
//开始按钮
-(void)setupOnSiteBtn{
    
    UIView *separateView = [UIView new];
    separateView.backgroundColor = [UIColor themeColor];
    [_scrollView addSubview:separateView];
    
    _starBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _starBtn.layer.masksToBounds = YES;
    _starBtn.backgroundColor = [UIColor appBlueColor];
    _starBtn.layer.cornerRadius = 40;
    [_starBtn setTitle:@"上门" forState:UIControlStateNormal];
    [_starBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _starBtn.titleLabel.font = [UIFont systemFontOfSize: kShiwupt];
    [_scrollView addSubview:_starBtn];
    
    [separateView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_orderView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@10);
    }];
    
    [_starBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(separateView.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_equalTo(@80);
        make.width.mas_equalTo(@80);
    }];
}

-(void)initServiceBottomView{
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1.0];
    [self addSubview:bottomView];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor lineColor];
    [bottomView addSubview:codeBottomLine];

    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@50);
    }];
    
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(bottomView.mas_top).with.offset(0);
        make.left.equalTo(bottomView.mas_left).with.offset(0);
        make.right.equalTo(bottomView.mas_right).with.offset(0);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    for (int i = 0; i < self.tabIcon.count; i++) {

        UIImageView *imageBtn = [UIImageView new];
        [imageBtn setContentMode:UIViewContentModeScaleAspectFit];
        imageBtn.image = [UIImage imageNamed:self.tabIcon[i]];
        imageBtn.tag = i;
        [bottomView addSubview:imageBtn];
        [self.tabView addObject:imageBtn];
        
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:kJiupt];
        label.text = self.tabLabel[i];
        label.textColor = [UIColor appBlueColor];
        [bottomView addSubview:label];
        
        if (i == 0) {
            [imageBtn mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(bottomView).with.offset(0);
                make.top.equalTo(bottomView.mas_top).offset(6);
            }];
        }else if (i == self.tabIcon.count  - 1){
            
            [imageBtn mas_makeConstraints:^(MASConstraintMaker *make){
                make.width.equalTo(self.tabView[i-1]);
                make.left.equalTo(self.tabView[i-1].mas_right);
                make.right.equalTo(bottomView);
                make.top.equalTo(bottomView.mas_top).offset(6);
            }];
        
        }else{
            [imageBtn mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(self.tabView[i-1].mas_right).with.offset(0);
                make.width.equalTo(self.tabView[i - 1]);
                make.top.equalTo(bottomView.mas_top).offset(6);
            }];

        }
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bottomView.mas_bottom).with.offset(-6);
            make.centerX.equalTo(imageBtn.mas_centerX);
        }];
    }
    
}
@end
