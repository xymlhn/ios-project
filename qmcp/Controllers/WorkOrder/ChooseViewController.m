//
//  ChooseViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/7/3.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "ChooseViewController.h"
#import "ChooseView.h"

@interface ChooseViewController()
@property (nonatomic,strong)ChooseView *chooseView;
@end
@implementation ChooseViewController

-(void)initView{
    _chooseView = [ChooseView new];
    [_chooseView initView:self.view];
}

-(void)bindListener{
    _chooseView.baseView.userInteractionEnabled = YES;
    [_chooseView.baseView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)]];
    
}

-(void)loadData{
    
}

- (void)dissmiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
