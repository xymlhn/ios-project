//
//  AppManager.m
//  qmcp
//
//  Created by 谢永明 on 16/3/4.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "AppManager.h"
#import "Config.h"
#import "AFHTTPSessionManager.h"
#import "OSCAPI.h"
#import "CZAccount.h"
#import "RootViewController.h"
#import "Config.h"
#import "Utils.h"
#import "HttpUtil.h"
#import "MJExtension.h"
#import "CZAccount.h"
#import "WorkOrder.h"
#import "SalesOrderSnapshot.h"
#import "NSObject+LKDBHelper.h"
#import "WorkOrderManager.h"
#import "AppDelegate.h"
#import "GisViewController.h"
#import "LoginViewController.h"
static AppManager *sharedObj = nil; //第一步：静态实例，并初始化。
@implementation AppManager

+ (AppManager*) getInstance  //第二步：实例构造检查静态实例是否为nil
{
    
    if (!sharedObj)
    {
        sharedObj=[[super allocWithZone:NULL]init];
    }
 
    return sharedObj;
}

+ (id) allocWithZone:(NSZone *)zone
{
    if (sharedObj == nil) {
        sharedObj = [super allocWithZone:zone];
        return sharedObj;
    }

    return nil;
}
- (id)init
{
    if (self = [super init]) {
        sharedObj = [[AppManager alloc]init];
    }
    return self;
}
- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

-(BOOL)handleHeader:(NSURLSessionDataTask *) session
{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)session.response;
    NSDictionary *dic = response.allHeaderFields;
    
    BOOL failure = [dic valueForKey:@"failure"];
    if(failure){
        int type = [[dic valueForKey:@"exceptionType"] intValue];
        if (type != (int)ExceptionTypeNotLogin)  {
            NSLog(@"服务器异常- %d",type);
        } else {
            NSArray *accountAndPassword = [Config getOwnAccountAndPassword];
            NSString *name = accountAndPassword? accountAndPassword[0] : @"";
            NSString *password = accountAndPassword? accountAndPassword[1] : @"";
            [[AppManager getInstance] reLogin:name password:password isFirst:false];
        }
    }
    return failure;
}

-(void)reLogin:(NSString *)userName password:(NSString *)password isFirst:(BOOL)isFirst
{
    NSDictionary *dic = @{ @"user":userName,@"pwd":password};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_LOGIN];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * session, id responseObject){
        CZAccount *account = [CZAccount accountWithDict:responseObject];
        if(account.isAuthenticated){
            if(isFirst){
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:@"reLogin" object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }
        }else{
            
        }
    }failure:^(NSURLSessionDataTask * task, NSError * error){
        
    }];
}

-(void)login:(UIViewController *)viewController userName:(NSString *)userName password:(NSString *)password{
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在登录";
    hub.userInteractionEnabled = NO;

    
    // 请求参数
    NSDictionary *dic = @{ @"user":userName,@"pwd":password};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_LOGIN];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * session, id responseObject){
        // 字典转模型
        CZAccount *account = [CZAccount accountWithDict:responseObject];
        if(account.isAuthenticated){
            [Config saveOwnAccount:userName andPassword:password];
            [Config saveLoginStatus:true];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = [NSString stringWithFormat:@"登录成功"];
            [hub hide:YES afterDelay:0.2];
            UIStoryboard *discoverSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            RootViewController *discoverNav = [discoverSB instantiateViewControllerWithIdentifier:@"Nav"];
            [viewController presentViewController:discoverNav animated:YES completion:nil];
        }else{
            
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = [NSString stringWithFormat:@"账号或密码错误"];
            
            [hub hide:YES afterDelay:1];
        }
        
    }failure:^(NSURLSessionDataTask * task, NSError * error){
        hub.mode = MBProgressHUDModeCustomView;
        hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        hub.labelText = [NSString stringWithFormat:@"网络错误"];
        [hub hide:YES afterDelay:1];
    }];
}


-(void) logout:(UIViewController *)viewController
{

    // 请求参数
    NSDictionary *dic = @{};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_LOGOUT];
    
    [HttpUtil post:URLString param:dic finish:^(NSDictionary *obj, NSError *error) {
        if (error == nil) {
            [Config setInitSetting];
            LoginViewController *loginNav = [LoginViewController new];
            [viewController presentViewController:loginNav animated:YES completion:nil];

        }else{
             NSLog(@"登出失败!!!");
        }
    }];
}

-(void) getServerTime
{
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在对比服务器时间";
    hub.userInteractionEnabled = NO;

    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_SERVER_TIME];


    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (error == nil) {
            NSLog(@"fuck");
            [hub hide:YES];
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = [NSString stringWithFormat:@"错误：%@",@"fuck"];
            [hub hide:YES afterDelay:1];;
        }
    }];
}

-(void) updateNickName
{
    NSDictionary *dict = @{@"nickName":@"123465"};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_NICKNAME];
    [HttpUtil post:URLString param:dict finish:^(NSDictionary *obj, NSError *error) {
        if (error == nil) {
            NSLog(@"success");
            
        }else{
           
        }
    }];
}

-(void) pushId:(NSString *)pushId
{
    NSDictionary *dict = @{@"pushId":pushId};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_PUSHID];
    [HttpUtil post:URLString param:dict finish:^(NSDictionary *obj, NSError *error) {
        if (error == nil) {
            NSLog(@"success");
            
        }else{
            
        }
    }];
}

@end
