//
//  SettingViewCell.m
//  qmcp
//
//  Created by 谢永明 on 16/4/10.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SettingViewCell.h"
#import "PchHeader.h"

@implementation SettingViewCell

-(void)initSetting:(BOOL)on andText:(NSString *)content
{
    _jsSwitch.on = on;
    _jsText.text = content;
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
    _jsText = [UILabel new];
    _jsText.font = [UIFont systemFontOfSize:12];//
    _jsText.text = @"12305";
    _jsText.textColor = [UIColor blackColor];
    [self.contentView addSubview:_jsText];
    [_jsText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    _jsSwitch = [UISwitch new];
    [self.contentView addSubview:_jsSwitch];
    [_jsSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
}

@end
