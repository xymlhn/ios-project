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

+ (instancetype)initWithImageKey:(NSString *)key doneBlock:(void(^)(NSString *textValue))block;
+ (instancetype)initWithImageKey:(NSString *)key showDelete:(BOOL)show;
- (instancetype)initWithImageURL:(NSURL *)imageURL showDelete:(BOOL)show;

@end
