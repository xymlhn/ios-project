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
@property(nonatomic,strong)UILabel *codeText;
@property(nonatomic,strong)UILabel *commodityNameText;
@property(nonatomic,strong)UILabel *nameText;
@property(nonatomic,strong)UILabel *phoneText;
@property(nonatomic,strong)UIButton *grabBtn;

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
    static int border = 10;
    _typeImage = [UIImageView new];
    [self.contentView addSubview:_typeImage];
    
    _commodityNameText = [UILabel new];
    _commodityNameText.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_commodityNameText];
    
    _codeText = [UILabel new];
    _codeText.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_codeText];
    
    _nameText = [UILabel new];
    _nameText.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_nameText];
    
    _phoneText = [UILabel new];
    _phoneText.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_phoneText];
    
    UILabel *userIcon = [UILabel new];
    [userIcon setFont:[UIFont fontWithName:@"FontAwesome" size:15]];
    userIcon.text = @"";
    userIcon.textColor = [UIColor nameColor];
    [self.contentView addSubview:userIcon];
    
    UILabel *phoneIcon = [UILabel new];
    [phoneIcon setFont:[UIFont fontWithName:@"FontAwesome" size:17]];
    phoneIcon.text = @"";
    phoneIcon.textColor = [UIColor nameColor];
    [self.contentView addSubview:phoneIcon];
    
    [_typeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@60);
        make.height.equalTo(@60);
        make.left.equalTo(self.contentView.mas_left).with.offset(border);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [_codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeImage.mas_right).with.offset(border);
        make.top.equalTo(_typeImage.mas_top);
    }];
    
    [_commodityNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeImage.mas_right).with.offset(border);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_typeImage.mas_right).with.offset(border);
        make.bottom.equalTo(_typeImage.mas_bottom);
    }];
    
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userIcon.mas_right).with.offset(5);
        make.centerY.equalTo(userIcon.mas_centerY);
    }];
    
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameText.mas_right).with.offset(border);
        make.centerY.equalTo(userIcon.mas_centerY);
    }];
    
    [_phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneIcon.mas_right).with.offset(5);
        make.centerY.equalTo(phoneIcon.mas_centerY);
    }];

}

//重写属性的setter方法，给子控件赋值
- (void)setWorkOrder:(WorkOrder *)workOrder
{
    if(workOrder != nil){
        _codeText.text = workOrder.code;
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
            _commodityNameText.text = [workOrder.salesOrderSnapshot.commodityNames componentsJoinedByString:@","];;
            _codeText.text = workOrder.code;
            if(workOrder.salesOrderSnapshot.addressSnapshot != nil){
                _nameText.text = workOrder.salesOrderSnapshot.addressSnapshot.contacts;
                _phoneText.text = workOrder.salesOrderSnapshot.addressSnapshot.mobilePhone;
            }
        }
    }
}

@end
