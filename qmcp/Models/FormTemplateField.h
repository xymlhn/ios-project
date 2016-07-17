//
//  FormTemplateField.h
//  qmcp
//
//  Created by 谢永明 on 16/5/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FormTemplateControlType) {
    FormTemplateControlTypeText = 10,//单行输入框
    FormTemplateControlTypeTextArea = 20,//多行输入框
    FormTemplateControlTypeNumber = 30,//数字输入框
    FormTemplateControlTypeSelect = 40,//单选框
    FormTemplateControlTypeCheckBox = 50,//复选框
    FormTemplateControlTypeDate = 60,//日期
    FormTemplateControlTypeDateTime = 70,//日期时间
    FormTemplateControlTypePrice = 80,//金额
    FormTemplateControlTypeLabel = 90,//说明文字
    FormTemplateControlTypeTable= 100,//表格
    FormTemplateControlTypeImage = 110,//图片

    
    FormTemplateControlTypeFooter = 1000,//表格底部
    FormTemplateControlTypeHeader = 1100,//表格头部
};

@class FormTemplateField;
@interface FormTemplateField : NSObject
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *defaultValue;
@property (nonatomic,copy) NSString *trueValue;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *formDataId;
@property (nonatomic,assign) FormTemplateControlType controlType;
@property (nonatomic,assign) int order;
@property (nonatomic,assign) int statisticsType;
@property (nonatomic,assign) bool statisticsFlag;
@property (nonatomic,assign) bool completeFlag;

@property (nonatomic,assign) bool onlyCreatorRead;
@property (nonatomic,assign) bool onlyCreatorWrite;
@property (nonatomic,strong) NSMutableArray<NSString *> *valueList;

@property (nonatomic,copy) NSString *tableTemplateId;
@property (nonatomic,strong) NSMutableDictionary<NSString *,NSArray<FormTemplateField *> *> *tempMap;
@property (nonatomic,strong) NSMutableArray *templateFields;
@end
