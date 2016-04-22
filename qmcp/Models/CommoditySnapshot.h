//
//  CommoditySnapshot.h
//  qmcp
//
//  Created by 谢永明 on 16/3/11.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommoditySnapshot : NSObject

@property (nonatomic, copy) NSString *commodityCode;

@property (nonatomic, copy) NSString *commodityName;

@property (nonatomic, copy) NSString *commodityUnit;

@property (nonatomic, copy) NSString *commodityType;

@property (nonatomic, copy) NSString *commodityTime;

@property (nonatomic, copy) NSString *commodityContent;

@property (nonatomic, copy) NSString *workOrderCode;

@property (nonatomic, assign) int code;

@property (nonatomic, assign) float price;

@property (nonatomic, assign) BOOL isSelect;
@end
