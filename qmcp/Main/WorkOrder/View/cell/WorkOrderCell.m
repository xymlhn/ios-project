//
//  WorkOrderCell.m
//  qmcp
//
//  Created by 谢永明 on 16/6/20.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"
@interface WorkOrderCell ()

@property(nonatomic,strong)UIImageView *typeImage;
@property(nonatomic,strong)UILabel *codeTitle;
@property(nonatomic,strong)UILabel *codeValue;
@property(nonatomic,strong)UILabel *appointmentTimeTitle;
@property(nonatomic,strong)UILabel *appointmentTimeValue;
@property(nonatomic,strong)UILabel *contactText;
@property(nonatomic,strong)UILabel *progressText;
@property(nonatomic,strong)UIButton *cameraBtn;

@end
@implementation WorkOrderCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"WorkOrderCell";
    WorkOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[WorkOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.selectedBackgroundView.backgroundColor = [UIColor themeColor];
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}


-(void)initView{
    _typeImage = [UIImageView new];
    [self.contentView addSubview:_typeImage];
    
    _codeTitle = [UILabel new];
    _codeTitle.font = [UIFont systemFontOfSize:kShisanpt];
    _codeTitle.text = @"工单编号 ";
    _codeTitle.textColor = [UIColor arrowColor];
    [self addSubview:_codeTitle];
    
    _codeValue = [UILabel new];
    _codeValue.font = [UIFont systemFontOfSize:kShisanpt];
    _codeValue.text = @"";
    _codeValue.textColor = [UIColor secondTextColor];
    [self.contentView addSubview:_codeValue];
    
    _appointmentTimeTitle = [UILabel new];
    _appointmentTimeTitle.font = [UIFont systemFontOfSize:kShisanpt];
    _appointmentTimeTitle.text = @"预约时间 ";
    _appointmentTimeTitle.textColor = [UIColor arrowColor];
    [self addSubview:_appointmentTimeTitle];
    
    _appointmentTimeValue = [UILabel new];
    _appointmentTimeValue.font = [UIFont systemFontOfSize:kShisanpt];
    _appointmentTimeValue.text = @"";
    _appointmentTimeValue.textColor = [UIColor secondTextColor];
    [self.contentView addSubview:_appointmentTimeValue];
    
    _contactText = [UILabel new];
    _contactText.font = [UIFont systemFontOfSize:kShisanpt];
    _contactText.text = @"";
    _contactText.textColor = [UIColor mainTextColor];
    [self.contentView addSubview:_contactText];
    
    
    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeftWidth);
        make.top.equalTo(self.contentView.mas_top).with.offset(kPaddingTopWidth);
    }];
    
    [_codeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeImage.mas_right).with.offset(kPaddingLeftWidth);
        make.top.equalTo(_typeImage.mas_top);
    }];
    
    [_codeValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_codeTitle.mas_right).with.offset(0);
        make.top.equalTo(_codeTitle.mas_top);
    }];

    [_appointmentTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeImage.mas_right).with.offset(kPaddingLeftWidth);
        make.top.equalTo(_codeTitle.mas_bottom);
    }];
    
    [_appointmentTimeValue mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_appointmentTimeTitle.mas_right).with.offset(0);
        make.top.equalTo(_appointmentTimeTitle.mas_top);
    }];
    
    [_contactText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_appointmentTimeTitle.mas_bottom).with.offset(kPaddingLeftWidth);
        make.left.equalTo(_appointmentTimeTitle.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
}

//重写属性的setter方法，给子控件赋值
- (void)setWorkOrder:(WorkOrder *)workOrder
{
    if(workOrder != nil){
        _codeValue.text = workOrder.code;
        
        switch (workOrder.type) {
            case WorkOrderTypeOnsite:
                _typeImage.image = [UIImage imageNamed:@"type_shangmen"];
                break;
            case WorkOrderTypeService:
                _typeImage.image = [UIImage imageNamed:@"type_daodian"];
                break;
            default:
                break;
        }
        
        if(workOrder.salesOrderSnapshot != nil){
            _appointmentTimeValue.text = workOrder.salesOrderSnapshot.appointmentTime;
            AddressSnapshot *address =workOrder.salesOrderSnapshot.addressSnapshot;
            if(address != nil){
                _contactText.text = [NSString stringWithFormat:@"%@     %@\n%@",address.contacts,address.mobilePhone,address.fullAddress];
            }
        }
    }
}

@end
