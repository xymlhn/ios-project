//
//  SettingViewCell.m
//  qmcp
//
//  Created by 谢永明 on 16/4/10.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SettingViewCell.h"
#import "PchHeader.h"
#import "UIColor+Util.h"

@implementation SettingViewCell

-(void)initSetting:(BOOL)on contentText:(NSString *)content icon:(NSString *)image
{
    _jsSwitch.on = on;
    _jsText.text = content;
    _iconView.text = image;
}
//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"SettingViewCell";
    SettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[SettingViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
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

-(void)initView
{
    
    _iconView = [UILabel new];
    [_iconView setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    _iconView.text = @"";
    _iconView.textColor = [UIColor blackColor];
    _iconView.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_iconView];
    
    _jsText = [UILabel new];
    _jsText.font = [UIFont systemFontOfSize:14];
    _jsText.text = @"12305";
    _jsText.textColor = [UIColor blackColor];
    [self.contentView addSubview:_jsText];
    
    _jsSwitch = [UISwitch new];
    [self.contentView addSubview:_jsSwitch];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.width.equalTo(@30);
        make.left.equalTo(self.contentView.mas_left).with.offset(5);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [_jsText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(_iconView.mas_right).with.offset(5);
    }];
    [_jsSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
}

@end
