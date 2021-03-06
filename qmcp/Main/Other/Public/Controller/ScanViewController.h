//
//  ScanViewController.h
//  手输二维码
//
//  Created by 谢永明 on 16/4/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ScanViewController : BaseViewController

@property (copy, nonatomic) void(^doneBlock)(NSString *textValue);

+ (instancetype) doneBlock:(void(^)(NSString *textValue))block;


@end
