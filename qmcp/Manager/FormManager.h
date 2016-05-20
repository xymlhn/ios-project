//
//  FormManager.h
//  qmcp
//
//  Created by 谢永明 on 16/5/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FormData;
@interface FormManager : NSObject

+ (FormManager *) getInstance;

/**
 *  根据订单code获取表单模板
 *
 *  @param salesOrderCode code
 */
-(void)getFormTemplate:(NSString *)salesOrderCode;

/**
 *  根据订单code获取表单数据
 *
 *  @param salesOrderCode code
 */
-(void)getFormData:(NSString *)salesOrderCode;

/**
 *  保存表单数据
 *
 *  @param formDatas array<formdata>
 */
-(void)saveFormData:(NSMutableArray<FormData *> *)formDatas;

/**
 *  删除表单数据
 *
 *  @param formDataId 表单数据id
 */
-(void)deleteFormData:(NSString *)formDataId;

@end
