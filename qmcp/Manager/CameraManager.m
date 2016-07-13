//
//  CameraManager.m
//  qmcp
//
//  Created by 谢永明 on 16/5/14.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "CameraManager.h"
#import "OSCAPI.h"
#import "HttpUtil.h"
#import "Utils.h"
#import "CameraData.h"
#import "NSObject+LKDBHelper.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"

NSString *const kCameraNotification = @"salesOrderGrabUpdate";

@interface CameraManager()
@property (nonatomic, strong) NSMutableArray<CameraData *> *allCameraArr;

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

- (NSMutableArray<CameraData *> *)getAllCameraData
{
    NSMutableDictionary *temp = [_allCameraArr mj_keyValues];
    NSMutableArray<CameraData *> *arr = [CameraData mj_objectArrayWithKeyValuesArray:temp];
    return arr;
}


-(void)getAllSystemCamera{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_ALL_CAMERA];
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

-(void)getCurrentCameraByWorkOrderCode:(NSString *)workOrderCode finishBlock:(void (^)(NSDictionary *, NSString *))block
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_ALL_CAMERA,workOrderCode];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        block(obj,error);
    }];
}

-(void)switchCameraByWorkOrderCode:(NSString *)workOrderCode withCameraCode:(NSString *)cameraCode cameraStatus:(bool)isOn finishBlock:(void (^)(NSDictionary *, NSString *))block{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_CAMERA_SWITCH];
    NSDictionary *jsonDict = @{@"workOrderCode":workOrderCode,@"cameraCode":cameraCode,@"turnOn":[NSNumber numberWithBool:isOn]};


    [HttpUtil post:URLString param:jsonDict finish:^(NSDictionary *obj, NSString *error) {
        block(obj,error);
    }];
}



@end
