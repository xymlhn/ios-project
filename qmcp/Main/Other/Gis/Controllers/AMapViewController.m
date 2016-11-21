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
#import "Masonry.h"
#import "Config.h"
#import "MBProgressHUD.h"
#import "Utils.h"
#import "HttpUtil.h"
#import "QMCPAPI.h"
#import "GisLocation.h"
#import "MJExtension.h"
@interface AMapViewController ()<MAMapViewDelegate>

@property (nonatomic,strong)MAMapView *mapView;
@property (nonatomic,strong)AMapLocationManager *locationManager;

@end

@implementation AMapViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.pausesLocationUpdatesAutomatically = NO;
    [_mapView setZoomLevel:16.1 animated:YES];
    [self.view addSubview:_mapView];

}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MAAnnotationView *view = views[0];
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]]){
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.image = [UIImage imageNamed:@"location.png"];
        [self.mapView updateUserLocationRepresentation:pre];
        view.calloutOffset = CGPointMake(0, 0);
    } 
}


@end
