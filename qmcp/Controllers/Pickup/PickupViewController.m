//
//  PickupViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/7/1.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "PickupViewController.h"
#import "PickupView.h"

@interface PickupViewController ()
@property(nonatomic,strong)PickupView *pickView;
@end

@implementation PickupViewController

-(void)initView{
    _pickView = [PickupView new];
    [_pickView initView:self.view];
}

-(void)bindListener{
    
}

-(void)loadData{
    
}

@end
