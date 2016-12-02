//
//  InventoryChooseCell.m
//  qmcp
//
//  Created by 谢永明 on 16/8/29.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "InventoryChooseCell.h"
#import "UIColor+Util.h"
#import "PchHeader.h"
#import "Masonry.h"

@implementation InventoryChooseCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"InventoryChooseCell";
    InventoryChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[InventoryChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:kShisipt];
    _contentLabel.textColor = [UIColor mainTextColor];
    [self.contentView addSubview:_contentLabel];
    
    UILabel *arrow = [UILabel new];
    [arrow setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    arrow.text = @"";
    arrow.textAlignment = NSTextAlignmentCenter;
    arrow.textColor = [UIColor appBlueColor];
    [self.contentView addSubview:arrow];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.contentView.mas_right).with.offset(-20);
    }];
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
}

-(void)setCommoditySnapshot:(CommoditySnapshot *)commoditySnapshot{
    _contentLabel.text = commoditySnapshot.commodityName;
}

@end
