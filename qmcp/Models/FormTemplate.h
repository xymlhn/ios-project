//
//  FormTemplate.h
//  qmcp
//
//  Created by 谢永明 on 16/5/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FormTemplateField;
@interface FormTemplate : NSObject

@property (nonatomic,copy) NSString *formTemplateName;
@property (nonatomic,copy) NSString *formTemplateId;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,assign) bool creatableFlag;
@property (nonatomic,assign) bool customerVisible;
@property (nonatomic,assign) bool tableFlag;
@property (nonatomic,strong) NSMutableArray<FormTemplateField *> *fields;

@end
