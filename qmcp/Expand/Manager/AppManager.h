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

extern NSString *const kReloginNotification;  //登录通知

+ (AppManager *) getInstance;

/**
 *  获取服务器时间
 *
 *  @param block 时间与错误信息
 */
-(void) getServerTimeWithBlock:(void (^)(NSDictionary *data, NSString *error))completion;


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
-(void)reLoginWithUserName:(NSString *)userName
               andPassword:(NSString *)password
               finishBlock:(CompletionHandler)completion;

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

/**
 *  根据key获取图片url
 *
 *  @param key  key
 *  @param type 存储类型
 *
 
 */
-(void)getImageUrlByKey:(NSString *)key
                andType:(int)type
            finishBlock:(CompletionHandler)completion;

/**
 *  根据用户userOpenid获取图片url
 *
 *  @param userOpenId userOPenid
 *  @param completion 回调
 */
-(void)getUserIconUrlByUserOpenId:(NSString *)userOpenId
                      finishBlock:(CompletionHandler)completion;


@end
