//
//  MeViewController.m
//  qmcp
//
//  Created by 谢永明 on 2016/10/21.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "MeViewController.h"
#import "MeView.h"
#import "AppManager.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
@interface MeViewController ()
@property (nonatomic, strong) MeView *meView;
@end

@implementation MeViewController

-(void)loadView
{
    _meView = [MeView new];
    self.view = _meView;
    self.title = @"我";
}

-(void)bindListener{
    _meView.logoutBtn.userInteractionEnabled = YES;
    [_meView.logoutBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutBtnClick:)]];
    
    _meView.settingBtn.userInteractionEnabled = YES;
    [_meView.settingBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingBtnClick:)]];
}

#pragma mark - IBAction
- (void)logoutBtnClick:(UITapGestureRecognizer *)recognizer{
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
            [hub hide:YES afterDelay:kEndFailedDelayTime];
        }
    }];
}

- (void)settingBtnClick:(UITapGestureRecognizer *)recognizer{
    SettingViewController *setting = [SettingViewController new];
    [self.navigationController pushViewController:setting animated:YES];
}
@end
