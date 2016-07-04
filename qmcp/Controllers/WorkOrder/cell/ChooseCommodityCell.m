//
//  ChooseCommodityCell.m
//  qmcp
//
//  Created by 谢永明 on 16/7/4.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "ChooseCommodityCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"
@interface ChooseCommodityCell()
@property (nonatomic,strong) UILabel *nameText;

@end
@implementation ChooseCommodityCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"WorkOrderCell";
    ChooseCommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[ChooseCommodityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
    _nameText = [UILabel new];
    _nameText.textColor = [UIColor whiteColor];
    _nameText.textAlignment = NSTextAlignmentCenter;
    _nameText.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_nameText];
    
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

@end
