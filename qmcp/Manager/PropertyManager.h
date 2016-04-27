//
//  PropertyManager.h
//  qmcp
//
//  Created by 谢永明 on 16/4/20.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyManager : NSObject
@property (nonatomic, copy) NSString *currentCommodityCode;

+ (PropertyManager*) getInstance;

-(void)getCommodityItem:(NSString *)lastupdateTime;

-(void)getCommodityProperty:(NSString *)lastupdateTime;

-(BOOL)isExistProperty:(NSString *)code;

-(NSArray *)getCommodityPropertyByCommodityCode:(NSString *)commodityCode;

-(void)addCommodityChoose:(int) order propertyName:(NSString *)propertyName andPropertyContent:(NSString *)propertyContent;

-(void)releaseData;
@end
