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
#import "AppManager.h"
#import "BusinessSalesOrderController.h"
#import "MeViewController.h"
#import "YCXMenu.h"
#import "ScanViewController.h"
#import "InventorySearchController.h"
#import "QrCodeViewController.h"
#import "PickupViewController.h"
#import "WorkOrderInfoController.h"
#import "PickupNoticeViewController.h"
#import "WorkOrderManager.h"
#import "SalesOrderManager.h"
#import "SalesOrderInfoController.h"
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
@property (nonatomic , strong) NSMutableArray *menuItems;
@end

@implementation OSCTabBarController

- (NSMutableArray *)items{
    if (_items == nil) {
        
        _items = [NSMutableArray array];
        
    }
    return _items;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    newsViewCtl.view.backgroundColor = [UIColor themeColor];
    hotNewsViewCtl.view.backgroundColor = [UIColor themeColor];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor nameColor]];

}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    newsViewCtl = [[WorkOrderListController alloc]  initWithStatus:WorkOrderStatusInProgress];
    hotNewsViewCtl = [[WorkOrderListController alloc] initWithStatus:WorkOrderStatusCompleted];
    
    grabViewCtl = [SalesOrderGrabListController new];
    bindViewCtl = [SalesOrderMineListController new];
 
    MeViewController *help = [[MeViewController alloc] init];
    SwipableViewController *saleOrderSVC = [[SwipableViewController alloc] initWithTitle:@"订单"
                                                                            andSubTitles:@[@"我的订单", @"待接订单"]
                                                                          andControllers:@[bindViewCtl,grabViewCtl]
                                                                             underTabbar:YES];
    if ([[AppManager getInstance] getUser].cooperationMode == CooperationModeSingle) {
        _titles = @[@"订单", @"我"];
        _images = @[@"tabbar-discover", @"tabbar-me"];
        self.viewControllers = @[[self addNavigationItemForViewController:saleOrderSVC],
                                 [self addNavigationItemForViewController:help]];
    }else{
        _titles = @[@"订单",@"工单", @"我"];
        _images = @[@"tabbar-news", @"tabbar-discover", @"tabbar-me"];
        SwipableViewController *workOrderSVC = [[SwipableViewController alloc] initWithTitle:@"工单"
                                                                                andSubTitles:@[@"未完成", @"待上传",]
                                                                              andControllers:@[newsViewCtl, hotNewsViewCtl]
                                                                                 underTabbar:YES];
        self.viewControllers = @[[self addNavigationItemForViewController:saleOrderSVC],
                                 [self addNavigationItemForViewController:workOrderSVC],
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

- (void)dealloc{
    [self.tabBar removeObserver:self forKeyPath:@"selectedItem"];
}

- (NSMutableArray *)menuItems {
    
    if (!_menuItems) {
        YCXMenuItem *salesToOrder = [YCXMenuItem menuItem:@"商家下单" image:[UIImage imageNamed:@"menu_order_icon"] target:self action:@selector(salesToOrderClick)];
        YCXMenuItem *inventoryitem = [YCXMenuItem menuItem:@"清点物品" image:[UIImage imageNamed:@"menu_order_icon"] target:self action:@selector(inventoryClick)];
        YCXMenuItem *qritem = [YCXMenuItem menuItem:@"扫描接单" image:[UIImage imageNamed:@"menu_scan_icon"] target:self action:@selector(qrCodeClick)];
        YCXMenuItem *completeitem = [YCXMenuItem menuItem:@"完成物品" image:[UIImage imageNamed:@"menu_notice_icon"] target:self action:@selector(completeClick)];
        YCXMenuItem *pickupitem = [YCXMenuItem menuItem:@"客户取件" image:[UIImage imageNamed:@"menu_pick_icon"] target:self action:@selector(pickupClick)];
        _menuItems = [@[salesToOrder,inventoryitem,qritem,completeitem,pickupitem] mutableCopy];
    }
    return _menuItems;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if ([keyPath isEqualToString:@"selectedItem"]) {
    }
}

- (UINavigationController *)addNavigationItemForViewController:(UIViewController *)viewController{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                                     target:self
                                                                                                     action:@selector(onClickMainRightButton)];
    return navigationController;
}
#pragma mark -IBAction
//右上角加号点击
-(void)onClickMainRightButton{

    [YCXMenu setTintColor:[UIColor blackColor]];

    [YCXMenu setSelectedColor:[UIColor redColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 55, 50, 0) menuItems:self.menuItems selected:^(NSInteger index, YCXMenuItem *item) {
            NSLog(@"%@",item);
        }];
    }
}
//商家下单
-(void)salesToOrderClick{
    __weak typeof(self) weakSelf = self;
    BusinessSalesOrderController *controller = [BusinessSalesOrderController doneBlock:^(NSString *code) {
        SalesOrderInfoController *info = [SalesOrderInfoController doneBlock:^(NSString *code) {
            NSNotification * notice = [NSNotification notificationWithName:SalesOrderUpdateNotification object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }];
        info.code = code;
        [weakSelf setContentViewController:info];
    }];
    [self setContentViewController:controller];
}
//清点物品
-(void)inventoryClick{

    InventorySearchController *view = [InventorySearchController new];
    [self setContentViewController:view];
}
//扫描接单
-(void)qrCodeClick{
    __weak typeof(self) weakSelf = self;
    if([Config getQuickScan]){
        ScanViewController *scanViewController =  [ScanViewController doneBlock:^(NSString *textValue) {
            [weakSelf handleResult:textValue];
        }];
        [self setContentViewController:scanViewController];
    }else{
        QrCodeViewController *qrCodeViewController = [QrCodeViewController doneBlock:^(NSString *textValue) {
            [weakSelf handleResult:textValue];
        }];
        [self setContentViewController:qrCodeViewController];
    }
}
//完成物品
-(void)completeClick{
    PickupNoticeViewController *view = [PickupNoticeViewController new];
    [self setContentViewController:view];
}
//客户取件
-(void)pickupClick{
    PickupViewController *view = [PickupViewController new];
    [self setContentViewController:view];
}

- (void)setContentViewController:(UIViewController *)viewController{
    viewController.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)((UITabBarController *)self.sideMenuViewController.contentViewController).selectedViewController;
    [nav pushViewController:viewController animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark qrcode
- (void)reportQrCodeResult:(NSString *)result{
    [self handleResult:result];
}

- (void)reportScanResult:(NSString *)result{
    [self handleResult:result];
}

-(void)handleResult:(NSString *)result{
    MBProgressHUD *hub = [Utils createHUD];
    hub.detailsLabel.text = @"扫描中...";
    
    [[WorkOrderManager getInstance] getWorkOrderByItemCode:result finishBlock:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.detailsLabel.text = [NSString stringWithFormat:@"扫描成功"];
            [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            WorkOrder *workOrder = [WorkOrder mj_objectWithKeyValues:obj];
            [workOrder saveToDB];
            [[WorkOrderManager getInstance] sortAllWorkOrder];
            [self pushWorkOrderInfoUI:workOrder.code];
            
        }else{
            
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
    }];
}
/**
 * 跳转到WorkOrderInfo界面
 *
 *  @param code 工单code
 */
-(void)pushWorkOrderInfoUI:(NSString *)code{
    WorkOrderInfoController *info = [WorkOrderInfoController new];
    info.workOrderCode = code;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}
@end
