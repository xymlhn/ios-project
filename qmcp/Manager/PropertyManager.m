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
#import "PropertyData.h"

NSString * const kCommodityItem = @"commodityItem";
NSString * const kCommodityProperty = @"commodityProperty";
@interface PropertyManager()

@property (nonatomic, strong) NSMutableArray * commodityItemArr;
@property (nonatomic, strong) NSDictionary * commodityPropertyDict;

@property (nonatomic, strong) NSMutableDictionary * commodityPropertyChooseDict;
@property (nonatomic, strong) NSMutableArray *propertyDataArr;

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
            shared_manager.commodityItemArr = [NSMutableArray new];
        }
        shared_manager.commodityPropertyDict = [[TMCache sharedCache] objectForKey:kCommodityProperty];
        if(shared_manager.commodityPropertyDict == nil)
        {
            shared_manager.commodityPropertyDict = [NSDictionary new];
        }
        if(shared_manager.commodityPropertyChooseDict == nil)
        {
            shared_manager.commodityPropertyChooseDict = [NSMutableDictionary new];
        }
        if(shared_manager.propertyDataArr == nil){
            shared_manager.propertyDataArr = [NSMutableArray new];
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
            if(obj != nil){
                [[TMCache sharedCache] setObject:obj forKey:kCommodityProperty];
                _commodityPropertyDict = obj;
            }

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

-(NSArray *)getCommodityPropertyByCommodityCode:(NSString *)commodityCode
{
    NSArray *arr = [NSArray new];
    for (NSString *key in _commodityPropertyDict) {
        if([key isEqualToString:commodityCode]){
            arr = [CommodityProperty mj_objectArrayWithKeyValuesArray:_commodityPropertyDict[key]];
        }
    }
    return arr;

}

-(void)releaseData{
    [_commodityPropertyChooseDict removeAllObjects];
    _currentCommodityCode = @"";
}

-(void)addCommodityChoose:(int) order propertyName:(NSString *)propertyName andPropertyContent:(NSString *)propertyContent{
    
    PropertyData *data = [PropertyData new];
    data.order = order;
    data.value = propertyContent;
    if([_commodityPropertyChooseDict objectForKey:propertyName] != nil){
        _commodityPropertyChooseDict[propertyName] = data;
    }else{
        [_commodityPropertyChooseDict setObject:data forKey:propertyName];
    }
    [self handleChoose];
}

-(void)handleChoose{
    [_propertyDataArr removeAllObjects];
    for (NSString *key in _commodityPropertyChooseDict) {
        [_propertyDataArr addObject:_commodityPropertyChooseDict[key]];
    }
//    [_propertyDataArr sortedArrayUsingComparator:^NSComparisonResult(PropertyData *p1, PropertyData *p2){
//        return p1.order > p2.order;
//    }];
    [self findAvailableItemProperty:_propertyDataArr];
}

-(void)findAvailableItemProperty:(NSMutableArray *)propertyDataArr
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"commodityCode == %@",_currentCommodityCode];
    NSArray* conditionArr = [_commodityItemArr filteredArrayUsingPredicate:predicate];
    if([propertyDataArr count] == 0){
        return;
    }

    for (PropertyData *propertyData in propertyDataArr) {
        NSString *pValue = propertyData.value;
        NSPredicate *p1Predicate = [NSPredicate predicateWithFormat:@"p1 == %@",pValue];
        NSPredicate* p2Predicate = [NSPredicate predicateWithFormat:@"p2 == %@",pValue];
        NSPredicate* p3Predicate = [NSPredicate predicateWithFormat:@"p3 == %@",pValue];
        NSPredicate* p4Predicate = [NSPredicate predicateWithFormat:@"p4 == %@",pValue];
        NSPredicate* p5Predicate = [NSPredicate predicateWithFormat:@"p5 == %@",pValue];
        NSPredicate* p6Predicate = [NSPredicate predicateWithFormat:@"p6 == %@",pValue];
        switch (propertyData.order) {
            case 0:
                conditionArr = [conditionArr filteredArrayUsingPredicate:p1Predicate];
                break;
            case 1:
                conditionArr = [conditionArr filteredArrayUsingPredicate:p2Predicate];
                break;
            case 2:
                conditionArr = [conditionArr filteredArrayUsingPredicate:p3Predicate];
                break;
            case 3:
                conditionArr = [conditionArr filteredArrayUsingPredicate:p4Predicate];
                break;
            case 4:
                conditionArr = [conditionArr filteredArrayUsingPredicate:p5Predicate];
                break;
            case 5:
                conditionArr = [conditionArr filteredArrayUsingPredicate:p6Predicate];
                break;
            default:
                break;
        }
    }
    
    if([conditionArr count] == 1){
        NSLog(@"succeed");
    }else if ([conditionArr count] == 0){
        NSLog(@"none");
    }else{
        NSLog(@"failed");
    }
}
















@end
