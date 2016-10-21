//
//  MeViewController.m
//  qmcp
//
//  Created by 谢永明 on 2016/10/21.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "MeViewController.h"
#import "MeView.h"
@interface MeViewController ()
@property (nonatomic, strong) MeView *meView;
@end

@implementation MeViewController

-(void)loadView
{
    _meView = [MeView new];
    self.view = _meView;
}

@end
