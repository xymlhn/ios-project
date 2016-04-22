//
//  PhotoCell.m
//  qmcp
//
//  Created by 谢永明 on 16/4/5.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "PhotoCell.h"
#import "Masonry.h"
@implementation PhotoCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _image = [UIImageView new];
        [self addSubview:_image];
        [_image mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(0);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}

@end
