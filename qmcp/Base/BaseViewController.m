//
//  BaseViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/20.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    [self bindListener];
    [self loadData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self saveData];
}

-(void)loadData{
    [NSException raise:NSInternalInconsistencyException format:@"必须覆写%@方法在子类",NSStringFromSelector(_cmd)];
}

-(void)initView{
    [NSException raise:NSInternalInconsistencyException format:@"必须覆写%@方法在子类",NSStringFromSelector(_cmd)];
}
-(void)bindListener{
    [NSException raise:NSInternalInconsistencyException format:@"必须覆写%@方法在子类",NSStringFromSelector(_cmd)];
}

-(void)saveData{}


@end
