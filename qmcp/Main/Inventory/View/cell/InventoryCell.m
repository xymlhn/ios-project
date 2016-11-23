//
//  WorkOrderInventoryCell.m
//  qmcp
//
//  Created by 谢永明 on 16/4/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "InventoryCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "PchHeader.h"
#import "Utils.h"
#import "Attachment.h"
@interface InventoryCell()


@end

@implementation InventoryCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"InventoryCell";
    InventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[InventoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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

-(void)initView
{
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:13];//采用系统默认文字设置大小
    _titleLabel.textColor = [UIColor titleColor];
    [self.contentView addSubview:_titleLabel];
    
    _headImage = [UIImageView new];
    [self.contentView addSubview:_headImage];
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeftWidth);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@50);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_headImage.mas_right).with.offset(kPaddingLeftWidth);
        make.top.equalTo(_headImage.mas_top);
    }];
    
}

-(void)setItemSnapshot:(ItemSnapshot *)itemSnapshot
{
    _titleLabel.text = [NSString stringWithFormat:@"二维码: %@",itemSnapshot.code];
    Attachment *attachment = itemSnapshot.attachments[0];
    _headImage.image = [Utils loadImage:attachment.key];
}

@end
