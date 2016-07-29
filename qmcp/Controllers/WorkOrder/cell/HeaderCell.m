//
//  HeaderCell.m
//  qmcp
//
//  Created by 谢永明 on 16/7/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "HeaderCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"
@implementation HeaderCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"HeaderCell";
    HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[HeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
    self.contentView.backgroundColor = [UIColor selectCellSColor];
    _name = [UILabel new];
    _name.font = [UIFont systemFontOfSize:12];
    _name.textColor = [UIColor blackColor];
    _name.text = @"明细";
    [self.contentView addSubview:_name];
    
    _deleteBtn = [UILabel new];
    _deleteBtn.font = [UIFont systemFontOfSize:12];
    _deleteBtn.textColor = [UIColor redColor];
    _deleteBtn.text = @"删除";
    [self.contentView addSubview:_deleteBtn];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];
    
}

-(void)setField:(FormTemplateField *)field{
    if (field != nil) {
        _field = field;
        _name.text = [NSString stringWithFormat:@"%@%lu",@"明细",_field.tempOrder];
    }
}

@end
