//
//  Attachment.h
//  qmcp
//
//  Created by 谢永明 on 16/4/5.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Attachment : NSObject

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) NSString *workOrderStepCode;

@property (nonatomic, assign) BOOL isUpload;

@property (nonatomic, copy) NSString *itemSnapShotId;

@property (nonatomic, copy) NSString *workOrderCode;

@property (nonatomic, copy) NSString *salesOrderCode;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, assign) int sort;

@property (nonatomic, assign) int type;

@property (nonatomic, assign) BOOL isPlus;

@end
