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
 */
+(BOOL)saveImage:(UIImage *)image andName:(NSString *)name;

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
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;


/**
 *   根据图片名获取图片
 *
 *  @param imageName 图片名字
 *
 *  @return 图片
 */
+ (UIImage*)loadImage:(NSString *)imageName;

/**
 *  根据图片名删除document目录图片
 *
 *  @param imageName 图片名
 *
 *  @return 结果
 */
+(BOOL)deleteImage:(NSString *)imageName;


/**
 判断是否是手机号码

 @param mobileNum 手机号码

 @return bool
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum ;


/**
 判断文字是否是空

 @param text 输入文字

 @return bool
 */
+(BOOL)isTextNull:(NSString *)text;


/**
 判断金钱是否合法

 @param money 金钱
 @param textField 输入框
 */
+ (void)validMoney:(NSString *)money textField:(UITextField *)textField;

/**
 颜色转换为背景图片

 @param color 颜色
 @return 背景
 */
+ (UIImage *)imageWithColor:(UIColor *)color ;

@end
