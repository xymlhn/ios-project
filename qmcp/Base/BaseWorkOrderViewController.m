//
//  BaseViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/3/21.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseWorkOrderViewController.h"
#import "WorkOrder.h"
#import "NSObject+LKDBHelper.h"
#import "Utils.h"

@interface BaseWorkOrderViewController ()

@end

@implementation BaseWorkOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                        forBarMetrics:UIBarMetricsDefault];
    if(_workOrderCode){
        self.navigationItem.title = _workOrderCode;
    }
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
    //[NSException raise:NSInternalInconsistencyException format:@"必须覆写%@方法在子类",NSStringFromSelector(_cmd)];
}

-(void)saveData{}

@end
