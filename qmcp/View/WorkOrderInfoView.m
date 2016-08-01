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
    _containView = [UIView new];
    [_containView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_containView];
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 5, 5, 5));
    }];
    [self initCodeView];
    [self initUserView];
    [self initLocationView];
    [self initTypeView];
    [self initAppointmentTimeView];
    [self initServiceView];
    [self initRemarkView];
    
    [self initStarBtn];
    _view = self;
    return self;
}

//编号
-(void)initCodeView
{
    _codeView = [UIView new];
    [_containView addSubview:_codeView];
    [_codeView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_containView.mas_top).with.offset(0);
        make.left.equalTo(_containView.mas_left).with.offset(0);
        make.right.equalTo(_containView.mas_right).with.offset(0);
        make.height.mas_equalTo(@30);
    }];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [_codeView addSubview:codeBottomLine];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_codeView.mas_bottom).with.offset(0);
        make.left.equalTo(_codeView.mas_left).with.offset(0);
        make.right.equalTo(_codeView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    UILabel *codeTitle = [UILabel new];
    codeTitle.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    codeTitle.text = @"No.";
    codeTitle.textColor = [UIColor nameColor];
    [_codeView addSubview:codeTitle];
    
    _codeContent = [UILabel new];
    _codeContent.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    _codeContent.text = @"12305";
    _codeContent.textColor = [UIColor blackColor];
    [_codeView addSubview:_codeContent];
    
    [codeTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_codeView.mas_centerY);
        make.left.equalTo(_codeView.mas_left).with.offset(5);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    
    [_codeContent mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_codeView.mas_centerY);
        make.left.equalTo(codeTitle.mas_right).with.offset(5);
        make.right.equalTo(_codeView.mas_right).with.offset(5);
        make.height.equalTo(@20);
    }];
}
//用户手机
-(void)initUserView
{
    _userView = [UIView new];
    [_containView addSubview:_userView];
    [_userView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_codeView.mas_bottom).with.offset(0);
        make.left.equalTo(_containView.mas_left).with.offset(0);
        make.right.equalTo(_containView.mas_right).with.offset(0);
        make.height.mas_equalTo(@30);
    }];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [_userView addSubview:codeBottomLine];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_userView.mas_bottom).with.offset(0);
        make.left.equalTo(_userView.mas_left).with.offset(0);
        make.right.equalTo(_userView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    UIView *codeMidLine = [UIView new];
    codeMidLine.backgroundColor = [UIColor grayColor];
    [_userView addSubview:codeMidLine];
    [codeMidLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_userView.mas_bottom).with.offset(0);
        make.top.equalTo(_userView.mas_top).with.offset(0);
        make.centerX.equalTo(_userView.mas_centerX).with.offset(0);
        make.width.mas_equalTo(@1);
    }];
    
    UILabel *userIcon = [UILabel new];
    [userIcon setFont:[UIFont fontWithName:@"FontAwesome" size:12]];
    userIcon.text = @"";
    userIcon.textColor = [UIColor nameColor];
    [_userView addSubview:userIcon];
    
    _userNameText = [UILabel new];
    _userNameText.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    _userNameText.text = @"12305";
    _userNameText.textColor = [UIColor blackColor];
    [_userView addSubview:_userNameText];
    
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_userView.mas_centerY);
        make.left.equalTo(_userView.mas_left).with.offset(5);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    
    [_userNameText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_userView.mas_centerY);
        make.left.equalTo(userIcon.mas_right).with.offset(5);
        make.right.equalTo(_userView.mas_right).with.offset(5);
        make.height.equalTo(@20);
    }];
    
    UILabel *passwordIcon = [UILabel new];
    [passwordIcon setFont:[UIFont fontWithName:@"FontAwesome" size:15]];
    passwordIcon.text = @"";
    passwordIcon.textColor = [UIColor nameColor];
    [_userView addSubview:passwordIcon];
    
    _passwordText = [UILabel new];
    _passwordText.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    _passwordText.text = @"12305";
    _passwordText.textColor = [UIColor blackColor];
    [_userView addSubview:_passwordText];
    
    [passwordIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_userView.mas_centerY);
        make.left.equalTo(codeMidLine.mas_left).with.offset(5);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    
    [_passwordText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_userView.mas_centerY);
        make.left.equalTo(passwordIcon.mas_right).with.offset(5);
        make.right.equalTo(_userView.mas_right).with.offset(5);
        make.height.equalTo(@20);
    }];
}
//地理位置
-(void)initLocationView
{
    _locationView = [UIView new];
    [_containView addSubview:_locationView];
    [_locationView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_userView.mas_bottom).with.offset(0);
        make.left.equalTo(_containView.mas_left).with.offset(0);
        make.right.equalTo(_containView.mas_right).with.offset(0);
        make.height.mas_equalTo(@30);
    }];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [_locationView addSubview:codeBottomLine];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_locationView.mas_bottom).with.offset(0);
        make.left.equalTo(_locationView.mas_left).with.offset(0);
        make.right.equalTo(_locationView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    UILabel *locationIcon = [UILabel new];
    [locationIcon setFont:[UIFont fontWithName:@"FontAwesome" size:12]];
    locationIcon.text = @"";
    locationIcon.textColor = [UIColor nameColor];
    [_codeView addSubview:locationIcon];
    
    _locationText = [UILabel new];
    _locationText.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    _locationText.text = @"12305";
    _locationText.textColor = [UIColor blackColor];
    [_locationView addSubview:_locationText];
    
    [locationIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_locationView.mas_centerY);
        make.left.equalTo(_locationView.mas_left).with.offset(5);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    
    [_locationText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_locationView.mas_centerY);
        make.left.equalTo(locationIcon.mas_right).with.offset(5);
        make.right.equalTo(_locationView.mas_right).with.offset(5);
        make.height.equalTo(@20);
    }];
    
    
}
//类型状态
-(void)initTypeView
{
    _typeView = [UIView new];
    [_containView addSubview:_typeView];
    [_typeView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_locationView.mas_bottom).with.offset(0);
        make.left.equalTo(_containView.mas_left).with.offset(0);
        make.right.equalTo(_containView.mas_right).with.offset(0);
        make.height.mas_equalTo(@30);
    }];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [_typeView addSubview:codeBottomLine];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_typeView.mas_bottom).with.offset(0);
        make.left.equalTo(_typeView.mas_left).with.offset(0);
        make.right.equalTo(_typeView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    UIView *codeMidLine = [UIView new];
    codeMidLine.backgroundColor = [UIColor grayColor];
    [_typeView addSubview:codeMidLine];
    [codeMidLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_typeView.mas_bottom).with.offset(0);
        make.top.equalTo(_typeView.mas_top).with.offset(0);
        make.centerX.equalTo(_typeView.mas_centerX).with.offset(0);
        make.width.mas_equalTo(@1);
    }];
    
    UILabel *typeTitle = [UILabel new];
    typeTitle.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    typeTitle.text = @"类型";
    typeTitle.textColor = [UIColor nameColor];
    [_typeView addSubview:typeTitle];
    
    _typeText = [UILabel new];
    _typeText.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    _typeText.text = @"12305";
    _typeText.textColor = [UIColor blackColor];
    [_typeView addSubview:_typeText];
    
    [typeTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_typeView.mas_centerY);
        make.left.equalTo(_typeView.mas_left).with.offset(5);
        make.width.equalTo(@30);
        make.height.equalTo(@20);
    }];
    
    
    [_typeText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_typeView.mas_centerY);
        make.left.equalTo(typeTitle.mas_right).with.offset(5);
        make.right.equalTo(_typeView.mas_right).with.offset(5);
        make.height.equalTo(@20);
    }];
    
    UILabel *statusTitle = [UILabel new];
    statusTitle.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    statusTitle.text = @"状态";
    statusTitle.textColor = [UIColor nameColor];
    [_userView addSubview:statusTitle];
    
    _statusText = [UILabel new];
    _statusText.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    _statusText.text = @"12305";
    _statusText.textColor = [UIColor blackColor];
    [_typeView addSubview:_statusText];
    
    [statusTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_typeView.mas_centerY);
        make.left.equalTo(codeMidLine.mas_left).with.offset(5);
        make.width.equalTo(@30);
        make.height.equalTo(@20);
    }];
    
    
    [_statusText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_typeView.mas_centerY);
        make.left.equalTo(statusTitle.mas_right).with.offset(5);
        make.right.equalTo(_typeView.mas_right).with.offset(5);
        make.height.equalTo(@20);
    }];
}

