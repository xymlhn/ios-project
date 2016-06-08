//
//  TextCell.m
//  qmcp
//
//  Created by 谢永明 on 16/6/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "TextCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"

@implementation TextCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"textCell";
    TextCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[TextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
    _name.font = [UIFont systemFontOfSize:12];//
    _name.text = @"输入框";
    _name.textColor = [UIColor blackColor];
    [self.contentView addSubview:_name];
    
    _value = [UITextField new];
    _value.font = [UIFont systemFontOfSize:12];//
    _value.text = @"输入框";
    _value.textColor = [UIColor blackColor];
    [self.contentView addSubview:_value];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.width.mas_equalTo(50);
    }];
    
    [_value mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(_name.mas_right).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [_value addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}

-(void)textFieldDidChange:(UITextField *)textField{
    _field.defaultValue = textField.text;
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
