//
//  WorkOrder.h
//  qmcp
//
//  Created by 谢永明 on 16/3/11.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SalesOrderSnapshot.h"
#import "ItemSnapshot.h"
#import "CommoditySnapshot.h"
#import "AddressSnapshot.h"
#import "User.h"
#import "PchHeader.h"
typedef NS_ENUM(NSInteger, WorkOrderType) {
    WorkOrderTypeOnsite = 10,//上门
    WorkOrderTypeService = 30,//服务
};

typedef NS_ENUM(NSInteger, WorkOrderStatus) {
    WorkOrderStatusDefault = 0,
    WorkOrderStatusUnknown = 10,
    WorkOrderStatusUnassigned= 20,
    WorkOrderStatusAssigned = 30,
    WorkOrderStatusUnacknowledged = 40,
    WorkOrderStatusAcknowledged = 50,
    WorkOrderStatusEnroute = 60,
    WorkOrderStatusOnSite = 70,
    WorkOrderStatusInProgress = 80,
    WorkOrderStatusCancelled = 90,
    WorkOrderStatusSuspended = 100,
    WorkOrderStatusCompleted = 110,
    WorkOrderStatusVerified = 120,
    WorkOrderStatusIncomplete = 130,
    WorkOrderStatusSkipped = 140,
    WorkOrderStatusScheduled = 150,
    WorkOrderStatusTentative= 160,
};
typedef NS_ENUM(NSInteger, OnSiteTimeStamp) {
    OnSiteTimeStampAcknowledge = 10,//确认接收
    OnSiteTimeStampEnroute = 20,//出发
    OnSiteTimeStampOnsite = 30,//到达
    OnSiteTimeStampResolved = 40,//解决时间
    OnSiteTimeStampComplete = 50,//完成时间
};

@interface WorkOrder : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *qrCodeUrl;

@property (nonatomic, copy) NSString *signatureImageKey;

@property (nonatomic, copy) NSString *userOpenId;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) WorkOrderType type;

@property (nonatomic, assign) WorkOrderStatus status;

@property (nonatomic, assign) OnSiteStatus onSiteStatus;

@property (nonatomic, assign) BOOL isRead;

@property (nonatomic, assign) BOOL isFailed;

@property (nonatomic, retain) SalesOrderSnapshot *salesOrderSnapshot;

@property (nonatomic, retain) ItemSnapshot *itemSnapshot;

@property (nonatomic, copy) NSMutableArray *processDetail;

@property (nonatomic, copy) NSMutableArray *salesOrderCommoditySnapshots;
@end
