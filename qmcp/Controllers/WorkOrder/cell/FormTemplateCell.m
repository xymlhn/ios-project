//
//  FormTemplateCell.m
//  qmcp
//
//  Created by 谢永明 on 16/6/13.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "FormTemplateCell.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "PchHeader.h"
#import "EnumUtil.h"

@implementation FormTemplateCell

//创建自定义可重用的cell对象
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"formTemplateCell";
    FormTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[FormTemplateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
    _name.text = @"12305";
    _name.textColor = [UIColor blackColor];
    [self.contentView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    _sort = [UILabel new];
    _sort.font = [UIFont systemFontOfSize:12];//
    _sort.text = @"12305";
    _sort.textColor = [UIColor blackColor];
    [self.contentView addSubview:_sort];
    [_sort mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_name.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
}

//重写属性的setter方法，给子控件赋值
- (void)setFormTemplateBrife:(FormTemplateBrife *)formTemplateBrife
{
    if(formTemplateBrife != nil){
        _name.text = formTemplateBrife.name;
        _sort.text = [EnumUtil formSortString:formTemplateBrife.formSort];
    }
}






@end
