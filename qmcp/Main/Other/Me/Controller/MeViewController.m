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
    [HttpUtil get:URLString param:nil finishString:^(NSString *str, NSString *error) {
        if(!error){
            [_meView.userIcon sd_setImageWithURL:[NSURL URLWithString:str]
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
    hub.detailsLabel.text = @"登出中...";
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_LOGOUT];
    [HttpUtil post:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if(!error){
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.detailsLabel.text = [NSString stringWithFormat:@"登出成功"];
            [hub hideAnimated:YES];
            [[AppManager getInstance] clearUserDataWhenLogout];
            LoginViewController *loginNav = [LoginViewController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginNav];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
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
    
    
    NSDictionary *dict = @{@"isOnWork":[NSNumber numberWithBool:[Config isWork]]};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_ISONWORK];
    [HttpUtil post:URLString param:dict finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            NSString *tips = [Config isWork] ? @"下班成功" : @"上班成功";
            hub.detailsLabel.text = tips;
            [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            [Config setWork:![Config isWork]];
            
        }else{
            [weakSelf.meView.workSwitch setOn:[Config isWork]];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
    }];
}

@end
