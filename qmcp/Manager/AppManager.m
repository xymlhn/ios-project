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
            [self reLoginWithUserName:name andPassword:password finishBlock:^(id data, NSString *error) {
                if(error){
                    [Utils showHudTipStr:@"重登陆失败，请手动登录！"];
                }
            }];
        }
    }
    return failure;
}

-(void)reLoginWithUserName:(NSString *)userName andPassword:(NSString *)password finishBlock:(void (^)(id, NSString *))block
{
    NSDictionary *dic = @{ @"user":userName,@"pwd":password};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_LOGIN];

    [HttpUtil postFormData:URLString param:dic finish:^(NSDictionary *obj, NSString *error) {
        block(obj,error);
    }];
  
}

-(void)loginWithUserName:(NSString *)userName andPassword:(NSString *)password finishBlock:(void (^)(id data, NSString *error))block{
    // 请求参数
    NSDictionary *dic = @{ @"user":userName,@"pwd":password};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_LOGIN];

    [HttpUtil postFormData:URLString param:dic finish:^(NSDictionary *obj, NSString *error) {
        block(obj,error);
    }];
}


-(void) logoutWithBlock:(void (^)(NSDictionary *data, NSString *error))block
{

    // 请求参数
    NSDictionary *dic = @{};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_LOGOUT];
    
    [HttpUtil post:URLString param:dic finish:^(NSDictionary *obj, NSString *error) {
        if (error == nil) {
            block(obj,nil);

        }else{
            block(nil,error);
        }
    }];
}

-(void) getServerTimeWithBlock:(void (^)(NSDictionary *data, NSString *error))block
{

    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_SERVER_TIME];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
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
    [HttpUtil post:URLString param:arr finish:^(NSDictionary *obj, NSString *error) {
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
    [HttpUtil post:URLString param:dict finish:^(NSDictionary *obj, NSString *error) {
        if (error == nil) {
            NSLog(@"success");
            
        }else{
            
        }
    }];
}

@end
