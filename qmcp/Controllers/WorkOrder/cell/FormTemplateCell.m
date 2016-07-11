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
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.contentView.mas_top).with.offset(5);
        make.left.equalTo(self.contentView.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    [_sort mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_name.mas_bottom).with.offset(5);
        make.right.equalTo(self.contentView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
    [self initBorderLine:self.contentView];
}

-(void)initBorderLine:(UIView *)view{
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [view addSubview:codeBottomLine];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(view.mas_bottom).with.offset(0);
        make.left.equalTo(view.mas_left).with.offset(0);
        make.right.equalTo(view.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    UIView *topLine = [UIView new];
    topLine.backgroundColor = [UIColor grayColor];
    [view addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(view.mas_top).with.offset(0);
        make.left.equalTo(view.mas_left).with.offset(0);
        make.right.equalTo(view.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    UIView *leftLine = [UIView new];
    leftLine.backgroundColor = [UIColor grayColor];
    [view addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(view.mas_bottom).with.offset(0);
        make.top.equalTo(view.mas_top);
        make.left.equalTo(view.mas_left).with.offset(0);
        make.width.mas_equalTo(@1);
    }];
    
    UIView *rightLine = [UIView new];
    rightLine.backgroundColor = [UIColor grayColor];
    [view addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(view.mas_bottom).with.offset(0);
        make.top.equalTo(view.mas_top);
        make.right.equalTo(view.mas_right).with.offset(0);
        make.width.mas_equalTo(@1);
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
