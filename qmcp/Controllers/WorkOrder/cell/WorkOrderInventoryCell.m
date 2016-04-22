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

@property (nonatomic, strong) UIView *containView;

@end

@implementation WorkOrderInventoryCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"gb";
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
    _containView = [UIView new];
    [self.contentView addSubview:_containView];
    [_containView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(5);
        make.right.equalTo(self.contentView.mas_right).with.offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(5);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:13];//采用系统默认文字设置大小
    _titleLabel.textColor = [UIColor titleColor];
    [_containView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_containView.mas_left).with.offset(5);
        make.centerY.equalTo(_containView.mas_centerY);
    }];
    
}

-(void)setItemSnapshot:(ItemSnapshot *)itemSnapshot
{
    _titleLabel.text = [NSString stringWithFormat:@"二维码: %@",itemSnapshot.code];
}

@end
