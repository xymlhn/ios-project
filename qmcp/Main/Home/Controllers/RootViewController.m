//
//  ViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/3/1.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "RootViewController.h"
#import "WorkOrderManager.h"
#import "Config.h"
#import "PropertyManager.h"
#import "CameraManager.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "GisLocation.h"
#import "Utils.h"
#import "NSObject+LKDBHelper.h"
#import "HttpUtil.h"
#import "QMCPAPI.h"
#import "MJExtension.h"
@interface RootViewController ()<AMapLocationManagerDelegate>
@property (nonatomic,strong) AMapLocationManager *locationManager;
@property (nonatomic,strong) NSMutableArray<GisLocation *> *gisLocationArray;
@property (nonatomic,strong) NSDate *lastUploadTime;
@property (nonatomic,strong) CLLocation *lastLocation;
@end

@implementation RootViewController

-(NSMutableArray<GisLocation *> *)gisLocationArray{
    if (_gisLocationArray == nil) {
        _gisLocationArray = [NSMutableArray new];
    }
    return _gisLocationArray;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.parallaxEnabled = NO;
    self.scaleContentView = YES;
    self.contentViewScaleValue = 0.95;
    self.scaleMenuView = NO;
    self.contentViewShadowEnabled = YES;
    self.contentViewShadowRadius = 4.5;
    self.panGestureEnabled = NO;
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    //数据初始化
    [[WorkOrderManager getInstance] getWorkOrderByLastUpdateTime:[Config getWorkOrderTime]];
    [[WorkOrderManager getInstance] getCommodityStepByLastUpdateTime:[Config getCommodityStep]];
    [[PropertyManager getInstance] getCommodityItemByLastUpdateTime:[Config getCommodityItem]];
    [[PropertyManager getInstance] getCommoditySnapshotByLastUpdateTime:[Config getCommoditySnapshot]];
    [[PropertyManager getInstance] getCommodityPropertyByLastUpdateTime:[Config getCommodityProperty]];
    [[CameraManager getInstance] getAllSystemCamera];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 持续定位

 @param manager manager description
 @param location location description
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (location != nil) {
        if(_lastUploadTime == nil|| [self p_compareTime:_lastUploadTime second:[NSDate new] andNumber:1] || [location distanceFromLocation:_lastLocation] > 0.02){
            _lastUploadTime = [NSDate new];
            _lastLocation = location;
            GisLocation *tempLocation = [GisLocation new];
            tempLocation.lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
            tempLocation.lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
            tempLocation.recTime = [Utils formatDate:[NSDate new]];
            [self.gisLocationArray addObject:tempLocation];
           // [self p_sendLocation];
        }
    }
    
}

/**
 发送gis坐标到服务器
 */
-(void)p_sendLocation{
    __weak typeof(self) weakSelf = self;
    NSArray *array= [GisLocation mj_keyValuesArrayWithObjectArray:_gisLocationArray];
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_LOCATION];
    [HttpUtil post:URLString param:array finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            [weakSelf.gisLocationArray removeAllObjects];
        }
    }];
}


/**
 比较两个时间是否超过number分钟

 @param first first description
 @param second second description
 @param number 分钟数
 @return bool
 */
-(BOOL)p_compareTime:(NSDate  *)first second:(NSDate *)second andNumber:(int)number{
    NSTimeInterval aTimer = [second timeIntervalSinceDate:first];
    int hour = (int)(aTimer/3600);
    int minute = (int)(aTimer - hour*3600)/60;
    return minute >= number;
}

@end
