//
//  SignViewController.h
//  签名
//
//  Created by 谢永明 on 16/4/17.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SignViewController : BaseViewController

@property (copy, nonatomic) void(^doneBlock)(UIImage *signImage);

+ (instancetype) doneBlock:(void(^)(UIImage *signImage))block;

@end
