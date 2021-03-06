//
//  CameraManager.m
//  qmcp
//
//  Created by 谢永明 on 16/5/14.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "CameraManager.h"
#import "QMCPAPI.h"
#import "HttpUtil.h"
#import "Utils.h"
#import "CameraData.h"
#import "NSObject+LKDBHelper.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"

NSString *const kCameraNotification = @"salesOrderGrabUpdate";

@interface CameraManager()
@property (nonatomic, strong) NSMutableArray<CameraData *> *allCameraArr;
@property (nonatomic, strong) NSDictionary *cameraDict;
@end

@implementation CameraManager

+ (CameraManager *)getInstance {
    static CameraManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
        shared_manager.allCameraArr = [NSMutableArray new];
    });
    return shared_manager;
}

- (NSMutableArray<CameraData *> *)getAllCameraData{
    if(!_cameraDict){
        _cameraDict = [_allCameraArr mj_keyValues];
    }

    return [CameraData mj_objectArrayWithKeyValuesArray:_cameraDict];
}


-(void)getAllSystemCamera{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_ALL_CAMERA];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            NSMutableArray<CameraData *> *arr = [CameraData mj_objectArrayWithKeyValuesArray:obj];
            if(!arr || arr.count == 0){
                [Utils showHudTipStr:@"当前门店没有摄像头!"];
            }else{
                _allCameraArr = arr;
            }
            
        }else{
            [Utils showHudTipStr:error];
        }
    }];
}


-(void)switchCameraByCode:(NSString *)code
                    withCameraCode:(NSString *)cameraCode
                       andFuncType:(FuncType)funcType
                      cameraStatus:(bool)isOn finishBlock:(CompletionHandler)completion{
    NSString *URLString;
    if (funcType == FuncTypeWorkOrder) {
        URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_CAMERA_WORKORDER_SWITCH];
    }else{
        URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_CAMERA_SALESORDER_SWITCH];
    }
    
    NSDictionary *jsonDict = @{@"targetCode":code,@"cameraCode":cameraCode,@"turnOn":[NSNumber numberWithBool:isOn]};
    [HttpUtil post:URLString param:jsonDict finish:^(NSDictionary *obj, NSString *error) {
        completion(obj,error);
    }];
}



@end
