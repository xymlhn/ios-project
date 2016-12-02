//
//  WorkOrderInfoView.m
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderInfoView.h"

@implementation WorkOrderInfoView

+ (instancetype)viewInstance{
    WorkOrderInfoView *workOrderInfoView = [WorkOrderInfoView new];
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

    [self setupCustomer];
    [self setupSalesOrder];
    [self setupOnSiteBtn];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.bottom.mas_equalTo(_starBtn.mas_bottom).offset(kBottomHeight);
    }];

   
    _view = self;
    return self;
}

-(void)setWorkOrder:(WorkOrder *)workOrder{
    
    if (workOrder.salesOrderSnapshot != nil) {
        _saleOrderCodeValue.text = workOrder.salesOrderSnapshot.code;
        _saleOrderProgressValue.text = workOrder.salesOrderSnapshot.appointmentTime;
        _saleOrderServiceValue.text = [workOrder.salesOrderSnapshot.commodityNames componentsJoinedByString:@","];
        _saleOrderChargeValue.text = workOrder.salesOrderSnapshot.personInChargeName;
        _saleOrderPhoneValue.text = workOrder.salesOrderSnapshot.personInChargeMobile;
        _saleOrderRemarkValue.text = workOrder.salesOrderSnapshot.remark;
        _appointmentTimeValue.text = workOrder.salesOrderSnapshot.appointmentTime;
        AddressSnapshot *address = workOrder.salesOrderSnapshot.addressSnapshot;
        if (address != nil) {
            _nameValue.text = address.contacts;
            _phoneValue.text = address.mobilePhone;
            _addressValue.text = address.fullAddress;
            
        }
       
    }
    
    switch (workOrder.type) {
        case WorkOrderTypeOnsite:
            [self initOnsiteBottomView];
            switch (_workOrder.onSiteStatus) {
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
        case WorkOrderTypeService:
            [self initOnsiteBottomView];
            [_starBtn setHidden:YES];
            [self p_updateConstraints];
            break;
        default:
            break;
    }
}

//客户信息
-(void)setupCustomer{
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

    [_customView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_scrollView.mas_top).with.offset(0);
        make.left.equalTo(_scrollView.mas_left).with.offset(0);
        make.right.equalTo(_scrollView .mas_right).with.offset(0);
        make.height.mas_equalTo(@165);
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
    _saleOrderCodeTitle.text = @"所属订单";
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
    
    _saleOrderProgressView = [UIView new];
    _saleOrderProgressView.backgroundColor = [UIColor whiteColor];
    [_orderView addSubview:_saleOrderProgressView];
    
    _saleOrderProgressTitle = [UILabel new];
    _saleOrderProgressTitle.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderProgressTitle.text = @"订单持续";
    _saleOrderProgressTitle.textColor = [UIColor secondTextColor];
    [_saleOrderProgressView addSubview:_saleOrderProgressTitle];
    
    _saleOrderProgressValue = [UILabel new];
    _saleOrderProgressValue.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderProgressValue.text = @"";
    _saleOrderProgressValue.textColor = [UIColor mainTextColor];
    [_saleOrderProgressView addSubview:_saleOrderProgressValue];
    
    UIView *progressLine = [UIView new];
    progressLine.backgroundColor = [UIColor lineColor];
    [_saleOrderProgressView addSubview:progressLine];
    
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
    
    _saleOrderChargeView = [UIView new];
    _saleOrderChargeView.backgroundColor = [UIColor whiteColor];
    [_orderView addSubview:_saleOrderChargeView];
    
    _saleOrderChargeTitle = [UILabel new];
    _saleOrderChargeTitle.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderChargeTitle.text = @"负责人员";
    _saleOrderChargeTitle.textColor = [UIColor secondTextColor];
    [_saleOrderChargeView addSubview:_saleOrderChargeTitle];
    
    _saleOrderChargeValue = [UILabel new];
    _saleOrderChargeValue.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderChargeValue.text = @"";
    _saleOrderChargeValue.textColor = [UIColor mainTextColor];
    [_saleOrderChargeView addSubview:_saleOrderChargeValue];
    
    UIView *chargeLine = [UIView new];
    chargeLine.backgroundColor = [UIColor lineColor];
    [_saleOrderChargeView addSubview:chargeLine];
    
    _saleOrderPhoneView = [UIView new];
    _saleOrderPhoneView.backgroundColor = [UIColor whiteColor];
    [_orderView addSubview:_saleOrderPhoneView];
    
    _saleOrderPhoneTitle = [UILabel new];
    _saleOrderPhoneTitle.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderPhoneTitle.text = @"联络方式";
    _saleOrderPhoneTitle.textColor = [UIColor secondTextColor];
    [_saleOrderPhoneView addSubview:_saleOrderPhoneTitle];
    
    _saleOrderPhoneValue = [UILabel new];
    _saleOrderPhoneValue.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderPhoneValue.text = @"";
    _saleOrderPhoneValue.textColor = [UIColor mainTextColor];
    [_saleOrderPhoneView addSubview:_saleOrderPhoneValue];
    
    UIView *phoneLine = [UIView new];
    phoneLine.backgroundColor = [UIColor lineColor];
    [_saleOrderPhoneView addSubview:phoneLine];
    
    _saleOrderRemarkView = [UIView new];
    _saleOrderRemarkView.backgroundColor = [UIColor whiteColor];
    [_orderView addSubview:_saleOrderRemarkView];
    
    _saleOrderRemarkTitle = [UILabel new];
    _saleOrderRemarkTitle.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderRemarkTitle.text = @"客户留言";
    _saleOrderRemarkTitle.textColor = [UIColor secondTextColor];
    [_saleOrderRemarkView addSubview:_saleOrderRemarkTitle];
    
    _saleOrderRemarkValue = [UILabel new];
    _saleOrderRemarkValue.font = [UIFont systemFontOfSize:kShisipt];
    _saleOrderRemarkValue.text = @"";
    _saleOrderRemarkValue.textColor = [UIColor mainTextColor];
    [_saleOrderRemarkView addSubview:_saleOrderRemarkValue];
    
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
        make.height.mas_equalTo(@245);
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
    
    [_saleOrderProgressView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_saleOrderCodeView.mas_bottom).with.offset(0);
        make.left.equalTo(_orderView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(_orderView.mas_right).with.offset(0);
        make.height.mas_equalTo(kEditHeight);
    }];
    
    [_saleOrderProgressTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderProgressView.mas_centerY);
        make.left.equalTo(_saleOrderProgressView.mas_left).with.offset(0);
    }];
    [_saleOrderProgressValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderProgressView.mas_centerY);
        make.left.equalTo(_saleOrderProgressTitle.mas_right).with.offset(kEditLeftWidth);
    }];
    
    [progressLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_saleOrderProgressView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    [_saleOrderServiceView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_saleOrderProgressView.mas_bottom).with.offset(0);
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
    
    [_saleOrderChargeView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_saleOrderServiceView.mas_bottom).with.offset(0);
        make.left.equalTo(_orderView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(_orderView.mas_right).with.offset(0);
        make.height.mas_equalTo(kEditHeight);
    }];
    
    [_saleOrderChargeTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderChargeView.mas_centerY);
        make.left.equalTo(_saleOrderChargeView.mas_left).with.offset(0);
    }];
    [_saleOrderChargeValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderChargeView.mas_centerY);
        make.left.equalTo(_saleOrderChargeTitle.mas_right).with.offset(kEditLeftWidth);
    }];
    
    [chargeLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_saleOrderChargeView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    [_saleOrderPhoneView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_saleOrderChargeView.mas_bottom).with.offset(0);
        make.left.equalTo(_orderView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(_orderView.mas_right).with.offset(0);
        make.height.mas_equalTo(kEditHeight);
    }];
    
    [_saleOrderPhoneTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderPhoneView.mas_centerY);
        make.left.equalTo(_saleOrderPhoneView.mas_left).with.offset(0);
    }];
    [_saleOrderPhoneValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderPhoneView.mas_centerY);
        make.left.equalTo(_saleOrderPhoneTitle.mas_right).with.offset(kEditLeftWidth);
    }];
    [phoneLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_saleOrderPhoneView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.height.mas_equalTo(kLineHeight);
    }];
    [_saleOrderRemarkView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_saleOrderPhoneView.mas_bottom).with.offset(0);
        make.left.equalTo(_orderView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(_orderView.mas_right).with.offset(0);
        make.height.mas_equalTo(kEditHeight);
    }];
    
    [_saleOrderRemarkTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderRemarkView.mas_centerY);
        make.left.equalTo(_saleOrderRemarkView.mas_left).with.offset(0);
    }];
    [_saleOrderRemarkValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_saleOrderRemarkView.mas_centerY);
        make.left.equalTo(_saleOrderRemarkTitle.mas_right).with.offset(kEditLeftWidth);
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

