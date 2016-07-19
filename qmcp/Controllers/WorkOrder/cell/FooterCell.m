//
//  FooterCell.m
//  qmcp
//
//  Created by 谢永明 on 16/7/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "FooterCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"

@implementation FooterCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"FooterCell";
    FooterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[FooterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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

-(void)initView{
    _containView = [UIView new];
    _containView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_containView];
    
    _name = [UILabel new];
    _name.font = [UIFont systemFontOfSize:16];
    _name.textColor = [UIColor blackColor];
    _name.text = @"添加明细";
    [_containView addSubview:_name];
    
    _icon = [UILabel new];
    [_icon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    _icon.text = @"";
    _icon.textColor = [UIColor nameColor];
    [_containView addSubview:_icon];
    
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_containView.mas_centerY);
        make.centerX.equalTo(_containView.mas_centerX).with.offset(10);
    }];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_containView.mas_centerY);
        make.right.equalTo(_name.mas_left).with.offset(-5);
    }];
   
}


@end
