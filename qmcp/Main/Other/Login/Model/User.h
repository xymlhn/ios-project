//
//  CZAccount.h
//  传智微博
//
//  Created by apple on 15-3-8.
//  Copyright (c) 2015年 apple. All rights reserved.
//


#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, CooperationMode) {
    CooperationModeTeam = 10,//团队模式
    CooperationModeSingle = 20,//单人模式
};
@interface User : NSObject <NSCoding>

@property (nonatomic, copy) NSString *errorMessage;

@property (nonatomic, copy) NSString *userOpenId;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userNickName;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) Boolean authenticated;

@property (nonatomic, assign) CooperationMode cooperationMode;

@end
