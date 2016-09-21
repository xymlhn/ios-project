//
//  CameraData.h
//  qmcp
//
//  Created by 谢永明 on 16/5/14.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraData : NSObject

@property (nonatomic,copy) NSString *cameraCode;
@property (nonatomic,copy) NSString *cameraLocation;
@property (nonatomic,copy) NSString *cameraDescription;
@property (nonatomic,copy) NSString *rtmpUrl;
@property (nonatomic,copy) NSString *m3u8Url;
@property (nonatomic,assign) bool isChoose;


@end
