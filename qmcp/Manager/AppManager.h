//
//  AppManager.h
//  qmcp
//
//  Created by 谢永明 on 16/3/4.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD+Util.h"
#import "PchHeader.h"

@interface AppManager : NSObject

+ (AppManager *) getInstance;
/**
 *  系统登出
 *
 *  @param viewController 当前控制器
 */
-(void) logoutWithBlock:(void (^)(NSDictionary *data, NSError *error))block;
/**
 *  系统登入
 *
 *  @param viewController 当前控制器
 *  @param userName       用户名
 *  @param password       密码
 */
-(void) login:(NSString *)userName password:(NSString *)password andBlock:(void (^)(id data, NSError *error))block;

-(void) getServerTimeWithBlock:(void (^)(NSDictionary *data, NSError *error))block;

-(BOOL) handleHeader:(NSURLSessionDataTask *) session;

-(void) updateNickName;

-(void) pushId:(NSString *)pushId;

-(void)reLogin:(NSString *)userName password:(NSString *)password isFirst:(BOOL)isFirst;

@end
