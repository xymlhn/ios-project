//
//  ImageViewerController.h
//  iosapp
//
//  Created by chenhaoxiang on 11/12/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewerController : UIViewController

@property (copy, nonatomic) void(^doneBlock)(NSString *textValue);


+ (instancetype)initWithImageKey:(NSString *)key isHide:(BOOL)hideDel doneBlock:(void(^)(NSString *textValue))block;
+ (instancetype)initWithImageUrl:(NSURL *)url isHide:(BOOL)hideDel doneBlock:(void(^)(NSString *textValue))block;

@end
