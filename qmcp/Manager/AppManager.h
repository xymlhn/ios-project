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
#import "User.h"

@interface AppManager : NSObject



extern NSString *const kReloginNotification;

+ (AppManager *) getInstance;
/**
 *  系统登出
 *
 *  @param viewController 当前控制器
 */
-(void) logoutWithBlock:(CompletionHandler)block;
/**
 *  系统登入
 *
 *  @param viewController 当前控制器
 *  @param userName       用户名
 *  @param password       密码
 */
-(void) loginWithUserName:(NSString *)userName andPassword:(NSString *)password finishBlock:(CompletionHandler)completion;

/**
 *  获取服务器时间
 *
 *  @param block 时间与错误信息
 */
-(void) getServerTimeWithBlock:(void (^)(NSDictionary *data, NSString *error))completion;

/**
 *  处理服务器响应信息头
 *
 *  @param session session description
 *
 *  @return bool
 */
-(BOOL) handleHeader:(NSURLSessionDataTask *) session;

/**
 *  更新用户昵称
 */
-(void) updateNickName;

/**
 *  推送个推id
 *
 *  @param pushId id
 */
-(void) pushId:(NSString *)pushId;

/**
 *  重登录
 *
 *  @param userName 用户名
 *  @param password 密码
 *  @param isFirst  是否首次重登陆

 */
-(void)reLoginWithUserName:(NSString *)userName andPassword:(NSString *)password finishBlock:(CompletionHandler)completion;

/**
 *  设置当前用户
 *
 *  @param user 用户model
 */
-(void)setUser:(User *)user;

/**
 *  获取当前用户
 *
 *  @return 用户model
 */
-(User *)getUser;

/**
 *  退出时清理当前登录用户使用数据
 */
-(void)clearUserDataWhenLogout;

@end
