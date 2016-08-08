//
//  Header.h
//  qmcp
//
//  Created by 谢永明 on 16/4/23.
//  Copyright © 2016年 inforshare. All rights reserved.
//
typedef NS_ENUM(NSInteger, SaveType) {
    SaveTypeAdd = 10,
    SaveTypeDelete = 20,
    SaveTypeUpdate = 30,
};

typedef NS_ENUM(NSInteger, ExceptionType) {
    ExceptionTypeNone = 0,
    ExceptionTypeNotLogin = 10,
    ExceptionTypeNoPermission = 20,
    ExceptionTypeNOUrl = 30,
    ExceptionTypeCommon = 100,
    ExceptionTypeSalesOrderStatus = 10000,
    ExceptionTypeWorkOrderStatus = 10001,
    
};
typedef void(^CompletionHandler)(NSDictionary *dict, NSString *error);
#ifndef Header_h
#define Header_h

#define kEndSucceedDelayTime 0.5
#define kEndFailedDelayTime 1.5
#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kPaddingLeftWidth 15.0
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kScaleFrom_iPhone5_Desgin(_X_) (_X_ * (kScreen_Width/320))

#endif /* Header_h */
