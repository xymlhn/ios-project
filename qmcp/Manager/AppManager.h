//
//  AppManager.h
//  qmcp
//
//  Created by 谢永明 on 16/3/4.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD+Util.h"

typedef NS_ENUM(NSInteger, ExceptionType) {
    ExceptionTypeNotLogin = 10,
    ExceptionTypeNoPermission = 20,
    ExceptionTypeNOUrl = 30,
    ExceptionTypeCommon = 100,
    ExceptionTypeSalesOrderStatus = 10000,
    ExceptionTypeWorkOrderStatus = 10001,
    
};

@interface AppManager : NSObject

+ (AppManager *) getInstance;
/**
 *  系统登出
 *
 *  @param viewController 当前控制器
 */
-(void) logout:(UIViewController *)viewController;
/**
 *  系统登入
 *
 *  @param viewController 当前控制器
 *  @param userName       用户名
 *  @param password       密码
 */
-(void) login:(UIViewController *)viewController userName:(NSString *)userName password:(NSString *)password;

-(void) getServerTime;

-(BOOL) handleHeader:(NSURLSessionDataTask *) session;

-(void) updateNickName;

-(void) pushId:(NSString *)pushId;

-(void)reLogin:(NSString *)userName password:(NSString *)password isFirst:(BOOL)isFirst;

@end