//预约时间
-(void)initAppointmentTimeView
{
    _appointmentTimeView = [UIView new];
    [_containView addSubview:_appointmentTimeView];
    [_appointmentTimeView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_typeView.mas_bottom).with.offset(0);
        make.left.equalTo(_containView.mas_left).with.offset(0);
        make.right.equalTo(_containView.mas_right).with.offset(0);
        make.height.mas_equalTo(@30);
    }];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [_appointmentTimeView addSubview:codeBottomLine];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_appointmentTimeView.mas_bottom).with.offset(0);
        make.left.equalTo(_appointmentTimeView.mas_left).with.offset(0);
        make.right.equalTo(_appointmentTimeView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    UILabel *appointmentTitle = [UILabel new];
    appointmentTitle.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    appointmentTitle.text = @"预约时间";
    appointmentTitle.textColor = [UIColor nameColor];
    [_appointmentTimeView addSubview:appointmentTitle];
    
    _appointmentTimeText = [UILabel new];
    _appointmentTimeText.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    _appointmentTimeText.text = @"12305";
    _appointmentTimeText.textColor = [UIColor blackColor];
    [_appointmentTimeView addSubview:_appointmentTimeText];
    
    [appointmentTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_appointmentTimeView.mas_centerY);
        make.left.equalTo(_appointmentTimeView.mas_left).with.offset(5);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    
    
    [_appointmentTimeText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_appointmentTimeView.mas_centerY);
        make.left.equalTo(appointmentTitle.mas_right).with.offset(5);
        make.right.equalTo(_appointmentTimeView.mas_right).with.offset(5);
        make.height.equalTo(@20);
    }];
}

