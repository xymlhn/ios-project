//
//  SideMenuControllerTableViewCell.m
//  qmcp
//
//  Created by 谢永明 on 16/3/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SideMenuCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "PchHeader.h"
@interface SideMenuCell()
@property (strong, nonatomic)  UILabel *icon;
@property (strong, nonatomic)  UILabel *content;
@end
@implementation SideMenuCell

//创建自定义可重用的cell对象
+ (instancetype)SideMenuCellWithTableView:(UITableView *)tableView{
    static NSString *reuseId = @"gb";
    SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[SideMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    _icon = [UILabel new];
    [_icon setFont:[UIFont fontWithName:@"FontAwesome" size:23]];
    _icon.text = @"";
    _icon.textColor = [UIColor grayColor];
    [self.contentView addSubview:_icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@25);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
    }];
    
    _content = [UILabel new];
    _content.font = [UIFont systemFontOfSize:16];
    _content.text = @"12305";
    _content.textColor = [UIColor grayColor];
    [self.contentView addSubview:_content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(_icon.mas_right).with.offset(10);
    }];

}

-(void)setContent:(NSString *)content andIcon:(NSString *)icon{
    _content.text = content;
    _icon.text = icon;
    
}

@end
