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

@property (nonatomic, copy) NSString *key;

+ (instancetype)initWithImageKey:(NSString *)key doneBlock:(void(^)(NSString *textValue))block;
- (instancetype)initWithImageURL:(NSURL *)imageURL;

@end
