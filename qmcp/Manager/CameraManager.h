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
-(void)getAllSystemCamera;

/**
 *  获取当前工单摄像头
 *
 *  @param workOrderCode 工单code
 */
-(void)getCurrentCameraByWorkOrderCode:(NSString *)workOrderCode finishBlock:(void (^)(NSDictionary *, NSString *))block;

/**
 *  切换当前工单摄像头
 *
 *  @param workOrderCode 工单code
 *  @param cameraCode    摄像头code
 *  @param ison          开关状态
 */
-(void)switchCameraByWorkOrderCode:(NSString *)workOrderCode withCameraCode:(NSString *)cameraCode cameraStatus:(bool)isOn finishBlock:(void (^)(NSDictionary *, NSString *))block;

/**
 *  获取当前门店所有摄像头
 *
 *  @return 摄像头数组
 */
-(NSMutableArray<CameraData *> *)getAllCameraData;
@end
