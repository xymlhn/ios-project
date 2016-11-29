//
//  WorkOrderCameraCell.m
//  qmcp
//
//  Created by 谢永明 on 16/5/14.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderCameraCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "MJExtension.h"
#import "EnumUtil.h"
#import "CameraData.h"
#import "PchHeader.h"

@implementation WorkOrderCameraCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"gb";
    WorkOrderCameraCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[WorkOrderCameraCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
    
    _cameraIcon = [UILabel new];
    [_cameraIcon setFont:[UIFont fontWithName:@"FontAwesome" size:25]];
    _cameraIcon.text = @"";
    _cameraIcon.textColor = [UIColor nameColor];
    [self.contentView addSubview:_cameraIcon];
    
    _name = [UILabel new];
    _name.font = [UIFont systemFontOfSize:kShiwupt];
    _name.text = @"12305";
    _name.textColor = [UIColor blackColor];
    [self.contentView addSubview:_name];
    
    _switchBtn = [UIButton new];
    _switchBtn.backgroundColor = [UIColor appBlueColor];
    [_switchBtn setTitle:@"开启" forState:UIControlStateNormal];
    _switchBtn.tintColor = [UIColor whiteColor];
    [_switchBtn.layer setMasksToBounds:YES];
    [_switchBtn.layer setCornerRadius:kBottomButtonCorner];
    _switchBtn.titleLabel.font = [UIFont systemFontOfSize:kShisipt];
    [self.contentView addSubview:_switchBtn];
    
    [_cameraIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(_cameraIcon.mas_right).with.offset(25);
    }];

    [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_name.mas_centerY);
        make.width.equalTo(@73);
        make.height.equalTo(@33);
        make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
}

//重写属性的setter方法，给子控件赋值
- (void)setCameraData:(CameraData *)cameraData
{
    if(cameraData != nil){
        _name.text = cameraData.cameraLocation;
        [_switchBtn setTitle:@"开启" forState:UIControlStateNormal];
        _cameraIcon.text = @"";
    }
}
@end