//服务项目
-(void)initServiceView
{
    _serviceView = [UIView new];
    [_containView addSubview:_serviceView];
    [_serviceView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_appointmentTimeView.mas_bottom).with.offset(0);
        make.left.equalTo(_containView.mas_left).with.offset(0);
        make.right.equalTo(_containView.mas_right).with.offset(0);
        make.height.mas_equalTo(@30);
    }];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [_serviceView addSubview:codeBottomLine];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_serviceView.mas_bottom).with.offset(0);
        make.left.equalTo(_serviceView.mas_left).with.offset(0);
        make.right.equalTo(_serviceView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    UILabel *serviceTitle = [UILabel new];
    serviceTitle.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    serviceTitle.text = @"服务项目";
    serviceTitle.textColor = [UIColor nameColor];
    [_serviceView addSubview:serviceTitle];
    
    _serviceText = [UILabel new];
    _serviceText.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    _serviceText.text = @"12305";
    _serviceText.textColor = [UIColor blackColor];
    [_serviceView addSubview:_serviceText];
    
    [serviceTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_serviceView.mas_centerY);
        make.left.equalTo(_serviceView.mas_left).with.offset(5);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    
    
    [_serviceText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_serviceView.mas_centerY);
        make.left.equalTo(serviceTitle.mas_right).with.offset(5);
        make.right.equalTo(_serviceView.mas_right).with.offset(5);
        make.height.equalTo(@20);
    }];
}
//客户留言
-(void)initRemarkView
{
    _remarkView = [UIView new];
    [_containView addSubview:_remarkView];
    [_remarkView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_serviceView.mas_bottom).with.offset(0);
        make.left.equalTo(_containView.mas_left).with.offset(0);
        make.right.equalTo(_containView.mas_right).with.offset(0);
        make.height.mas_equalTo(@30);
    }];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [_remarkView addSubview:codeBottomLine];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_remarkView.mas_bottom).with.offset(0);
        make.left.equalTo(_remarkView.mas_left).with.offset(0);
        make.right.equalTo(_remarkView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    UILabel *remarkTitle = [UILabel new];
    remarkTitle.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    remarkTitle.text = @"客户留言";
    remarkTitle.textColor = [UIColor nameColor];
    [_remarkView addSubview:remarkTitle];
    
    _remarkText = [UILabel new];
    _remarkText.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    _remarkText.text = @"12305";
    _remarkText.textColor = [UIColor blackColor];
    [_remarkView addSubview:_remarkText];
    
    [remarkTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_remarkView.mas_centerY);
        make.left.equalTo(_remarkView.mas_left).with.offset(5);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    
    
    [_remarkText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_remarkView.mas_centerY);
        make.left.equalTo(remarkTitle.mas_right).with.offset(5);
        make.right.equalTo(_remarkView.mas_right).with.offset(5);
        make.height.equalTo(@20);
    }];
}

