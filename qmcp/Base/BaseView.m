//
//  BaseView.m
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

-(void)initView:(UIView *)rootView{
    [NSException raise:NSInternalInconsistencyException format:@"必须覆写%@方法在子类",NSStringFromSelector(_cmd)];
}

@end
