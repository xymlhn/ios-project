//
//  CZAccount.m
//  传智微博
//
//  Created by apple on 15-3-8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CZAccount.h"

#define ErrorMessage @"errorMessage"
#define UserOpenId @"userOpenId"
#define UserName @"userName"
#define UserNickName @"userNickName"
#define UserId @"userId"
#define IsAuthenticated @"isAuthenticated"
#define IsExecuteSuccess @"isExecuteSuccess"
@implementation CZAccount

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    CZAccount *account = [[self alloc] init];
    
    [account setValuesForKeysWithDictionary:dict];
    
    return account;
}

// 归档的时候调用：告诉系统哪个属性需要归档，如何归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_errorMessage forKey:ErrorMessage];
    [aCoder encodeObject:_userOpenId forKey:UserOpenId];
    [aCoder encodeObject:_userName forKey:UserName];
    [aCoder encodeObject:_userNickName forKey:UserNickName];
    [aCoder encodeObject:_userId forKey:UserId];
    [aCoder encodeBool:_isAuthenticated forKey:IsAuthenticated];
    [aCoder encodeBool:_isExecuteSuccess forKey:IsExecuteSuccess];
}

// 解档的时候调用：告诉系统哪个属性需要解档，如何解档

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        // 一定要记得赋值
        _errorMessage =  [aDecoder decodeObjectForKey:ErrorMessage];
        _userOpenId = [aDecoder decodeObjectForKey:UserOpenId];
        _userName = [aDecoder decodeObjectForKey:UserName];
        _userNickName = [aDecoder decodeObjectForKey:UserNickName];
        _userId = [aDecoder decodeObjectForKey:UserId];
        _isAuthenticated = [aDecoder decodeBoolForKey:IsAuthenticated];
        _isExecuteSuccess = [aDecoder decodeBoolForKey:IsExecuteSuccess];
    }
    return self;
}

@end
