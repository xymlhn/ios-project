//
//  ViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/3/1.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "RootViewController.h"
#import "WorkOrderManager.h"
#import "Config.h"
#import "PropertyManager.h"
#import "CameraManager.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.parallaxEnabled = NO;
    self.scaleContentView = YES;
    self.contentViewScaleValue = 0.95;
    self.scaleMenuView = NO;
    self.contentViewShadowEnabled = YES;
    self.contentViewShadowRadius = 4.5;
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //数据初始化
    [[WorkOrderManager getInstance] getWorkOrderByLastUpdateTime:[Config getWorkOrderTime]];
    [[WorkOrderManager getInstance] getCommodityStepByLastUpdateTime:[Config getCommodityStep]];
    [[PropertyManager getInstance] getCommodityItemByLastUpdateTime:[Config getCommodityItem]];
    [[PropertyManager getInstance] getCommoditySnapshotByLastUpdateTime:[Config getCommoditySnapshot]];
    [[PropertyManager getInstance] getCommodityPropertyByLastUpdateTime:[Config getCommodityProperty]];
    [[CameraManager getInstance] getAllSystemCamera];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
