//
//  StandardModel.h
//  LanDouS
//
//  Created by Wangjc on 16/2/24.
//  Copyright © 2016年 Mao-MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface standardClassInfo : NSObject
/**
 * 规格分类名称
 */
@property(nonatomic) NSString *standardClassName;
/**
 * 规格分类id
 */
@property(nonatomic) NSString *standardClassId;
//两个初始化方法
+(instancetype)StandardClassInfoWith:(NSString *)classId andStandClassName:(NSString *)className;
-(instancetype)initWithClassId:(NSString *)classId andStandClassName:(NSString *)className;
@end




@interface StandardModel : NSObject
/**
 * 规格名称
 */
@property(nonatomic) NSString *standardName;
/**
 * 每个规格下分类信息
 */
@property(nonatomic) NSArray<standardClassInfo *> *standardClassInfo;
+(instancetype)StandardModelWith:(NSArray<standardClassInfo *>*)classinfo andStandName:(NSString *)standName;
-(instancetype)initWithClassInfo:(NSArray<standardClassInfo *> *)classinfo andStandName:(NSString *)standName;

@end
