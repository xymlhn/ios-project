//
//  SalesOrderSnapshot.h
//  qmcp
//
//  Created by 谢永明 on 16/3/11.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressSnapshot.h"

typedef NS_ENUM(NSInteger, SalesOrderType) {
    SalesOrderTypeOnsite = 10,//上门
    SalesOrderTypeShop = 20,//到店
    SalesOrderTypeUnknown = 30,//到店
};

@interface SalesOrderSnapshot : NSObject

@property (nonatomic, copy) NSString *organizationName;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *organizationAddress;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *appointmentTime;

@property (nonatomic, assign) BOOL fixedPriceFlag;

@property (nonatomic, assign) BOOL appointmentResult;

@property (nonatomic, assign) BOOL itemConfirmed;

@property (nonatomic, assign) float totalAmount;

@property (nonatomic, assign) SalesOrderType type;

@property (nonatomic, retain) AddressSnapshot *addressSnapshot;

@property (nonatomic, copy) NSString *qrCodeUrl;

@property (nonatomic, strong) NSArray *commodityNames;


@end
