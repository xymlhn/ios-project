//
//  WorkOrderStepCell.m
//  qmcp
//
//  Created by 谢永明 on 16/3/30.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderStepCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "PchHeader.h"
@interface WorkOrderStepCell()
@property(nonatomic, strong) UILabel *userNamaLabel;
@property (nonatomic,strong)UIImageView *image;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@end
@implementation WorkOrderStepCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"gb";
    
    WorkOrderStepCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[WorkOrderStepCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
- (void)setWorkOrderStep:(WorkOrderStep *)workOrderStep
{
    if(workOrderStep != nil){
        _userNamaLabel.text = workOrderStep.submitUser;
        _contentLabel.text = workOrderStep.content;
        _timeLabel.text = workOrderStep.submitTime;
    }

}

-(void)initView
{
    _image = [UIImageView new];
    [_image setImage:[UIImage imageNamed:@"default－portrait"]];
    [self.contentView addSubview:_image];
    [_image mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contentView.mas_top).with.offset(kPaddingTopWidth);
        make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    _userNamaLabel = [UILabel new];
    _userNamaLabel.font = [UIFont systemFontOfSize:kShierpt];
    _userNamaLabel.textColor = [UIColor appBlueColor];
    [self.contentView addSubview:_userNamaLabel];
    
    [_userNamaLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_image.mas_top).with.offset(0);
        make.left.equalTo(_image.mas_right).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];

    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:kShisipt];
    _contentLabel.textColor = [UIColor secondTextColor];
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_userNamaLabel.mas_bottom).with.offset(5);
        make.left.equalTo(_image.mas_right).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:kShierpt];
    _timeLabel.textColor = [UIColor arrowColor];
    [self.contentView addSubview:_timeLabel];

    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.left.equalTo(_image.mas_right).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];
}
@end
