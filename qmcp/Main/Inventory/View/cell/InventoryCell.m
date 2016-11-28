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
    _titleLabel.font = [UIFont systemFontOfSize:kShisipt];
    _titleLabel.textColor = [UIColor secondTextColor];
    [self.contentView addSubview:_titleLabel];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:kShisipt];
    _nameLabel.textColor = [UIColor secondTextColor];
    [self.contentView addSubview:_nameLabel];
    
    _remarkLabel = [UILabel new];
    _remarkLabel.font = [UIFont systemFontOfSize:kShisipt];
    _remarkLabel.textColor = [UIColor secondTextColor];
    [self.contentView addSubview:_remarkLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.font = [UIFont systemFontOfSize:kShisipt];
    _priceLabel.textColor = [UIColor appRedColor];
    [self.contentView addSubview:_priceLabel];
    
    _headImage = [UIImageView new];
    [self.contentView addSubview:_headImage];
    
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contentView.mas_top).with.offset(15);
        make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeftWidth);
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(56);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_headImage.mas_right).with.offset(kPaddingLeftWidth);
        make.top.equalTo(_headImage.mas_top);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_titleLabel.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeftWidth);
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(5);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_titleLabel.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeftWidth);
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(5);
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_titleLabel.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeftWidth);
        make.top.equalTo(_remarkLabel.mas_bottom).with.offset(5);
    }];
    
}

-(void)setItemSnapshot:(ItemSnapshot *)itemSnapshot
{
    _titleLabel.text = [NSString stringWithFormat:@"二维码: %@",itemSnapshot.code];
    _nameLabel.text = [NSString stringWithFormat:@"名    称: %@",itemSnapshot.name];
    _remarkLabel.text = [NSString stringWithFormat:@"备    注: %@",itemSnapshot.remark?itemSnapshot.remark : @""];
    _priceLabel.text = [NSString stringWithFormat:@"总    价:¥ %@",@"0"];
    Attachment *attachment = itemSnapshot.attachments[0];
    _headImage.image = [Utils loadImage:attachment.key];
}

@end
