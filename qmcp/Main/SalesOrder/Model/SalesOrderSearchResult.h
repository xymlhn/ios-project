//
//  SalesOrderSearchResult.h
//  qmcp
//
//  Created by 谢永明 on 16/8/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommoditySnapshot.h"
#import "AddressSnapshot.h"

@interface SalesOrderSearchResult : NSObject

@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy) NSString *appointmentTime;

@property (nonatomic,copy) NSString *commodityNames;

@property (nonatomic,assign) BOOL storePricingReviewFlag;

@property (nonatomic,assign) BOOL itemConfirmed;

@property (nonatomic,copy) NSArray<CommoditySnapshot *> *commodityItemList;

@property (nonatomic,copy) NSString *signatureImageKey;

@property (nonatomic, strong) AddressSnapshot *addressSnapshot;

@end
