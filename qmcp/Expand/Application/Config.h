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
+ (void)saveUserName:(NSString *)name andPassword:(NSString *)password;

/**
 *  获取登录账户跟密码
 *
 *  @return 账号密码数组
 */
+ (NSArray *)getUserNameAndPassword;

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
+(void)setSaleOrderMineTime:(NSString *)lastupdateTime;
+(NSString *)getSalesOrderMineTime;

//工单更新时间
+(void)setWorkOrderTime:(NSString *)lastupdateTime;
+(NSString *)getWorkOrderTime;

//物品组合更新时间
+(void)setCommodityItem:(NSString *)lastupdateTime;
+(NSString *)getCommodityItem;

//物品属性更新时间
+(void)setCommodityProperty:(NSString *)lastupdateTime;
+(NSString *)getCommodityProperty;

//服务更新时间
+(void)setCommoditySnapshot:(NSString *)lastupdateTime;
+(NSString *)getCommoditySnapshot;

//数据库版本
+(void)setDatabaseVersion:(int)version;
+(int)getDatabaseVersion;

//上下班
+(void)setWork:(BOOL)work;
+(BOOL)isWork;

//个推id
+(void)setPushId:(NSString *)pushId;
+(NSString *)getPushId;

//服务常用步骤
+(void)setCommodityStep:(NSString*)step;
+(NSString *)getCommodityStep;
@end
