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

/**
 *  获取服务属性
 *
 *  @param lastupdateTime 时间
 */
-(void)getCommodityItemByLastUpdateTime:(NSString *)lastupdateTime;

/**
 *  获取规格属性
 *
 *  @param lastupdateTime 时间
 */
-(void)getCommodityPropertyByLastUpdateTime:(NSString *)lastupdateTime;

/**
 *  服务是否存在规格
 *
 *  @param code 服务code
 *
 *  @return bool
 */
-(BOOL)isExistProperty:(NSString *)code;

/**
 *  根据服务code获取规格
 *
 *  @param commodityCode 服务code
 *
 *  @return 规格数组
 */
-(NSArray *)getCommodityPropertyByCommodityCode:(NSString *)commodityCode;

/**
 *  添加选择规格
 *
 *  @param order           位置
 *  @param propertyName    规格名称 (例:尺寸)
 *  @param propertyContent 规格描述 (例:XL,XXL)
 */
-(void)appendCommodityChooseWithOrder:(int)order andPropertyName:(NSString *)propertyName andPropertyContent:(NSString *)propertyContent;

/**
 *  释放数据
 */
-(void)releaseData;

@end
