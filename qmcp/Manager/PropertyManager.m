//
//  PropertyManager.m
//  qmcp
//
//  Created by 谢永明 on 16/4/20.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "PropertyManager.h"
#import "Config.h"
#import "Utils.h"
#import "TMCache.h"
#import "OSCAPI.h"
#import "HttpUtil.h"
#import "MJExtension.h"
#import "Commodity.h"
#import "CommodityItem.h"
#import "CommodityProperty.h"

NSString * const kCommodityItem = @"commodityItem";
NSString * const kCommodityProperty = @"commodityProperty";
@interface PropertyManager()

@property (nonatomic, strong) NSArray * commodityItemArr;
@property (nonatomic, strong) NSDictionary * commodityPropertyDict;

@end
@implementation PropertyManager

+ (PropertyManager *)getInstance {
    static PropertyManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
        shared_manager.commodityItemArr = [[TMCache sharedCache] objectForKey:kCommodityItem];
        if(shared_manager.commodityItemArr == nil)
        {
            shared_manager.commodityItemArr = [NSArray new];
        }
        shared_manager.commodityPropertyDict = [[TMCache sharedCache] objectForKey:kCommodityProperty];
        if(shared_manager.commodityPropertyDict == nil)
        {
            shared_manager.commodityPropertyDict = [NSDictionary new];
        }
    });
    return shared_manager;
}

-(void)getCommodityItem:(NSString *)lastupdateTime
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_COMMODITYITEM,lastupdateTime];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            [Config setCommodityItem:[Utils formatDate:[NSDate new]]];
            _commodityItemArr = [CommodityItem mj_objectArrayWithKeyValuesArray:obj];
            
        }else{
            [self getCommodityItem:[Config getCommodityItem]];
        }
    }];
    
}

-(void)getCommodityProperty:(NSString *)lastupdateTime
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_COMODITYPROPERTY,lastupdateTime];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            [Config setCommodityProperty:[Utils formatDate:[NSDate new]]];
            _commodityPropertyDict = obj;

        }else{
            [self getCommodityProperty:[Config getCommodityProperty]];
        }
    }];
    
}

-(NSArray *)getCommodityPropertyArr:(NSString *)code
{
    NSArray *array = [NSArray new];
    if([_commodityPropertyDict objectForKey:code] != nil){
        NSString *json = [_commodityPropertyDict[code] mj_JSONString];
        array = [CommodityProperty mj_objectArrayWithKeyValuesArray:json];
    }
    return array;
}

-(BOOL)isExistProperty:(NSString *)code
{
    return [_commodityPropertyDict objectForKey:code] != nil && [self p_isExistCommodityItem:code];
}

-(BOOL)p_isExistCommodityItem:(NSString *)code{
    BOOL flag = false;
    for (CommodityItem *item in _commodityItemArr) {
        if([item.commodityCode isEqualToString:code])
        {
            flag = true;
        }
    }
    return flag;
}

-(CommodityItem *)getCommodityItem_:(NSString *)commodityCode andCommodityItemCode:(NSString *)commodityItemCode{
    CommodityItem *commodityItem = nil;
    for(CommodityItem *item in _commodityItemArr){
        if([commodityCode isEqualToString:item.commodityCode]){
            if([commodityItemCode isEqualToString:commodityItemCode]){
                commodityItem = item;
            }
        }
    }
    return commodityItem;
}





















@end
