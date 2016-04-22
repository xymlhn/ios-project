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

static PropertyManager *sharedObj = nil; //第一步：静态实例，并初始化。
NSString * const kCommodityItem = @"commodityItem";
NSString * const kCommodityProperty = @"commodityProperty";
@interface PropertyManager()

@property (nonatomic, strong) NSArray * commodityItemArr;
@property (nonatomic, strong) NSDictionary * commodityPropertyDict;

@end
@implementation PropertyManager
+ (PropertyManager*) getInstance  //第二步：实例构造检查静态实例是否为nil
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedObj = [[self alloc] init];
    });
    
    return sharedObj;
}

+ (id) allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedObj = [super allocWithZone:zone];
    });
    return sharedObj;
}
- (id)init
{
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if((obj = [super init]) != nil)
        {
            _commodityItemArr = [[TMCache sharedCache] objectForKey:kCommodityItem];
            if(_commodityItemArr == nil)
            {
                _commodityItemArr = [NSArray new];
            }
            _commodityPropertyDict = [[TMCache sharedCache] objectForKey:kCommodityProperty];
            if(_commodityPropertyDict == nil)
            {
                _commodityPropertyDict = [NSDictionary new];
            }
        }
    });
    self = obj;
    
    return self;
}
- (id) copyWithZone:(NSZone *)zone
{
    return sharedObj;
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
