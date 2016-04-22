//
//  CommodityItem.h
//  qmcp
//
//  Created by 谢永明 on 16/4/20.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommodityItem : NSObject

@property (nonatomic,copy) NSString *commodityCode;
@property (nonatomic,copy) NSString *commodityItemId;
@property (nonatomic,copy) NSString *commodityItemCode;
@property (nonatomic,copy) NSString *commodityItemName;
@property (nonatomic,assign) BOOL availableFlag;
@property (nonatomic,assign) int price;
@property (nonatomic,copy) NSString *p1;
@property (nonatomic,copy) NSString *p2;
@property (nonatomic,copy) NSString *p3;
@property (nonatomic,copy) NSString *p4;
@property (nonatomic,copy) NSString *p5;
@property (nonatomic,copy) NSString *p6;
@end
