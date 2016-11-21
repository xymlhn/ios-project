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
#import "AMapViewController.h"
#import "HelpViewController.h"
#import "AppManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MeViewController ()
@property (nonatomic, strong) MeView *meView;
@property (nonatomic, strong) User *user;


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
    
    _meView.mapBtn.userInteractionEnabled = YES;
    [_meView.mapBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapBtnClick:)]];
    
    _meView.helpBtn.userInteractionEnabled = YES;
    [_meView.helpBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(helpBtnClick:)]];
    
    [_meView.workSwitch setOn:[Config isWork]];
    [_meView.workSwitch addTarget:self action:@selector(onWorkAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)loadData{
    _user =[[AppManager getInstance] getUser];
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_USERICONURL,_user.userOpenId];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *dict, NSString *error) {
        if(!error){
            [_meView.userIcon sd_setImageWithURL:[NSURL URLWithString:dict[@"success"]]
                         placeholderImage:[UIImage imageNamed:@"default－portrait.png"]];
        }
    }];
    _meView.nickName.text = _user.userNickName;
}

#pragma mark - IBAction
- (void)logoutBtnClick:(UITapGestureRecognizer *)recognizer{
    if([Config isWork]){
        [Utils showHudTipStr:@"请下班后再登出!"];
        return;
    }
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"登出中...";
    hub.userInteractionEnabled = NO;
    [[AppManager getInstance] logoutWithBlock:^(NSDictionary *data, NSString *error) {
        if(!error){
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = [NSString stringWithFormat:@"登出成功"];
            [hub hide:YES];
            [[AppManager getInstance] clearUserDataWhenLogout];
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
    setting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setting animated:YES];
}
- (void)mapBtnClick:(UITapGestureRecognizer *)recognizer{
    AMapViewController *setting = [AMapViewController new];
    setting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)helpBtnClick:(UITapGestureRecognizer *)recognizer{
    HelpViewController *setting = [HelpViewController new];
    setting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setting animated:YES];
}

-(void)onWorkAction:(id)sender
{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.userInteractionEnabled = NO;
    
    NSDictionary *dict = @{@"isOnWork":[NSNumber numberWithBool:[Config isWork]]};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_ISONWORK];
    [HttpUtil post:URLString param:dict finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            NSString *tips = [Config isWork] ? @"下班成功" : @"上班成功";
            hub.labelText = tips;
            [hub hide:YES afterDelay:kEndSucceedDelayTime];
            [Config setWork:![Config isWork]];
            
        }else{
            [weakSelf.meView.workSwitch setOn:[Config isWork]];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kEndFailedDelayTime];
        }
    }];
}

@end
