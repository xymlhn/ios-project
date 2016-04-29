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

#pragma mark - network
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

#pragma mark - UIViewController
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
    return [_commodityPropertyDict objectForKey:code] != nil && [self isExistCommodityItem:code];
}

/**
 *  commodityItemArr是否存在服务
 *
 *  @param code 服务code
 *
 *  @return bool
 */
-(BOOL)isExistCommodityItem:(NSString *)code{
    BOOL flag = false;
    for (CommodityItem *item in _commodityItemArr) {
        if([item.commodityCode isEqualToString:code])
        {
            flag = true;
        }
    }
    return flag;
}

/**
 *  根据服务code获取规格
 *
 *  @param commodityCode 服务code
 *
 *  @return 服务数组
 */
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
/**
 *  处理已点击的规格
 */
-(void)handleChoose{
    [_propertyDataArr removeAllObjects];
    for (NSString *key in _commodityPropertyChooseDict) {
        [_propertyDataArr addObject:_commodityPropertyChooseDict[key]];
    }
    [self findAvailableItemProperty:_propertyDataArr];
}

/**
 *  查找可用服务规格
 *
 *  @param propertyDataArr 规格数组
 */
-(void)findAvailableItemProperty:(NSMutableArray *)propertyDataArr
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"commodityCode == %@",_currentCommodityCode];
    NSArray* conditionArr = [_commodityItemArr filteredArrayUsingPredicate:predicate];
    if([propertyDataArr count] == 0){
        [self getCommodityPropertyArr:_currentCommodityCode];
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
    NSDictionary *dict;
    if([conditionArr count] == 1){
        CommodityItem *item = conditionArr[0];
        dict = @{@"flag":@YES,@"price":[NSNumber numberWithFloat:item.price],@"property":item.commodityItemName};
        //创建一个消息对象
       
    }else if ([conditionArr count] == 0){
         dict = @{@"flag":@NO};

    }else{
         dict = @{@"flag":@NO};
    }
    NSNotification * notice = [NSNotification notificationWithName:@"priceUpdate" object:nil userInfo:dict];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    //[self sortProperties:conditionArr];
}

/**
 *  查找选择规格后的可选规格
 *
 *  @param properties 规格数组
 */
-(void)sortProperties:(NSArray *)properties{
    NSArray *commodityPropertyArr = [self getCommodityPropertyArr:_currentCommodityCode];
    CommodityProperty *p1 = commodityPropertyArr.count > 0 ? commodityPropertyArr[0] : [CommodityProperty new];
    CommodityProperty *p2 = commodityPropertyArr.count > 1 ? commodityPropertyArr[1] : [CommodityProperty new];
    CommodityProperty *p3 = commodityPropertyArr.count > 2 ? commodityPropertyArr[2] : [CommodityProperty new];
    CommodityProperty *p4 = commodityPropertyArr.count > 3 ? commodityPropertyArr[3] : [CommodityProperty new];
    CommodityProperty *p5 = commodityPropertyArr.count > 4 ? commodityPropertyArr[4] : [CommodityProperty new];
    CommodityProperty *p6 = commodityPropertyArr.count > 5 ? commodityPropertyArr[5] : [CommodityProperty new];
    
    NSMutableArray *arr1 = [NSMutableArray new];
    NSMutableArray *arr2 = [NSMutableArray new];
    NSMutableArray *arr3 = [NSMutableArray new];
    NSMutableArray *arr4 = [NSMutableArray new];
    NSMutableArray *arr5 = [NSMutableArray new];
    NSMutableArray *arr6 = [NSMutableArray new];
    
    for (CommodityItem *item in properties) {
        NSString *p1Value = item.p1;
        NSString *p2Value = item.p2;
        NSString *p3Value = item.p3;
        NSString *p4Value = item.p4;
        NSString *p5Value = item.p5;
        NSString *p6Value = item.p6;
        if(p1Value != nil && ![arr1 containsObject:p1Value]){
            [arr1 addObject:p1Value];
        }
        if(p2Value != nil && ![arr2 containsObject:p2Value]){
            [arr2 addObject:p2Value];
        }
        if(p3Value != nil && ![arr3 containsObject:p3Value]){
            [arr3 addObject:p3Value];
        }
        if(p4Value != nil && ![arr4 containsObject:p4Value]){
            [arr4 addObject:p4Value];
        }
        if(p5Value != nil && ![arr5 containsObject:p5Value]){
            [arr5 addObject:p5Value];
        }
        if(p6Value != nil && ![arr6 containsObject:p6Value]){
            [arr6 addObject:p6Value];
        }
    }
    
    [self compareArr:p1.propertyContent andArr2:arr1];
    [self compareArr:p2.propertyContent andArr2:arr2];
    [self compareArr:p3.propertyContent andArr2:arr3];
    [self compareArr:p4.propertyContent andArr2:arr4];
    [self compareArr:p5.propertyContent andArr2:arr5];
    [self compareArr:p6.propertyContent andArr2:arr6];
}
/**
 *  比较规格进行删除
 *
 *  @param arr1 旧规格
 *  @param arr2 筛选过后规格
 */
-(void)compareArr:(NSMutableArray *)arr1 andArr2:(NSMutableArray *)arr2
{
    for (NSString *str in arr1) {
        if(arr2.count == 0 || ![arr2 containsObject:str]){
            [arr1 removeObject:str];
            break;
        }
    }
}

-(void)releaseData{
    [_commodityPropertyChooseDict removeAllObjects];
    _currentCommodityCode = @"";
}

@end