-(void)initOnsiteBottomView{
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:codeBottomLine];
    
    _qrCodeBtn = [UILabel new];
    [_qrCodeBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _qrCodeBtn.text = @"";
    _qrCodeBtn.textColor = [UIColor nameColor];
    _qrCodeBtn.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_qrCodeBtn];
    
    UILabel *qrCodeLabel = [UILabel new];
    qrCodeLabel.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    qrCodeLabel.text = @"身份";
    qrCodeLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:qrCodeLabel];
    
    _stepBtn = [UILabel new];
    [_stepBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _stepBtn.text = @"";
    _stepBtn.textColor = [UIColor nameColor];
    _stepBtn.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_stepBtn];
    
    UILabel *addLabel = [UILabel new];
    addLabel.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    addLabel.text = @"步骤";
    addLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:addLabel];
    
    _formBtn = [UILabel new];
    [_formBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _formBtn.text = @"";
    _formBtn.textColor = [UIColor nameColor];
    _formBtn.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_formBtn];
    
    UILabel *formLabel = [UILabel new];
    formLabel.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    formLabel.text = @"表单";
    formLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:formLabel];
    
    _saveBtn = [UILabel new];
    [_saveBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _saveBtn.text = @"";
    _saveBtn.textAlignment = NSTextAlignmentCenter;
    _saveBtn.textColor = [UIColor nameColor];
    [bottomView addSubview:_saveBtn];
    
    UILabel *saveLabel = [UILabel new];
    saveLabel.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    saveLabel.text = @"保存";
    saveLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:saveLabel];
    
    UILabel *inventoryLabel = [UILabel new];
    inventoryLabel.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    inventoryLabel.text = @"清点";
    inventoryLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:inventoryLabel];
    
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
    
    [_stepBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(bottomView).with.offset(0);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    
    [formLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_formBtn.mas_bottom);
        make.centerX.equalTo(_formBtn.mas_centerX);
    }];
    
    [_formBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_stepBtn);
        make.left.equalTo(_stepBtn.mas_right);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_stepBtn.mas_bottom);
        make.centerX.equalTo(_stepBtn.mas_centerX);
    }];
    
    [_qrCodeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_stepBtn);
        make.left.equalTo(_formBtn.mas_right);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    
    [qrCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_qrCodeBtn.mas_bottom);
        make.centerX.equalTo(_qrCodeBtn.mas_centerX);
    }];
    
    
    [saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_saveBtn.mas_bottom);
        make.centerX.equalTo(_saveBtn.mas_centerX);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_qrCodeBtn);
        make.left.equalTo(_qrCodeBtn.mas_right);
        make.right.equalTo(bottomView);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    
    
}

