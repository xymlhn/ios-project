//
//  SideMenuController.m
//  qmcp
//
//  Created by 谢永明 on 16/3/1.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SideMenuController.h"
#import <RESideMenu.h>
#import "UIColor+Util.h"
#import "UIView+Util.h"
#import "Config.h"
#import "AppManager.h"
#import "SideMenuCell.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "WorkOrderManager.h"
#import "ScanViewController.h"
#import "QrCodeViewController.h"
#import "Utils.h"
#import "PickupViewController.h"
#import "WorkOrderInfoController.h"
#import "PickupNoticeView.h"
#import "PickupNoticeViewController.h"
#import "TMCache.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "InventorySearchController.h"
@interface SideMenuController ()

@end

@implementation SideMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor titleBarColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SideMenuCell *cell = [SideMenuCell SideMenuCellWithTableView:tableView];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBackground = [UIView new];
    selectedBackground.backgroundColor = [UIColor colorWithHex:0xCFCFCF];
    [cell setSelectedBackgroundView:selectedBackground];
    [cell setContent:@[@"清点物品",@"扫描取单", @"客户取件",@"完成物品", @"设置", @"注销"][indexPath.row] andIcon:@[@"",@"", @"", @"",@"", @""][indexPath.row]];

    return cell;
}
- (void)setContentViewController:(UIViewController *)viewController
{
    viewController.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)((UITabBarController *)self.sideMenuViewController.contentViewController).selectedViewController;
    [nav pushViewController:viewController animated:NO];
    [self.sideMenuViewController hideMenuViewController];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            InventorySearchController *view = [InventorySearchController new];
            [self setContentViewController:view];
            
            break;
        }
        case 1: {
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
            break;
        }
        case 2: {
            PickupViewController *view = [PickupViewController new];
            [self setContentViewController:view];
            
            break;
        }case 3: {
            PickupNoticeViewController *view = [PickupNoticeViewController new];
            [self setContentViewController:view];
            break;
        }
        case 4: {
            SettingViewController *setting = [SettingViewController new];
            [self setContentViewController:setting];
            break;
        }
        case 5: {
            MBProgressHUD *hub = [Utils createHUD];
            hub.labelText = @"登出中...";
            hub.userInteractionEnabled = NO;
            [[AppManager getInstance] logoutWithBlock:^(NSDictionary *data, NSString *error) {
                if(!error){
                    hub.mode = MBProgressHUDModeCustomView;
                    hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                    hub.labelText = [NSString stringWithFormat:@"登出成功"];
                    [hub hide:YES];
                    [[AppManager getInstance]clearUserDataWhenLogout];
                    LoginViewController *loginNav = [LoginViewController new];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginNav];
                    [self presentViewController:nav animated:YES completion:nil];
                }else{
                    hub.mode = MBProgressHUDModeCustomView;
                    hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                    hub.labelText = error;
                    [hub hide:YES afterDelay:kEndFailedDelayTime];                }
            }];
            break;
        }
        default: break;
    }
}

#pragma mark code
- (void)reportQrCodeResult:(NSString *)result
{
    [self handleResult:result];
}

- (void)reportScanResult:(NSString *)result
{
    [self handleResult:result];
}

-(void)handleResult:(NSString *)result
{
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"扫描中...";
    hub.userInteractionEnabled = NO;
    [[WorkOrderManager getInstance] getWorkOrderByItemCode:result finishBlock:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = [NSString stringWithFormat:@"扫描成功"];
            [hub hide:YES afterDelay:kEndSucceedDelayTime];
            WorkOrder *workOrder = [WorkOrder mj_objectWithKeyValues:obj];
            [workOrder saveToDB];
            [[WorkOrderManager getInstance] sortAllWorkOrder];
            [self pushWorkOrderInfoUI:workOrder.code];
            
        }else{

            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kEndFailedDelayTime];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *avatar = [UIImageView new];
    avatar.contentMode = UIViewContentModeScaleAspectFit;
    [avatar setCornerRadius:30];
    avatar.image = [UIImage imageNamed:@"default－portrait"];
    avatar.userInteractionEnabled = YES;
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:avatar];
   
    
    [[AppManager getInstance] getUserIconUrlByUserOpenId:[[AppManager getInstance] getUser].userOpenId finishBlock:^(NSDictionary *dict, NSString *error) {
        [avatar sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"default－portrait.png"]];
    }];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = [[AppManager getInstance] getUser].userNickName;
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
 
    nameLabel.textColor = [UIColor colorWithHex:0x696969];
   
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:nameLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(avatar, nameLabel);
    NSDictionary *metrics = @{@"x": @([UIScreen mainScreen].bounds.size.width / 4 - 15)};
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[avatar(60)]-10-[nameLabel]-15-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-x-[avatar(60)]" options:0 metrics:metrics views:views]];
    
    avatar.userInteractionEnabled = YES;
    nameLabel.userInteractionEnabled = YES;
    return headerView;
}
@end
