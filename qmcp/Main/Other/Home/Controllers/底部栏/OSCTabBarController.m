//
//  OSCTabBarController.m
//  iosapp
//
//  Created by chenhaoxiang on 12/15/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "OSCTabBarController.h"
#import "SwipableViewController.h"
#import "UIColor+Util.h"
#import "UIView+Util.h"
#import "UIImage+Util.h"
#import <RESideMenu/RESideMenu.h>
#import "WorkOrderListController.h"
#import "WorkOrder.h"
#import "SalesOrderMineListController.h"
#import "SalesOrderGrabListController.h"
#import "HelpViewController.h"
#import "PropertyManager.h"
#import "Config.h"
#import "SearchViewController.h"
#import "AMapViewController.h"
#import "AppManager.h"
@interface OSCTabBarController () <UITabBarControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    WorkOrderListController *newsViewCtl;
    WorkOrderListController *hotNewsViewCtl;
    
    SalesOrderMineListController *bindViewCtl;
    SalesOrderGrabListController *grabViewCtl;
}
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;
@end

@implementation OSCTabBarController

- (NSMutableArray *)items
{
    if (_items == nil) {
        
        _items = [NSMutableArray array];
        
    }
    return _items;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    newsViewCtl.view.backgroundColor = [UIColor themeColor];
    hotNewsViewCtl.view.backgroundColor = [UIColor themeColor];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor nameColor]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    newsViewCtl = [[WorkOrderListController alloc]  initWithStatus:WorkOrderStatusInProgress];
    hotNewsViewCtl = [[WorkOrderListController alloc] initWithStatus:WorkOrderStatusCompleted];
    
    grabViewCtl = [SalesOrderGrabListController new];
    bindViewCtl = [SalesOrderMineListController new];
 
    AMapViewController *gis = [[AMapViewController alloc] init];
    HelpViewController *help = [[HelpViewController alloc] init];
    SwipableViewController *saleOrderSVC = [[SwipableViewController alloc] initWithTitle:@"订单"
                                                                            andSubTitles:@[@"抢单", @"绑定"]
                                                                          andControllers:@[grabViewCtl, bindViewCtl]
                                                                             underTabbar:YES];
    if ([[AppManager getInstance] getUser].cooperationMode == CooperationModeSingle) {
        _titles = @[@"订单", @"地图", @"帮助"];
        _images = @[@"tabbar-discover", @"tabbar-discover", @"tabbar-me"];
        self.viewControllers = @[[self addNavigationItemForViewController:saleOrderSVC],
                                 [self addNavigationItemForViewController:gis],
                                 [self addNavigationItemForViewController:help]];
    }else{
        _titles = @[@"工单",@"订单", @"地图", @"帮助"];
        _images = @[@"tabbar-news", @"tabbar-discover", @"tabbar-discover", @"tabbar-me"];
        SwipableViewController *workOrderSVC = [[SwipableViewController alloc] initWithTitle:@"工单"
                                                                                andSubTitles:@[@"未完成", @"待上传",]
                                                                              andControllers:@[newsViewCtl, hotNewsViewCtl]
                                                                                 underTabbar:YES];
        self.viewControllers = @[[self addNavigationItemForViewController:workOrderSVC],
                                 [self addNavigationItemForViewController:saleOrderSVC],
                                 [self addNavigationItemForViewController:gis],
                                 [self addNavigationItemForViewController:help]];
    }


    
   
    self.tabBar.translucent = NO;
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:_titles[idx]];
        [item setImage:[UIImage imageNamed:_images[idx]]];
        [item setSelectedImage:[UIImage imageNamed:[_images[idx] stringByAppendingString:@"-selected"]]];
    }];
    
    [self.tabBar addObserver:self
                  forKeyPath:@"selectedItem"
                     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                     context:nil];
}

- (void)dealloc
{
    [self.tabBar removeObserver:self forKeyPath:@"selectedItem"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedItem"]) {
    }
}

#pragma mark -

- (UINavigationController *)addNavigationItemForViewController:(UIViewController *)viewController
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    viewController.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"]
                                                                                        style:UIBarButtonItemStylePlain
                                                                                       target:self action:@selector(onClickMenuButton)];
    viewController.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"]
                                                                                        style:UIBarButtonItemStylePlain
                                                                                       target:self action:@selector(onClickSearchButton)];
    return navigationController;
}

- (void)onClickMenuButton
{
    [self.sideMenuViewController presentLeftMenuViewController];
}


//TODO: 搜索系统
-(void)onClickSearchButton{
    SearchViewController *info = [SearchViewController new];
    [self setContentViewController:info];
}

- (void)setContentViewController:(UIViewController *)viewController
{
    viewController.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)((UITabBarController *)self.sideMenuViewController.contentViewController).selectedViewController;
    [nav pushViewController:viewController animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
@end
