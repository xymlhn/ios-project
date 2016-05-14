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
@property (nonatomic, strong) CameraData *needOpenCamera;
@end

@implementation CameraManager

+ (CameraManager *)getInstance {
    static CameraManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

-(void)setNeedOpenCamera:(CameraData *)needOpenCamera
{
    
}
-(void)getAllCamera{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_ALL_CAMERA];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            _allCameraArr = [CameraData mj_objectArrayWithKeyValuesArray:obj];
        }else{
            [self getAllCamera];
        }
    }];
}

-(void)getCurrentCamera:(NSString *)workOrderCode
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_ALL_CAMERA,workOrderCode];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            CameraData *currentCamera = [CameraData mj_objectWithKeyValues:obj];
            for(CameraData *cameraData in _allCameraArr){
                if([cameraData.cameraCode isEqualToString:currentCamera.cameraCode]){
                    cameraData.isChoose = YES;
                }
            }
            NSDictionary *dict = @{@"all_camera":_allCameraArr};
            NSNotification * notice = [NSNotification notificationWithName:kCameraNotification object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
        }else{
            [self getAllCamera];
        }
    }];
}

-(void)switchCamera:(NSString *)workOrderCode cameraCode:(NSString *)cameraCode isOn:(bool)isOn needOpen:(bool)open{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_CAMERA_SWITCH];
    NSDictionary *jsonDict = @{@"workOrderCode":workOrderCode,@"cameraCode":cameraCode,@"turnOn":[NSNumber numberWithBool:isOn]};
    NSString *json = [jsonDict mj_JSONString];
    
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = isOn ? @"打开摄像头中..." : @"关闭摄像头";
    hub.userInteractionEnabled = NO;

    [HttpUtil post:URLString json:json finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            CameraData *currentCamera = [CameraData mj_objectWithKeyValues:obj];
            for(CameraData *cameraData in _allCameraArr){
                if([cameraData.cameraCode isEqualToString:currentCamera.cameraCode]){
                    cameraData.isChoose = YES;
                }
            }
            NSDictionary *dict = @{@"all_camera":_allCameraArr};
            NSNotification * notice = [NSNotification notificationWithName:kCameraNotification object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = [NSString stringWithFormat:isOn ?@"切换成功" :@"关闭成功"];
            [hub hide:YES afterDelay:0.5];
            if(!isOn && open){
                [self switchCamera:workOrderCode cameraCode:_needOpenCamera.cameraCode isOn:YES needOpen:NO];
            }
        }else{
            NSString *message = @"";
            if(obj == nil){
                message = isOn ?@"切换失败": @"关闭失败";
            }else{
                message = [obj valueForKey:@"message"];
            }
            NSDictionary *dict = @{@"all_camera":_allCameraArr};
            NSNotification * notice = [NSNotification notificationWithName:kCameraNotification object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = message;
            [hub hide:YES afterDelay:0.5];
        }
    }];
}



@end
