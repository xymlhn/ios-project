//
//  FormManager.h
//  qmcp
//
//  Created by 谢永明 on 16/5/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormTemplateField.h"
@class FormData;
@interface FormManager : NSObject

+ (FormManager *) getInstance;

/**
 *  根据订单code获取表单模板和表单数据
 *
 *  @param salesOrderCode 订单code
 */
-(void)getFormTemplateAndFormData:(NSString *)salesOrderCode finishBlock:(void (^)(NSMutableArray *, NSString *))block;

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


/**
 *  获取展示模板
 *
 *  @param formTemplateId 模板id
 */
-(NSMutableArray<FormTemplateField *> *)formTemplateField:(NSString *)formTemplateId;

/**
 *  处理带table的表单
 *
 *  @param formList 表单数据
 */
-(void)handleFormTable:(NSMutableArray<FormTemplateField* > *) formList formTemplateId:(NSString *)formTemplateId;
@end
