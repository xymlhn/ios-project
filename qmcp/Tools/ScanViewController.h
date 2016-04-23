//
//  ScanViewController.h
//  qmcp
//
//  Created by 谢永明 on 16/4/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController

@property (copy, nonatomic) void(^doneBlock)(NSString *textValue);

+ (instancetype) doneBlock:(void(^)(NSString *textValue))block;


@end
