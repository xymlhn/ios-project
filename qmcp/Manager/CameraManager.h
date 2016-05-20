//
//  CameraManager.h
//  qmcp
//
//  Created by 谢永明 on 16/5/14.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CameraData;
@interface CameraManager : NSObject

extern NSString *const kCameraNotification;

+ (CameraManager*) getInstance;

/**
 *  获取系统所有摄像头
 */
-(void)getAllCamera;

/**
 *  获取当前工单摄像头
 *
 *  @param workOrderCode 工单code
 */
-(void)getCurrentCamera:(NSString *)workOrderCode;

/**
 *  切换当前工单摄像头
 *
 *  @param workOrderCode 工单code
 *  @param cameraCode    摄像头code
 *  @param ison          开关状态
 */
-(void)switchCamera:(NSString *)workOrderCode cameraCode:(NSString *)cameraCode isOn:(bool)isOn needOpen:(bool)open;


/**
 *  缓存需要打开的摄像头
 *
 *  @param needOpenCamera 摄像头model
 */
-(void)setNeedOpenCamera:(CameraData *)needOpenCamera;
@end
