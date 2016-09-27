//
//  PickupNoticeCell.m
//  qmcp
//
//  Created by 谢永明 on 16/7/7.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "PickupNoticeCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"

@implementation PickupNoticeCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"PickupNoticeCell";
    PickupNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[PickupNoticeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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

//重写属性的setter方法，给子控件赋值
- (void)setItemComplete:(ItemComplete *)itemComplete
{
    _contentText.text = itemComplete.message;
    _contentText.textColor = itemComplete.status ? [UIColor greenColor] : [UIColor redColor];
}

-(void)initView{
    _contentText = [UILabel new];
    _contentText.textColor = [UIColor whiteColor];
    _contentText.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    [self.contentView addSubview:_contentText];
    
    [_contentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView.mas_width);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}
@end
