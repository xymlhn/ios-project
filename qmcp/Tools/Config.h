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
 *  用户登出时初始化所有设置
 */
+(void)setInitSetting;
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

//声音
+ (void)setSound:(BOOL)on;
+(BOOL)getSound;

//震动
+(void)setVibre:(BOOL)on;
+(BOOL)getVibre;

//快速扫描
+(void)setQuickScan:(BOOL)on;
+(BOOL)getQuickScan;

//搜索是否包含历史工单
+(void)setSearch:(BOOL)on;
+(BOOL)getSearch;

//绑单更新时间
+(void)setSaleOrderBindTime:(NSString *)lastupdateTime;
+(NSString *)getSalesOrderBindTime;

//工单更新时间
+(void)setWorkOrderTime:(NSString *)lastupdateTime;
+(NSString *)getWorkOrderTime;

//抢单更新时间
+(void)setSalesOrderGrabTime:(NSString *)lastupdateTime;
+(NSString *)getSalesOrderGrabTime;

//物品组合更新时间
+(void)setCommodityItem:(NSString *)lastupdateTime;
+(NSString *)getCommodityItem;

//物品属性更新时间
+(void)setCommodityProperty:(NSString *)lastupdateTime;
+(NSString *)getCommodityProperty;

@end
