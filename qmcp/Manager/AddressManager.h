//
//  AddressManager.h
//  qmcp
//
//  Created by 谢永明 on 16/9/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressManager : NSObject
+ (AddressManager *)getInstance;

/**
 *  获取全国所有的省
 *
 *  @return 省数组
 */
-(NSArray *)getProvince;
/**
 *  根据省下标获取城市数组
 *
 *  @param index 下标
 *
 *  @return 城市数组
 */
-(NSArray *)getCity:(NSInteger)index;

/**
 *  根据省下标和城市下标获取地区数组
 *
 *  @param indexProvince 省下标
 *  @param indexCity     城市下标
 *
 *  @return 地区数组
 */
-(NSArray *)getDistanceByProvinceIndex:(NSInteger)indexProvince andCityIndex:(NSInteger)indexCity;
@end
