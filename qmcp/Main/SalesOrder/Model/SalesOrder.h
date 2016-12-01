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

@property (nonatomic, copy) NSString *agreementPrice;

@property (nonatomic, copy) NSString *discountAmount;   //折扣

@property (nonatomic, copy) NSString *actuallyPaid;     //最终价格

@property (nonatomic, assign) BOOL fixedPriceFlag;

@property (nonatomic, assign) BOOL appointmentResult;

@property (nonatomic, assign) BOOL signedFlag;      //是否清点

@property (nonatomic, assign) BOOL processingFlag;

@property (nonatomic, assign) BOOL paidFlag;        //是否支付

@property (nonatomic, assign) BOOL storePricingReviewFlag;      //商家核价

@property (nonatomic, assign) BOOL confirmationFlag;

@property (nonatomic, assign) BOOL isRead;      //是否已读

@property (nonatomic, assign) float totalAmount;    //总价

@property (nonatomic, assign) PaymentStatus paymentStatus;

@property (nonatomic, assign) SalesOrderType type;

@property (nonatomic, retain) AddressSnapshot *addressSnapshot;

@property (nonatomic, assign) OnSiteStatus onSiteStatus;

@property (nonatomic, strong) NSArray<NSString *> *commodityNames;

@property (nonatomic, strong) NSArray<ItemSnapshot *> *itemSnapshots;

@property (nonatomic, strong) NSArray<CommoditySnapshot *> *salesOrderCommoditySnapshots;

@end
