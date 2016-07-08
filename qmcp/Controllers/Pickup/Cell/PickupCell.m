//
//  PickupCell.m
//  qmcp
//
//  Created by 谢永明 on 16/7/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "PickupCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "EnumUtil.h"

@implementation PickupCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"PickupCell";
    PickupCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[PickupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
- (void)setPickupItem:(PickupItem *)pickupItem
{
    _pickupItem = pickupItem;
    _nameText.text = pickupItem.name;
    _statusText.text = [EnumUtil pickupStatusString:pickupItem.pickupStatus];
    _chooseSwitch.hidden = pickupItem.pickupStatus != PickupStatusWaitToPickup;
    [_chooseSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    _pickupItem.isChoose = [switchButton isOn];
}

-(void)initView{
    _nameText = [UILabel new];
    _nameText.textColor = [UIColor blackColor];
    _nameText.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    [self.contentView addSubview:_nameText];
    
    _statusText = [UILabel new];
    _statusText.textColor = [UIColor blackColor];
    _statusText.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    [self.contentView addSubview:_statusText];
    
    _icon = [UIImageView new];
    [_icon setImage:[UIImage imageNamed:@"default－portrait.png"]];
    [self.contentView addSubview:_icon];
    
    _chooseSwitch = [UISwitch new];
    [self.contentView addSubview:_chooseSwitch];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_icon.mas_right).with.offset(10);
        make.right.equalTo(_chooseSwitch.mas_left).with.offset(0);
        make.top.equalTo(_icon.mas_top);
    }];
    
    [_statusText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_icon.mas_right).with.offset(10);
        make.right.equalTo(_chooseSwitch.mas_left).with.offset(0);
        make.bottom.equalTo(_icon.mas_bottom);
    }];
    
    [_chooseSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
}
@end
