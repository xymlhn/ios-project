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
    _contentLabel.font = [UIFont systemFontOfSize:20];
    _contentLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:_contentLabel];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
}

-(void)setCommoditySnapshot:(CommoditySnapshot *)commoditySnapshot{
    _contentLabel.text = commoditySnapshot.commodityName;
}

@end
