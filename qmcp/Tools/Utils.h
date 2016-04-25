//
//  Utils.h
//  iosapp
//
//  Created by chenhaoxiang on 14-10-16.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface Utils : NSObject

+ (MBProgressHUD *)createHUD;

/**
 *  弹出一个二维码hub
 *
 *  @param string 字符串
 */
+ (void)showQRCode:(NSString *)string;

/**
 *  格式化时间输出格式为 yyyy-MM-dd hh:mm:ss
 *
 *  @param date 时间
 *
 *  @return 时间字符串
 */
+(NSString *)formatDate:(NSDate *)date;

/**
 *  将格式为yyyy-MM-dd hh:mm:ss的时间转为NSDate
 *
 *  @param date 时间字符串
 *
 *  @return NSDate
 */
+(NSDate *)stringToDate:(NSString *)date;

/**
 *  显示图片对话框
 *
 *  @param image 图片
 */
+(void)showImage:(UIImage *)image;

+(NSString *)saveImage:(UIImage *)image andName:(NSString *)name;

+ (void)showHudTipStr:(NSString *)tipStr;
@end
