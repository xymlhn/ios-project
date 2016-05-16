//
//  FormTemplateField.h
//  qmcp
//
//  Created by 谢永明 on 16/5/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FormTemplateField;
@interface FormTemplateField : NSObject
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *defaultValue;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *tableTemplateId;
@property (nonatomic,copy) NSString *tableId;
@property (nonatomic,copy) NSString *formDataId;
@property (nonatomic,assign) int order;
@property (nonatomic,assign) int statisticsType;
@property (nonatomic,assign) bool statisticsFlag;
@property (nonatomic,assign) bool completeFlag;
@property (nonatomic,assign) int controlType;
@property (nonatomic,assign) bool required;
@property (nonatomic,assign) bool tableFlag;
@property (nonatomic,strong) NSMutableArray<NSString *> *valueList;
@property (nonatomic,strong) NSMutableDictionary<NSString *,NSArray<FormTemplateField *> *> *tempMap;
@property (nonatomic,strong) NSMutableArray *templateFields;
@end
