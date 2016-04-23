//
//  ScanImageViewController.h
//  二维码生成与扫描
//
//  Created by 周鑫 on 15/11/7.
//  Copyright © 2015年 chris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QrCodeViewController : UIViewController

@property (copy, nonatomic) void(^doneBlock)(NSString *textValue);

+ (instancetype) doneBlock:(void(^)(NSString *textValue))block;

@end
