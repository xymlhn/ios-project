//
//  Utils.m
//  iosapp
//
//  Created by chenhaoxiang on 14-10-16.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import "Utils.h"
#import "MBProgressHUD+Util.h"

@implementation Utils

+ (MBProgressHUD *)createHUD
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    HUD.label.font = [UIFont boldSystemFontOfSize:12];
 
    [window addSubview:HUD];
    [HUD showAnimated:YES];
    HUD.removeFromSuperViewOnHide = YES;
    
    return HUD;
}

#pragma mark - 显示图片
+(void)showImage:(UIImage *)image
{
    MBProgressHUD *HUD = [Utils createHUD];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.bezelView.color = [UIColor whiteColor];
    HUD.customView = [[UIImageView alloc] initWithImage:image];
    [HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHUD:)]];
}

#pragma mark - 二维码相关

+ (void)showQRCode:(NSString *)string
{
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

+ (void)hideHUD:(UIGestureRecognizer *)recognizer
{
    [(MBProgressHUD *)recognizer.view hideAnimated:YES];
}

+ (void)showHudTipStr:(NSString *)tipStr{
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [Utils createHUD];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.font = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabel.text = tipStr;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1.0];
    }
}

+ (UIImage *)createQRCodeFromString:(NSString *)string
{
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

+(NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

+(NSString *)formatDateWithoutTime:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

+(NSDate *)stringToDate:(NSString *)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [fmt dateFromString:date];
}

+(NSString *)saveImage:(UIImage *)image andName:(NSString *)name
{
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    else
    {
        data = UIImagePNGRepresentation(image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@/%@",documentsPath,name];
    if(![data writeToFile:filePath atomically:YES]){
        filePath = @"";
    }
    return filePath;

}

+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
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


@end
