//
//  Config.m
//  iosapp
//
//  Created by chenhaoxiang on 11/6/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import "Config.h"

#import <SAMKeychain.h>

NSString * const kService = @"com.inforshare.qmcp";
NSString * const kAccount = @"account";
NSString * const kLogin = @"login";
NSString * const kSound = @"sound";
NSString * const kVibre = @"vibre";
NSString * const kQuickScan = @"quickScan";
NSString * const kSearch = @"search";
NSString * const kSalesOrderBindTime = @"bindTime";
NSString * const kWorkOrderTime = @"workOrderTime";
NSString * const kCommodityItemTime = @"commodityItemTime";
NSString * const kCommoditySnapshotTime = @"commoditySnapshotTime";
NSString * const kCommodityPropertyTime = @"commodityPropertyTime";
NSString * const kDatabaseVersion = @"databaseVersion";
NSString * const kWork = @"work";
NSString * const kCommodityStep = @"commodityStep";
NSString * const kPushId = @"pushId";
@implementation Config

+(void)setInitSetting{
    [self saveLoginStatus:NO];
    [self setWorkOrderTime:@""];
    [self setSaleOrderMineTime:@""];
    [self setCommodityProperty:@""];
    [self setCommodityItem:@""];
    [self setSearch:NO];
    [self setCommoditySnapshot:@""];
    [self setCommodityStep:@""];
    
}

+ (void)saveUserName:(NSString *)name andPassword:(NSString *)password{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:name ?: @"" forKey:kAccount];
    
#ifdef DEBUG
    [userDefaults setObject:password ?: @"" forKey:kService];
#else
    [SAMKeychain setPassword:password ?: @"" forService:kService account:name];
#endif
    [userDefaults synchronize];
}

+ (NSArray *)getUserNameAndPassword{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [userDefaults objectForKey:kAccount];
    
#ifdef DEBUG
    NSString *password =  [userDefaults objectForKey:kService] == nil ? @"" : [userDefaults objectForKey:kService];
    if (account) {return @[account, password];}
#else
    NSString *password = [SAMKeychain passwordForService:kService account:account] ?: @"";
    if (account) {return @[account, password];}
#endif
    
    return nil;
}

+(BOOL) getLoginStatus{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kLogin];
}
+(void) saveLoginStatus:(BOOL)login{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:login forKey:kLogin];
    [userDefaults synchronize];
}

+(void)setSound:(BOOL)on{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:on forKey:kSound];
}
+(BOOL)getSound{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user boolForKey:kSound];
}

+(void)setVibre:(BOOL)on{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:on forKey:kVibre];
}
+(BOOL)getVibre{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user boolForKey:kVibre];
}

+(void)setQuickScan:(BOOL)on{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:on forKey:kQuickScan];
}
+(BOOL)getQuickScan{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user boolForKey:kQuickScan];
}

+(void)setSearch:(BOOL)on{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:on forKey:kSearch];
}
+(BOOL)getSearch{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user boolForKey:kSearch];
}

+(void)setSaleOrderMineTime:(NSString *)lastupdateTime{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:lastupdateTime forKey:kSalesOrderBindTime];
}
+(NSString *)getSalesOrderMineTime{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:kSalesOrderBindTime];
    return str == nil ?@"":str;
}

+(void)setWorkOrderTime:(NSString *)lastupdateTime{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:lastupdateTime forKey:kWorkOrderTime];
}
+(NSString *)getWorkOrderTime{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:kWorkOrderTime];
    return str == nil ?@"":str;
}

+(void)setCommodityItem:(NSString *)lastupdateTime{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:lastupdateTime forKey:kCommodityItemTime];
}
+(NSString *)getCommodityItem{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:kCommodityItemTime];
    return str == nil ?@"":str;
}


+(void)setCommoditySnapshot:(NSString *)lastupdateTime{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:lastupdateTime forKey:kCommoditySnapshotTime];
}
+(NSString *)getCommoditySnapshot{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:kCommoditySnapshotTime];
    return str == nil ?@"":str;
}

+(void)setCommodityProperty:(NSString *)lastupdateTime{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:lastupdateTime forKey:kCommodityPropertyTime];
}
+(NSString *)getCommodityProperty{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:kCommodityPropertyTime];
    return str == nil ?@"":str;
}


+(void)setDatabaseVersion:(int)version{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setInteger:version forKey:kDatabaseVersion];
}
+(int)getDatabaseVersion{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSNumber *number = [user objectForKey:kDatabaseVersion];
    return [number intValue];
}

+(void)setWork:(BOOL)work{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:work forKey:kWork];
}
+(BOOL)isWork{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user boolForKey:kWork];
}

+(void)setCommodityStep:(NSString*)step{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:step forKey:kCommodityStep];
}
+(NSString *)getCommodityStep{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:kCommodityStep];
    return str == nil ?@"":str;
}

+(void)setPushId:(NSString *)pushId{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:pushId forKey:kPushId];
}
+(NSString *)getPushId{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:kPushId];
    return str == nil ?@"":str;
}



@end