//开始按钮
-(void)initStarBtn
{
    _starBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_containView addSubview:_starBtn];
    _starBtn.layer.masksToBounds = YES;
    _starBtn.backgroundColor = [UIColor nameColor];
    _starBtn.layer.cornerRadius = 40;
    [_starBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _starBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [_starBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_remarkView.mas_bottom).with.offset(50);
        make.centerX.equalTo(_containView.mas_centerX);
        make.height.mas_equalTo(@80);
        make.width.mas_equalTo(@80);
    }];
    
}

-(void)setWorkOrder:(WorkOrder *)workOrder
{
    switch (workOrder.type) {
        case WorkOrderTypeOnsite:
            [self initOnsiteBottomView];
            break;
        case WorkOrderTypeService:
            [self initServiceBottomView];
            break;
            
        case WorkOrderTypeInventory:
            [self initInventoryBottomView];
            break;
        default:
            break;
    }
    
}

-(void)initOnsiteBottomView
{
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
    
    _inventoryBtn = [UILabel new];
    [_inventoryBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _inventoryBtn.text = @"";
    _inventoryBtn.textAlignment = NSTextAlignmentCenter;
    _inventoryBtn.textColor = [UIColor nameColor];
    [bottomView addSubview:_inventoryBtn];
    
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
        make.height.mas_equalTo(@1);
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
    
    [_inventoryBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_qrCodeBtn);
        make.left.equalTo(_qrCodeBtn.mas_right);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    
    [saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_saveBtn.mas_bottom);
        make.centerX.equalTo(_saveBtn.mas_centerX);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_qrCodeBtn);
        make.left.equalTo(_inventoryBtn.mas_right);
        make.right.equalTo(bottomView);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    [inventoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inventoryBtn.mas_bottom);
        make.centerX.equalTo(_inventoryBtn.mas_centerX);
    }];
    
}


-(void)initServiceBottomView
{
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
        make.height.mas_equalTo(@1);
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


-(void)initInventoryBottomView
{
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:codeBottomLine];
    
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
    
    _inventoryBtn = [UILabel new];
    [_inventoryBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _inventoryBtn.text = @"";
    _inventoryBtn.textAlignment = NSTextAlignmentCenter;
    _inventoryBtn.textColor = [UIColor nameColor];
    [bottomView addSubview:_inventoryBtn];
    
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
        make.height.mas_equalTo(@1);
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
    
    [_inventoryBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_formBtn);
        make.left.equalTo(_formBtn.mas_right);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    
    [saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_saveBtn.mas_bottom);
        make.centerX.equalTo(_saveBtn.mas_centerX);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_formBtn);
        make.left.equalTo(_inventoryBtn.mas_right);
        make.right.equalTo(bottomView);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    [inventoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inventoryBtn.mas_bottom);
        make.centerX.equalTo(_inventoryBtn.mas_centerX);
    }];
    
}

@end
