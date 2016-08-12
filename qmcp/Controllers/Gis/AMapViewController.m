//
//  AMapViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/8/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "AMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface AMapViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate>

@property (nonatomic,strong)MAMapView *mapView;
@property (nonatomic,strong)AMapLocationManager *locationManager;

@end

@implementation AMapViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.pausesLocationUpdatesAutomatically = NO;
    _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    [_mapView setZoomLevel:16.1 animated:YES];
    [self.view addSubview:_mapView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.image = [UIImage imageNamed:@"location.png"];
        [self.mapView updateUserLocationRepresentation:pre];
        view.calloutOffset = CGPointMake(0, 0);
    } 
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}

@end