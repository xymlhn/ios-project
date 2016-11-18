//
//  CameraManager.h
//  qmcp
//
//  Created by 谢永明 on 16/5/14.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PchHeader.h"
@class CameraData;
@interface CameraManager : NSObject

extern NSString *const kCameraNotification;

+ (CameraManager*) getInstance;

/**
 *  获取系统所有摄像头
 */
-(void)getAllSystemCamera;


/**
 *  切换当前摄像头
 *
 *  @param workOrderCode 工单code
 *  @param cameraCode    摄像头code
 *  @param ison          开关状态
 */
-(void)switchCameraByCode:(NSString *)code
                    withCameraCode:(NSString *)cameraCode
                       andFuncType:(FuncType)funcType
                      cameraStatus:(bool)isOn
                       finishBlock:(CompletionHandler)completion;


/**
 *  获取当前门店所有摄像头
 *
 *  @return 摄像头数组
 */
-(NSMutableArray<CameraData *> *)getAllCameraData;
@end
