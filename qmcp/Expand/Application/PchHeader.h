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

typedef NS_ENUM(NSInteger, FuncType) {
    FuncTypeWorkOrder = 10,
    FuncTypeSalesOrder = 20,

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

typedef NS_ENUM(NSInteger, SalesOrderType) {
    SalesOrderTypeShop = 10,//到店
    SalesOrderTypeOnsite = 20,//上门
    SalesOrderTypeRemote = 30,//远程
};

typedef NS_ENUM(NSInteger, PaymentStatus) {
    PaymentStatusWaiting = 10,//待支付
    PaymentStatusSuccess = 20,//已支付
    PaymentStatusClosed = 30,//已关闭
    PaymentStatusRefunded = 100,//已退款
};

typedef NS_ENUM(NSInteger, OnSiteStatus) {
    OnSiteStatusNone = 0,//无
    OnSiteStatusWaiting = 10,//未确认
    OnSiteStatusNotDepart = 20,//未出发
    OnSiteStatusOnRoute = 30,//已出发
    OnSiteStatusArrived = 40,//已到场
};

typedef void(^CompletionHandler)(NSDictionary *dict, NSString *error);
typedef void(^CompletionStringHandler)(NSString *string, NSString *error);
typedef void(^SalesOrderCompletion)(NSMutableArray *arr, NSString *error);
#ifndef Header_h
#define Header_h

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\n %s:%d   %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, [[[NSString alloc] initWithData:[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding] UTF8String]);
#else
#define NSLog(...)
#endif

#define kShisipt 14
#define kShiwupt 15
#define kJiupt  9
#define kFontAwesomeIcon 15
#define kFontAwesomeArrow 17

#define kLineHeight @0.5
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
//常用变量
#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#define kPath_ResponseCache @"ResponseCache"
#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]
#endif /* Header_h */
