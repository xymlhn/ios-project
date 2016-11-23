//
//  SalesOrder.h
//  qmcp
//
//  Created by 谢永明 on 2016/9/22.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressSnapshot.h"
#import "PchHeader.h"
#import "ItemSnapshot.h"
#import "CommoditySnapshot.h"
@interface SalesOrder : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *organizationName;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *appointmentTime;

@property (nonatomic, copy) NSString *qrCodeUrl;

@property (nonatomic, copy) NSString *brandName;

@property (nonatomic, assign) BOOL fixedPriceFlag;

@property (nonatomic, assign) BOOL appointmentResult;

@property (nonatomic, assign) BOOL signedFlag;

@property (nonatomic, assign) float totalAmount;

@property (nonatomic, assign) SalesOrderType type;

@property (nonatomic, retain) AddressSnapshot *addressSnapshot;

@property (nonatomic, assign) OnSiteStatus onSiteStatus;

@property (nonatomic, strong) NSArray<NSString *> *commodityNames;

@property (nonatomic, assign) BOOL storePricingReviewFlag;

@property (nonatomic, assign) BOOL confirmationFlag;

@property (nonatomic, assign) BOOL isRead;

@property (nonatomic, copy) NSString *agreementPrice;   

@property (nonatomic, copy) NSString *discountAmount;

@property (nonatomic, copy) NSString *actuallyPaid;

@property (nonatomic, assign) PaymentStatus paymentStatus;

@property (nonatomic, strong) NSArray<ItemSnapshot *> *itemSnapshots;

@property (nonatomic, strong) NSArray<CommoditySnapshot *> *salesOrderCommoditySnapshots;

@end
