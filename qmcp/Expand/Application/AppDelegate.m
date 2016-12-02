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
#import "LoginViewController.h"
#import "Config.h"
#import "AppManager.h"
#import "InitViewController.h"
#import "IntroductionViewController.h"
#import "Utils.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "WorkOrderManager.h"

//release个推
#define kGtAppId           @"dLHszaMpIBAyRlw6rszPh6"
#define kGtAppKey          @"EjKuxC6UEr6giWA4E8LYVA"
#define kGtAppSecret       @"k3omeDKdwa6Ggzvnm8ziW9"

//debug个推
//#define kGtAppId           @"yxTFMPHTpv6T8rfKta9SX8"
//#define kGtAppKey          @"kefJFWJynJ8WEB92REUqu5"
//#define kGtAppSecret       @"w06kLRipvH9dZqKaCR7E25"

#define kAMapKey           @"7a4c3ed3ea57b1213553024955a50a10"
const static int databaseVersion = 0;
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /************第三方插件配置 **************/
    [self p_setupAppearance];
    //数据库升级
    int currentDataBaseVersion = [Config getDatabaseVersion];
    if(currentDataBaseVersion != databaseVersion){
        [self p_updateDataBase];
        [Config setInitSetting];
    }
    [Config setDatabaseVersion:databaseVersion];
    //个推
    [self p_setupGeTui];
    //高德地图
    [AMapServices sharedServices].apiKey = kAMapKey;

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /************ 登录状态设置 **************/
    if (![Config getLoginStatus]) {
        IntroductionViewController *intro = [IntroductionViewController new];
        self.window.rootViewController = intro;
    }else{
        InitViewController *init = [InitViewController new];
        self.window.rootViewController = init;
    }
    
    [self.window makeKeyAndVisible];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_reLogin:) name:kReloginNotification object:nil];
    return YES;
}

//****************************控件外观设置****************************//
-(void)p_setupAppearance{
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                NSFontAttributeName:[UIFont systemFontOfSize:kShiwupt]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor appBlueColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"icon_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];

    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor appBlueColor]} forState:UIControlStateSelected];
}

//****************************数据库****************************//
-(void)p_updateDataBase{
    LKDBHelper* globalHelper = [WorkOrder getUsingLKDBHelper];
    [globalHelper dropAllTable];
}

//****************************重登陆****************************//
- (void)p_reLogin:(NSNotification *)text{
    NSString *info = text.userInfo[@"info"];
    if([info isEqualToString:@"0"]){
        UIStoryboard *root = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RootViewController *rootNav = [root instantiateViewControllerWithIdentifier:@"Nav"];
        self.window.rootViewController= rootNav;
    }else{
        [Utils showHudTipStr:@"重登陆失败，请手动登录！"];
        [[AppManager getInstance] clearUserDataWhenLogout];
        LoginViewController *loginNav = [LoginViewController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginNav];
        self.window.rootViewController = nav;
    }
}

//****************************个推****************************//
-(void)p_setupGeTui{
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    [self registerRemoteNotification];
}
/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                DebugLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    DebugLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    //向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    [Utils showHudTipStr:[error localizedDescription]];
}

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    DebugLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    [Config setPushId:clientId];
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes
                                              length:payloadData.length
                                            encoding:NSUTF8StringEncoding];
    }
    DebugLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", payloadMsg);
    if (payloadMsg != nil && !offLine) {
        NSArray *array = [payloadMsg componentsSeparatedByString:@" "];
        if ([[[AppManager getInstance]getUser].userOpenId isEqualToString:array[0]]) {
            if ([array[1] isEqualToString:@"assign"]) {
                [[WorkOrderManager getInstance] getWorkOrderByCode:array[2]];
            }else if ([array[1] isEqualToString:@"unassign"]){
                BOOL flag = [[WorkOrderManager getInstance] deleteWorkOrderByCode:array[2]];
                if (flag) {
                    [[WorkOrderManager getInstance] sortAllWorkOrder];
                }
            }else if ([array[1] isEqualToString:@"logout"]){
                [[AppManager getInstance] clearUserDataWhenLogout];
                LoginViewController *loginNav = [LoginViewController new];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginNav];
                self.window.rootViewController = nav;
            }
        }
    }
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
}
/** APP已经接收到“远程”通知(推送) - 透传推送消息  */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {

    DebugLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