-(void)initServiceBottomView{
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:codeBottomLine];
    
    _cameraBtn = [UILabel new];
    [_cameraBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _cameraBtn.text = @"";
    _cameraBtn.textColor = [UIColor nameColor];
    _cameraBtn.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_cameraBtn];
    
    UILabel *qrCodeLabel = [UILabel new];
    qrCodeLabel.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    qrCodeLabel.text = @"摄像头";
    qrCodeLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:qrCodeLabel];
    
    _stepBtn = [UILabel new];
    [_stepBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _stepBtn.text = @"";
    _stepBtn.textColor = [UIColor nameColor];
    _stepBtn.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_stepBtn];
    
    UILabel *addLabel = [UILabel new];
    addLabel.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    addLabel.text = @"步骤";
    addLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:addLabel];
    
    _formBtn = [UILabel new];
    [_formBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _formBtn.text = @"";
    _formBtn.textColor = [UIColor nameColor];
    _formBtn.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_formBtn];
    
    UILabel *formLabel = [UILabel new];
    formLabel.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    formLabel.text = @"表单";
    formLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:formLabel];
    
    _saveBtn = [UILabel new];
    [_saveBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _saveBtn.text = @"";
    _saveBtn.textAlignment = NSTextAlignmentCenter;
    _saveBtn.textColor = [UIColor nameColor];
    [bottomView addSubview:_saveBtn];
    
    UILabel *saveLabel = [UILabel new];
    saveLabel.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    saveLabel.text = @"保存";
    saveLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:saveLabel];
    
    
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
    
    [_stepBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(bottomView).with.offset(0);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    
    [formLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_formBtn.mas_bottom);
        make.centerX.equalTo(_formBtn.mas_centerX);
    }];
    
    [_formBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_stepBtn);
        make.left.equalTo(_stepBtn.mas_right);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_stepBtn.mas_bottom);
        make.centerX.equalTo(_stepBtn.mas_centerX);
    }];
    
    [_cameraBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_stepBtn);
        make.left.equalTo(_formBtn.mas_right);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    
    [qrCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cameraBtn.mas_bottom);
        make.centerX.equalTo(_cameraBtn.mas_centerX);
    }];
    
    [saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_saveBtn.mas_bottom);
        make.centerX.equalTo(_saveBtn.mas_centerX);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_cameraBtn);
        make.left.equalTo(_cameraBtn.mas_right);
        make.right.equalTo(bottomView);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    
}

-(void)p_updateConstraints{
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.bottom.mas_equalTo(_orderView.mas_bottom).offset(kBottomHeight);
    }];
}

@end
