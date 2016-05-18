//
//  BaseViewController.h
//  qmcp
//
//  Created by 谢永明 on 16/3/21.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "NSObject+LKDBHelper.h"
#import "UIColor+Util.h"
#import "PchHeader.h"
#import "MBProgressHUD.h"
#import "OSCAPI.h"
#import "HttpUtil.h"
@interface BaseWorkOrderViewController : UIViewController

@property(nonatomic, copy) NSString *workOrderCode;
@property (nonatomic,copy) NSString *workOrderStepCode;
@property (nonatomic, assign) SaveType type;

@end
