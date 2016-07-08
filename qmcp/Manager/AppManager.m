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

NSString *const kReloginNotification = @"reLogin";
@implementation AppManager

+ (AppManager *)getInstance {
    static AppManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
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
            [[AppManager getInstance] reLoginWithUserName:name andPassword:password isFirstLogin:false];
        }
    }
    return failure;
}

-(void)reLoginWithUserName:(NSString *)userName andPassword:(NSString *)password isFirstLogin:(BOOL)isFirst
{
    NSDictionary *dic = @{ @"user":userName,@"pwd":password};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_LOGIN];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * session, id responseObject){
        CZAccount *account = [CZAccount accountWithDict:responseObject];
        if(account.isAuthenticated){
            if(isFirst){
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:kReloginNotification object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }
            
        }else{
            
        }
    }failure:^(NSURLSessionDataTask * task, NSError * error){
        
    }];
}

-(void)loginWithUserName:(NSString *)userName andPassword:(NSString *)password andBlock:(void (^)(id data, NSError *error))block{
    // 请求参数
    NSDictionary *dic = @{ @"user":userName,@"pwd":password};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_LOGIN];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URLString parameters:dic progress:nil success:^(NSURLSessionDataTask * session, id responseObject){
        
        block(responseObject,nil);
        
    }failure:^(NSURLSessionDataTask * task, NSError * error){
        
        block(nil,error);
    }];
}


-(void) logoutWithBlock:(void (^)(NSDictionary *data, NSError *error))block
{

    // 请求参数
    NSDictionary *dic = @{};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_LOGOUT];
    
    [HttpUtil post:URLString param:dic finish:^(NSDictionary *obj, NSError *error) {
        if (error == nil) {
            block(obj,nil);

        }else{
            block(nil,error);
        }
    }];
}

-(void) getServerTimeWithBlock:(void (^)(NSDictionary *data, NSError *error))block
{

    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_SERVER_TIME];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (error == nil) {
            block(obj,nil);
        }else{
            block(nil,error);
        }
    }];
}

-(void) updateNickName
{
    NSArray *arr = @[@"fuck"];
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_NICKNAME];
    [HttpUtil post:URLString param:arr finish:^(NSDictionary *obj, NSError *error) {
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
