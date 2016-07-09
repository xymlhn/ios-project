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

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _name = [UILabel new];
        _name.font = [UIFont systemFontOfSize:12];//
        _name.text = @"12305";
        _name.textColor = [UIColor blackColor];
        [self.contentView addSubview:_name];
        
        
        _sort = [UILabel new];
        _sort.font = [UIFont systemFontOfSize:12];//
        _sort.text = @"12305";
        _sort.textColor = [UIColor blackColor];
        [self.contentView addSubview:_sort];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    [_name mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    [_sort mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_name.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-kPaddingLeftWidth);
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
