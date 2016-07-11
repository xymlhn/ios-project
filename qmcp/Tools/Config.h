//
//  Config.h
//  iosapp
//
//  Created by chenhaoxiang on 11/6/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Config : NSObject

/**
 *  保存账号密码
 *
 *  @param account  账号
 *  @param password 密码
 */
+ (void)saveOwnAccount:(NSString *)account andPassword:(NSString *)password;

/**
 *  获取登录账户跟密码
 *
 *  @return 账号密码数组
 */
+ (NSArray *)getOwnAccountAndPassword;

/**
 *  设置登录状态
 *
 *  @param login bool
 */
+ (void) saveLoginStatus:(BOOL) login;

/**
 *  是否登录
 *
 *  @return bool
 */
+ (BOOL) getLoginStatus;

+(void)setInitSetting;

+ (void)setSound:(BOOL)on;
+(BOOL)getSound;

+(void)setVibre:(BOOL)on;
+(BOOL)getVibre;

+(void)setQuickScan:(BOOL)on;
+(BOOL)getQuickScan;

+(void)setSearch:(BOOL)on;
+(BOOL)getSearch;

+(void)setSaleOrderBindTime:(NSString *)lastupdateTime;
+(NSString *)getSalesOrderBindTime;

+(void)setWorkOrderTime:(NSString *)lastupdateTime;
+(NSString *)getWorkOrderTime;


+(void)setSalesOrderGrabTime:(NSString *)lastupdateTime;
+(NSString *)getSalesOrderGrabTime;

+(void)setCommodityItem:(NSString *)lastupdateTime;
+(NSString *)getCommodityItem;

+(void)setCommodityProperty:(NSString *)lastupdateTime;
+(NSString *)getCommodityProperty;

@end
