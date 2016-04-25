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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    [cell setContent:@[@"扫描取单", @"客户取件", @"设置", @"注销"][indexPath.row] andIcon:@[@"", @"", @"", @""][indexPath.row]];

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
        case 1: {
            LoginViewController *view = [LoginViewController new];
            [self setContentViewController:view];
            
            break;
        }
        case 2: {
            SettingViewController *setting = [SettingViewController new];
            [self setContentViewController:setting];
            break;
        }
        case 3: {
            [[AppManager getInstance] logoutWithBlock:^(NSDictionary *data, NSError *error) {
                if(!error){
                    [Config setInitSetting];
                    LoginViewController *loginNav = [LoginViewController new];
                    [self presentViewController:loginNav animated:YES completion:nil];
                }else{
                    [Utils showHudTipStr:@"登出失败！"];
                }
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
    [[WorkOrderManager getInstance] getWorkOrderByItemCode:result];
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
    avatar.userInteractionEnabled = YES;
    avatar.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:avatar];
    
    avatar.image = [UIImage imageNamed:@"default－portrait"];

    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"fuck";
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
