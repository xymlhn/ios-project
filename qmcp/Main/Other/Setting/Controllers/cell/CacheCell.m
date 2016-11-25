//
//  CacheCell.m
//  qmcp
//
//  Created by 谢永明 on 16/8/17.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "CacheCell.h"
#import "PchHeader.h"
#import "UIColor+Util.h"
@implementation CacheCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"CacheCell";
    CacheCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[CacheCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.text = @"清除缓存";
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
    
    _fontIcon = [UILabel new];
    [_fontIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    _fontIcon.text = @"";
    _fontIcon.textColor = [UIColor blackColor];
    [self.contentView addSubview:_fontIcon];
    
    _sizeLabel = [UILabel new];
    _sizeLabel.font = [UIFont systemFontOfSize:14];
    _sizeLabel.text = @"";
    _sizeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_sizeLabel];
    
    UILabel *arrow = [UILabel new];
    [arrow setFont:[UIFont fontWithName:@"FontAwesome" size:kFontAwesomeArrow]];
    arrow.text = @"";
    arrow.textAlignment = NSTextAlignmentCenter;
    arrow.textColor = [UIColor arrowColor];
    [self.contentView addSubview:arrow];
    
    [_fontIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(@30);
        make.width.equalTo(@30);
        make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeftWidth);
        make.centerY.equalTo(self.contentView.mas_centerY);

    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(_fontIcon.mas_right).with.offset(5);
    }];
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
    
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(arrow.mas_left).with.offset(0);
        make.width.equalTo(@50);
    }];
    
}

-(void)setCacheSize:(NSString *)size{
    _sizeLabel.text = size;
}

@end
