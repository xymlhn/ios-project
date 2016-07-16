//
//  CheckBoxViewController.h
//  qmcp
//
//  Created by 谢永明 on 16/7/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseViewController.h"

@interface CheckBoxViewController : BaseViewController

@property (nonatomic, strong) NSArray<NSString *> *valueList;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *statusList;
@property (copy, nonatomic) void(^doneBlock)(NSString *textValue);

+ (instancetype) doneBlock:(void(^)(NSString *textValue))block;
@end
