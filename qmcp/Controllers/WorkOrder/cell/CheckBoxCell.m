//
//  CheckBoxCell.m
//  qmcp
//
//  Created by 谢永明 on 16/7/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "CheckBoxCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"

@implementation CheckBoxCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"CheckBoxCell";
    CheckBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[CheckBoxCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
    _name = [UILabel new];
    _name.font = [UIFont systemFontOfSize:12];
    _name.textColor = [UIColor blackColor];
    [self.contentView addSubview:_name];
    
    _value = [UILabel new];
    _value.font = [UIFont systemFontOfSize:12];
    _value.textColor = [UIColor blackColor];
    [self.contentView addSubview:_value];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];
    
    [_value mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_name.mas_bottom).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.height.equalTo(@20);
    }];
    
}

//重写属性的setter方法，给子控件赋值
- (void)setField:(FormTemplateField *)field
{
    if(field != nil){
        _field = field;
        _name.text = field.name;
        _value.text = field.defaultValue;
    }
}
@end
