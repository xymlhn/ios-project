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
    [self setupView];
    [self bindListener];
    [self loadData];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self saveData];
}

-(void)loadData{
    
}

-(void)setupView{

}
-(void)bindListener{
    
}

-(void)saveData{}


@end
