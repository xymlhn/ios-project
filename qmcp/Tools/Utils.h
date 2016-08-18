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
 *  格式化时间输出格式为yyyy-mm-dd
 *
 *  @param date date时间
 *
 *  @return 时间字符串
 */
+(NSString *)formatDateWithoutTime:(NSDate *)date;

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

/**
 *  保存图片到沙盒
 *
 *  @param image 图片
 *  @param name  名字
 *
 *  @return 路径
 */
+(NSString *)saveImage:(UIImage *)image andName:(NSString *)name;

/**
 *  弹出一段文字
 *
 *  @param tipStr 需要提示文字
 */
+ (void)showHudTipStr:(NSString *)tipStr;


/**
 *  根据文字弹出二维码
 *
 *  @param string 内容
 *
 *  @return 二维码图片
 */
+ (UIImage *)createQRCodeFromString:(NSString *)string;

/**
 *  图片等比压缩
 *
 *  @param sourceImage 图片源
 *  @param size        压缩系数
 *
 *  @return 图片
 */
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;


/**
 *  图片固定比例压缩
 *
 *  @param img  图片源
 *  @param size 比例
 *
 *  @return 图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;


/**
 *  删除response的cache
 *
 *  @return bool
 */
+ (BOOL) deleteResponseCache;

/**
 *  获取response的cache的size
 *
 *  @return 大小
 */
+ (NSUInteger)getResponseCacheSize;

@end
