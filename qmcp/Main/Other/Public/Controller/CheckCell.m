//
//  CheckCell.m
//  qmcp
//
//  Created by 谢永明 on 16/7/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "CheckCell.h"
#import "Masonry.h"
#import "PchHeader.h"
@implementation CheckCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"CheckCell";
    CheckCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[CheckCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
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
    UIView *containView = [UIView new];
    [self.contentView addSubview:containView];
    
    _jsText = [UILabel new];
    _jsText.font = [UIFont systemFontOfSize:14];
    _jsText.text = @"12305";
    _jsText.textColor = [UIColor blackColor];
    _jsText.numberOfLines = 0;
    [containView addSubview:_jsText];
    
    _jsSwitch = [UISwitch new];
    [containView addSubview:_jsSwitch];
    
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_jsSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(containView.mas_centerY);
        make.right.equalTo(containView.mas_right).with.offset(-kPaddingLeftWidth);
        make.width.equalTo(@50);
    }];
    
    [_jsText mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(containView.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(_jsSwitch.mas_left);
        make.centerY.equalTo(containView.mas_centerY);

    }];
    

}

@end
