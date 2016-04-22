//
//  AppDelegate.m
//  qmcp
//
//  Created by 谢永明 on 16/3/1.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+Util.h"
#import "RootViewController.h"
#import "Config.h"
#import <Bugly/CrashReporter.h>
#import "GisViewController.h"
#import "WorkOrderManager.h"
#import "LoginViewController.h"
#import "Config.h"
#import "AppManager.h"
#import "InitViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /************第三方插件配置 **************/
    
    [[CrashReporter sharedInstance] installWithAppId:@"900013853"];

    /************ 控件外观设置 **************/
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithHex:0x15A230]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x15A230]} forState:UIControlStateSelected];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor navigationbarColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor titleBarColor]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    /************ 登录状态设置 **************/
    if (![Config getLoginStatus]) {
        //UIStoryboard *login = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
       // LoginViewController *loginNav = [login instantiateViewControllerWithIdentifier:@"Nav"];
        LoginViewController *loginNav = [LoginViewController new];
        self.window.rootViewController= loginNav;
        
    }else{
        InitViewController *init = [InitViewController new];
        self.window.rootViewController = init;
    }
    
    [self.window makeKeyAndVisible];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLogin:) name:@"reLogin" object:nil];
    return YES;
}

- (void)reLogin:(NSNotification *)text{
    UIStoryboard *root = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RootViewController *rootNav = [root instantiateViewControllerWithIdentifier:@"Nav"];
    self.window.rootViewController= rootNav;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
