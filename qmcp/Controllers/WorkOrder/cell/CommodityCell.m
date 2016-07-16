//
//  CommodityCell.m
//  qmcp
//
//  Created by 谢永明 on 16/4/19.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "CommodityCell.h"
#import "Masonry.h"
@implementation CommodityCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _textView = [UILabel new];
        _textView.backgroundColor = [UIColor redColor];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.numberOfLines = 0;
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(0);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}

@end
