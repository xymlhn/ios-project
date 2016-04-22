//
//  WorkOrderListTableViewCell.m
//  qmcp
//
//  Created by 谢永明 on 16/3/25.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderListCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "WorkOrder.h"
#import "Utils.h"
#import "ReactiveCocoa.h"
#import "WorkOrderInfoController.h"
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
@interface WorkOrderListCell ()

@property(nonatomic,strong)UILabel *timeText;
@property(nonatomic,strong)UILabel *codeText;
@property(nonatomic,strong)UILabel *typeText;
@property(nonatomic,strong)UILabel *cameraTitle;
@property(nonatomic,strong)UILabel *quickTitle;

@end

@implementation WorkOrderListCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"gb";
    WorkOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[WorkOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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

//重写属性的setter方法，给子控件赋值
- (void)setWorkOrder:(WorkOrder *)workOrder
{
    if(workOrder != nil){
        _codeText.text = workOrder.code;
        _timeText.text = workOrder.salesOrderSnapshot.appointmentTime;
        switch (workOrder.type) {
            case WorkOrderTypeOnsite:
                _typeText.text = @"上门";
                break;
            case WorkOrderTypeInventory:
                _typeText.text = @"清点";
                break;
            case WorkOrderTypeService:
                _typeText.text = @"服务";
                break;
            default:
                break;
        }
    }
}


-(void)initView{
   
    _topView = [UIView new];
    [self.contentView addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contentView.mas_top).with.offset(8);
        make.left.equalTo(self.contentView.mas_left).with.offset(5);
        make.right.equalTo(self.contentView.mas_right).with.offset(5);
        make.height.mas_equalTo(@28);
    }];
    
    _typeText = [UILabel new];
    _typeText.numberOfLines = 0;
    _typeText.lineBreakMode = NSLineBreakByWordWrapping;
    _typeText.font = [UIFont boldSystemFontOfSize:15];
    _typeText.text = @"上门";
    [_topView addSubview:_typeText];
    
    UILabel *topIcon = [UILabel new];
    [topIcon setFont:[UIFont fontWithName:@"FontAwesome" size:25]];
    topIcon.text = @"";
    topIcon.textColor = [UIColor grayColor];
    [_topView addSubview:topIcon];

    [_typeText mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_topView.mas_left).with.offset(5);
        make.centerY.equalTo(_topView.mas_centerY);

    }];
    [topIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_topView.mas_centerY);
        make.left.equalTo(_typeText.mas_right).with.offset(10);
    }];
    
    _middleView = [UIView new];
  
    [self.contentView addSubview:_middleView];
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_topView.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(5);
        make.right.equalTo(self.contentView.mas_right).with.offset(5);
        make.height.mas_equalTo(@60);
    }];
    UIView *topLine = [UILabel new];
    topLine.backgroundColor = [UIColor grayColor];
    [_middleView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_middleView.mas_top).with.offset(0);
        make.left.equalTo(_middleView.mas_left).with.offset(0);
        make.right.equalTo(_middleView.mas_right).with.offset(0);
        make.height.mas_equalTo(SINGLE_LINE_WIDTH);
    }];
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = [UIColor grayColor];
    [_middleView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_middleView.mas_bottom).with.offset(0);
        make.left.equalTo(_middleView.mas_left).with.offset(0);
        make.right.equalTo(_middleView.mas_right).with.offset(0);
        make.height.mas_equalTo(SINGLE_LINE_WIDTH);
    }];
    

    
    _codeText = [UILabel new];
    _codeText.font = [UIFont systemFontOfSize:13];//采用系统默认文字设置大小
    _codeText.text = @"10010";
    _codeText.textColor = [UIColor titleColor];
    [_middleView addSubview:_codeText];
    [_codeText mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_middleView.mas_left).with.offset(5);
        make.bottom.equalTo(_middleView.mas_centerY);
        make.width.mas_equalTo(@100);
    }];
    
    _timeText = [UILabel new];
    _timeText.font = [UIFont systemFontOfSize:8];//采用系统默认文字设置大小
    _timeText.text = @"2012/12/23";
    _timeText.textColor = [UIColor nameColor];
    [_middleView addSubview:_timeText];
    [_timeText mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_middleView.mas_left).with.offset(5);
        make.top.equalTo(_middleView.mas_centerY).with.offset(5);
        make.width.mas_equalTo(@100);
    }];
    
    
    _bottomView = [UIView new];
    [self.contentView addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(5);
        make.right.equalTo(self.contentView.mas_right).with.offset(5);
        make.top.equalTo(_middleView.mas_bottom);
    }];
    
    
    UIView *middleLine = [UIView new];
    middleLine.backgroundColor = [UIColor grayColor];
    [_bottomView addSubview:middleLine];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(_bottomView.mas_centerX);
        make.bottom.equalTo(_bottomView.mas_bottom).with.offset(0);
        make.top.equalTo(_bottomView.mas_top).with.offset(0);
        make.width.mas_equalTo(SINGLE_LINE_WIDTH);
    }];
    
    UILabel *cameraText = [UILabel new];
    cameraText.font = [UIFont systemFontOfSize:8];//采用系统默认文字设置大小
    cameraText.text = @"摄像头";
    cameraText.textColor = [UIColor blackColor];
    cameraText.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:cameraText];
    [cameraText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_bottomView.mas_centerY);
        make.left.equalTo(_bottomView.mas_centerX);
        make.right.equalTo(_bottomView.mas_right);
    }];
    
    UIView *separateView = [UIView new];
    separateView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:separateView];
    [separateView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_bottomView.mas_bottom).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.height.mas_equalTo(SINGLE_LINE_WIDTH);
    }];
    
}
@end
