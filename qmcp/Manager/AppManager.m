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
#import "QMCPAPI.h"
#import "User.h"
#import "RootViewController.h"
#import "Config.h"
#import "Utils.h"
#import "HttpUtil.h"
#import "MJExtension.h"
#import "User.h"
#import "WorkOrder.h"
#import "SalesOrderSnapshot.h"
#import "NSObject+LKDBHelper.h"
#import "WorkOrderManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TMCache.h"

NSString *const kReloginNotification = @"reLogin";
NSString *const kUserCache = @"user";

@interface AppManager()
@property (nonatomic,strong) User* us;
@property(nonatomic,strong)NSMutableArray<WorkOrder *> *workOrders;
@end
@implementation AppManager

+ (AppManager *)getInstance {
    static AppManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
        shared_manager.us = [[TMCache sharedCache]objectForKey:kUserCache];
    });
    return shared_manager;
}

-(BOOL)handleHeader:(NSURLSessionDataTask *) session{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)session.response;
    NSDictionary *dic = response.allHeaderFields;
    
    id failure = [dic valueForKey:@"failure"];
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

-(void)clearUserDataWhenLogout{
    [Config setInitSetting];
    [[TMCache sharedCache]setObject:nil forKey:kUserCache];
    [[AppManager getInstance] setUser:nil];
}

-(void)setUser:(User *)user{
    _us = user;
}
-(User *)getUser{

    return _us;
}


-(void)reLoginWithUserName:(NSString *)userName
               andPassword:(NSString *)password
               finishBlock:(CompletionHandler)completion{
    NSDictionary *dic = @{ @"user":userName,@"pwd":password};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_LOGIN];

    [HttpUtil postFormData:URLString param:dic finish:^(NSDictionary *obj, NSString *error) {
        completion(obj,error);
    }];
  
}

-(void)loginWithUserName:(NSString *)userName
             andPassword:(NSString *)password
             finishBlock:(CompletionHandler)completion{
    // 请求参数
    NSDictionary *dic = @{ @"user":userName,@"pwd":password};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_LOGIN];

    [HttpUtil postFormData:URLString param:dic finish:^(NSDictionary *obj, NSString *error) {
        completion(obj,error);
    }];
}


-(void)logoutWithBlock:(void (^)(NSDictionary *data, NSString *error))block{
    // 请求参数
    NSDictionary *dic = @{};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_LOGOUT];
    
    [HttpUtil post:URLString param:dic finish:^(NSDictionary *obj, NSString *error) {
        if (error == nil) {
            block(obj,nil);

        }else{
            block(nil,error);
        }
    }];
}

-(void) getServerTimeWithBlock:(CompletionHandler)completion{

    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_SERVER_TIME];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if (error == nil) {
            completion(obj,nil);
        }else{
            completion(nil,error);
        }
    }];
}

-(void) updateNickName{
    NSArray *arr = @[@"fuck"];
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_NICKNAME];
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
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_PUSHID];
    [HttpUtil post:URLString param:dict finish:^(NSDictionary *obj, NSString *error) {
        if (error == nil) {
            NSLog(@"success");
            
        }else{
            
        }
    }];
}

-(void)getImageUrlByKey:(NSString *)key
                andType:(int)type
            finishBlock:(CompletionHandler)completion{
    NSArray *array = @[key];
    NSString *jsonString = [array mj_JSONString];
    NSDictionary *dic = @{ @"storageType":[NSNumber numberWithInt:type],@"attachmentNames":jsonString};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_IMAGEURL];
    
    [HttpUtil postFormData:URLString param:dic finish:^(NSDictionary *obj, NSString *error) {
        completion(obj,error);
    }];
}

-(void)getUserIconUrlByUserOpenId:(NSString *)userOpenId finishBlock:(CompletionHandler)completion{

    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_USERICONURL,userOpenId];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        completion(obj,error);
    }];
}

@end
