//
//  DateTimeCell.m
//  qmcp
//
//  Created by 谢永明 on 16/7/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "DateTimeCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "ActionSheetDatePicker.h"
#import "Utils.h"
@implementation DateTimeCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"DateTimeCell";
    DateTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[DateTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
    _name.text = @"输入框";
    _name.textColor = [UIColor blackColor];
    [self.contentView addSubview:_name];
    
    UIView *containView = [UIView new];
    containView.backgroundColor = [UIColor whiteColor];
    containView.layer.borderColor = [UIColor grayColor].CGColor;
    containView.layer.borderWidth = 1.0;
    containView.layer.cornerRadius = 5.0;
    containView.layer.masksToBounds = YES;
    [self.contentView addSubview:containView];
    
    _value = [UITextField new];
    _value.font = [UIFont systemFontOfSize:13];
    _value.placeholder = @"请选择";
    _value.textColor = [UIColor blackColor];
    _value.enabled = NO;
    [containView addSubview:_value];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];
    
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_name.mas_bottom).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
        make.height.equalTo(@30);
    }];
    
    [_value mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(containView.mas_left).with.offset(10);
        make.right.equalTo(containView.mas_right).with.offset(-10);
        make.centerY.equalTo(containView.mas_centerY);
        make.height.equalTo(@30);
    }];

    containView.userInteractionEnabled = YES;
    [containView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(valueClick:)]];
    
}

#pragma mark - IBAction
-(void)valueClick:(UITapGestureRecognizer *)recognizer
{
    NSDate *curDate = [NSDate new];
    
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:nil datePickerMode:UIDatePickerModeDateAndTime selectedDate:curDate doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
        NSString *str = [ Utils formatDate:selectedDate];
        _value.text = str;
        _field.trueValue = str;
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:self.contentView];
    [picker showActionSheetPicker];
}

//重写属性的setter方法，给子控件赋值
- (void)setField:(FormTemplateField *)field
{
    
    if(field != nil){
        _field = field;
        _name.text = field.name;
        if(field.trueValue != nil){
            _value.text = field.trueValue;
        }else{
            _value.text = field.defaultValue;
        }
        
    }
}

@end
