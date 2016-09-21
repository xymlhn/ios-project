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
    _delBtn = [UIButton new];
    [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_delBtn.layer setMasksToBounds:YES];
    [_delBtn.layer setCornerRadius:5.0];
    _delBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [_delBtn setBackgroundColor: [UIColor redColor]];
    [self.contentView addSubview:_delBtn];
    _nameText = [UILabel new];
    _nameText.textColor = [UIColor blackColor];
    _nameText.textAlignment = NSTextAlignmentCenter;
    _nameText.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_nameText];
    
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
    }];
    
    [_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
}

-(void)setPropertyChoose:(PropertyChoose *)propertyChoose
{
    _nameText.text = propertyChoose.name;
}
@end
