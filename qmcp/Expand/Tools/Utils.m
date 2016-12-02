//
//  Utils.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-16.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "Utils.h"
#import "MBProgressHUD+Util.h"
#import "SDImageCache.h"
#import "PchHeader.h"

@implementation Utils

+ (MBProgressHUD *)createHUD{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    HUD.userInteractionEnabled = NO;
    [window addSubview:HUD];
    [HUD showAnimated:YES];
    HUD.removeFromSuperViewOnHide = YES;
    
    return HUD;
}

#pragma mark - 显示图片
+(void)showImage:(UIImage *)image{
    
    MBProgressHUD *HUD = [Utils createHUD];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.bezelView.color = [UIColor whiteColor];
    HUD.customView = [[UIImageView alloc] initWithImage:image];
    [HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHUD:)]];
}

#pragma mark - 二维码相关

+ (void)showQRCode:(NSString *)string{
    
    MBProgressHUD *HUD = [Utils createHUD];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.bezelView.color = [UIColor whiteColor];
    HUD.label.text = @"扫一扫上面的二维码";
    HUD.label.font = [UIFont systemFontOfSize:13];
    HUD.label.textColor = [UIColor grayColor];
    UIImage *myQRCode = [Utils createQRCodeFromString:string];
    HUD.customView = [[UIImageView alloc] initWithImage:myQRCode];
    [HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHUD:)]];
}

+ (void)hideHUD:(UIGestureRecognizer *)recognizer{
    
    [(MBProgressHUD *)recognizer.view hideAnimated:YES];
    
}

+ (void)showHudTipStr:(NSString *)tipStr{
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [Utils createHUD];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.font = [UIFont boldSystemFontOfSize:12.0];
        hud.detailsLabel.text = tipStr;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1.0];
    }
}

+ (UIImage *)createQRCodeFromString:(NSString *)string{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *QRFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [QRFilter setValue:stringData forKey:@"inputMessage"];
    [QRFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CGFloat scale = 5;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:QRFilter.outputImage fromRect:QRFilter.outputImage.extent];
    
    //Scale the image usign CoreGraphics
    CGFloat width = QRFilter.outputImage.extent.size.width * scale;
    UIGraphicsBeginImageContext(CGSizeMake(width, width));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //Cleaning up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
    return image;
}

+ (NSString *)timeInfoWithDateString:(NSString *)dateString {
    // 把日期字符串格式化为日期对象
    NSDate *date = [self stringToDate:dateString];
    NSDate *curDate = [NSDate new];
    NSTimeInterval time = -[date timeIntervalSinceDate:curDate];
    NSTimeInterval retTime = 1.0;
    // 小于一小时
    if (time < 3600) {
        retTime = time / 60;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f分钟前", retTime];
    }
    // 小于一天，也就是今天
    else if (time < 33600 * 24) {
        retTime = time / 3600;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f小时前", retTime];
    }
    // 昨天
    else if (time < 33600 * 224 * 2) {
        return @"昨天";
    }else{
        return dateString;
    }
}

+(NSString *)formatDate:(NSDate *)date{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[NSLocale currentLocale]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [df stringFromDate:date];
    return string;
}

+(NSString *)formatDateWithoutTime:(NSDate *)date{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[NSLocale currentLocale]];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [df stringFromDate:date];
    return string;
}

+(NSDate *)stringToDate:(NSString *)string{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[NSLocale currentLocale]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [df dateFromString:string];
    return date;
}

+(BOOL)saveImage:(UIImage *)image andName:(NSString *)name{
    BOOL result = YES;
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    else
    {
        data = UIImagePNGRepresentation(image);
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:name] ];
    
    if(![data writeToFile:filePath atomically:YES]){
        result = NO;
    }
    return result;

}

+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*)loadImage:(NSString *)imageName{
    if(imageName == nil){
        return [UIImage imageNamed:@"default－portrait"];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString: imageName] ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
    
}

+(BOOL)deleteImage:(NSString *)imageName{
    BOOL result = YES;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString: imageName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        NSError *error;
        if ([fileManager removeItemAtPath:path error: & error] != YES){
            [self showHudTipStr:@"删除图片失败!"];
            result = NO;
        }
    }
    return result;
}


// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}

+(BOOL)isTextNull:(NSString *)text{
    return text == nil || [text isEqualToString:@""];
}


+ (void)validMoney:(NSString *)money textField:(UITextField *)textField{
    static NSInteger const maxIntegerLength = 10;//最大整数位
    static NSInteger const maxFloatLength=2;//最大精确到小数位
    if (money.length) {
        //第一个字符处理
        //第一个字符为0,且长度>1时
        if ([[money substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
            if (money.length > 1) {
                if ([[money substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"0"]) {
                    //如果第二个字符还是0,即"00",则无效,改为"0"
                    textField.text = @"0";
                }else if (![[money substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"."]){
                    //如果第二个字符不是".",比如"03",清除首位的"0"
                    textField.text=[money substringFromIndex:1];
                }
            }
        }
        //第一个字符为"."时,改为"0."
        else if ([[money substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"."]){
            textField.text=@"0.";
        }
        //2个以上字符的处理
        NSRange pointRange = [money rangeOfString:@"."];
        NSRange pointsRange = [money rangeOfString:@".."];
        if (pointsRange.length > 0) {
            //含有2个小数点
            textField.text=[money substringToIndex:money.length - 1];
        }
        else if (pointRange.length > 0){
            //含有1个小数点时,并且已经输入了数字,则不能再次输入小数点
            if ((pointRange.location != money.length-1) && ([[money substringFromIndex:money.length - 1] isEqualToString:@"."])) {
                money = [money substringToIndex:money.length - 1];
                textField.text = money;
            }
            if (pointRange.location + maxFloatLength < money.length) {
                //输入位数超出精确度限制,进行截取
                textField.text = [money substringToIndex:pointRange.location+maxFloatLength+1];
            }
        }
        else{
            if (money.length > maxIntegerLength) {
                textField.text = [money substringToIndex:maxIntegerLength];
            }
        }
        
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
