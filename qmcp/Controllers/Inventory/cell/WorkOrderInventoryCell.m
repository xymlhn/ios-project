//
//  WorkOrderInventoryCell.m
//  qmcp
//
//  Created by 谢永明 on 16/4/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderInventoryCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"
@interface WorkOrderInventoryCell()


@end

@implementation WorkOrderInventoryCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"WorkOrderInventoryCell";
    WorkOrderInventoryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[WorkOrderInventoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.contentView.mas_left).with.offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
}

-(void)setItemSnapshot:(ItemSnapshot *)itemSnapshot
{
    _titleLabel.text = [NSString stringWithFormat:@"二维码: %@",itemSnapshot.code];
}

@end
