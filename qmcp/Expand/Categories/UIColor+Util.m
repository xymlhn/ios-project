//
//  UIColor+Util.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-18.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)

#pragma mark - Hex

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

// Returns a UIColor by scanning the string for a hex number and passing that to +[UIColor colorWithRGBHex:]
// Skips any leading whitespace and ignores any trailing characters
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}


#pragma mark - theme colors

+ (UIColor *)mainTextColor{
    return [UIColor colorWithRed:85.0/255 green:85.0/255 blue:85.0/255 alpha:1.0];
}

+ (UIColor *)arrowColor{
    return [UIColor colorWithRed:119.0/255 green:119.0/255 blue:119.0/255 alpha:1.0];
}

+ (UIColor *)appBlueColor{
    return [UIColor colorWithRed:33.0/255 green:150.0/255 blue:243.0/255 alpha:1.0];
}

+ (UIColor *)themeColor
{
    return [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0];
}

+ (UIColor *)nameColor
{
    return [UIColor colorWithRed:46.0/255 green:145.0/255 blue:234.0/255 alpha:1.0];
}

+ (UIColor *)titleColor
{
    return [UIColor blackColor];
}

+ (UIColor *)separatorColor
{
    return [UIColor colorWithRed:217.0/255 green:217.0/255 blue:223.0/255 alpha:1.0];
}

+ (UIColor *)cellsColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)titleBarColor
{
    return [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0];
}

+ (UIColor *)contentTextColor
{
    return [UIColor colorWithHex:0x272727];
}


+ (UIColor *)selectTitleBarColor
{
    return [UIColor colorWithHex:0xE1E1E1];
}

+ (UIColor *)navigationbarColor
{
    return [UIColor colorWithHex:0x15A230];//0x009000
}

+ (UIColor *)selectCellSColor
{
    return [UIColor colorWithRed:203.0/255 green:203.0/255 blue:203.0/255 alpha:1.0];
}

+ (UIColor *)labelTextColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)teamButtonColor
{
    return [UIColor colorWithRed:251.0/255 green:251.0/255 blue:253.0/255 alpha:1.0];
}

+ (UIColor *)infosBackViewColor
{
    return [UIColor clearColor];
}

+ (UIColor *)lineColor
{
    return [UIColor colorWithHex:0x2bc157];
}

+ (UIColor *)borderColor
{
    return [UIColor lightGrayColor];
}

+ (UIColor *)refreshControlColor
{
    return [UIColor colorWithHex:0x21B04B];
}

@end
