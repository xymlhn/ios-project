//
//  FormManager.m
//  qmcp
//
//  Created by 谢永明 on 16/5/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "FormManager.h"
#import "OSCAPI.h"
#import "HttpUtil.h"
#import "NSObject+LKDBHelper.h"
#import "MJExtension.h"
#import "Config.h"
#import "Utils.h"
#import "MBProgressHUD.h"
#import "FormTemplateField.h"
#import "FormTemplate.h"
#import "FormData.h"
#import "FormTemplateBrife.h"
#import "NSMutableArray+InsertArray.h"

@interface FormManager()

@property (nonatomic, strong) NSMutableDictionary<NSString *,FormTemplate *> *formTemplateDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *,NSMutableArray<FormData *> *> *formDataDict;

@end

@implementation FormManager

+ (FormManager *)getInstance {
    static FormManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
        if(shared_manager.formTemplateDict == nil)
        {
            shared_manager.formTemplateDict = [NSMutableDictionary new];
        }
    });
    return shared_manager;
}


-(void)getFormTemplateAndFormData:(NSString *)salesOrderCode finishBlock:(void (^)(NSMutableArray *, NSString *))block{
    NSString *URLStringTemplate = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_FORMTEMPLATE,salesOrderCode];
    [HttpUtil get:URLStringTemplate param:nil finish:^(NSDictionary *obj, NSString *error1) {
        if (!error1) {
            [_formTemplateDict removeAllObjects];
            NSArray *array = [FormTemplate mj_objectArrayWithKeyValuesArray:obj];
            for (FormTemplate *form in array) {
                form.fields = [FormTemplateField mj_objectArrayWithKeyValuesArray:form.fields];
                [_formTemplateDict setValue:form forKey:form.formTemplateId];
            }
            NSString *URLStringData= [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_FORMDATA,salesOrderCode];
            [HttpUtil get:URLStringData param:nil finish:^(NSDictionary *obj, NSString *error2) {
                if (!error2) {
                    [_formDataDict removeAllObjects];
                    NSArray *array = [FormData mj_objectArrayWithKeyValuesArray:obj];
                    for (FormData *form in array) {
                        if (_formDataDict[form.formTemplateId] != nil) {
                            [_formDataDict[form.formTemplateId] addObject:form];
                        }else{
                            NSMutableArray *arr = [NSMutableArray new];
                            [arr addObject:form];
                            [_formDataDict setValue:arr forKey:form.formTemplateId];
                        }
                        
                    }
                    NSMutableArray *brife = [NSMutableArray new];
                    for (FormTemplate *formTemplate in [_formTemplateDict allValues]) {
                        FormTemplateBrife *formTemplateBrife = [FormTemplateBrife new];
                        formTemplateBrife.key = formTemplate.formTemplateId;
                        formTemplateBrife.name = formTemplate.formTemplateName;
                        formTemplateBrife.formTemplateCode = formTemplate.formTemplateId;
                        formTemplateBrife.formSort = [self getFormSort:formTemplate.formTemplateId];
                        [brife addObject:formTemplateBrife];
                    }
                    block(brife,nil);
                    
                }else{
                    block(nil,error2);
                }
            }];
            
        }else{
            block(nil,error1);
        }
    }];
}

/**
 *  根据模板id获取该模板的完成类型
 *
 *  @param formTemplateId 模板id
 *
 *  @return 完成类型
 */
-(FormSort)getFormSort:(NSString *)formTemplateId{
    FormSort formSort = FormSortCreate;
    if([_formDataDict objectForKey:formTemplateId] != nil){
        formSort = FormSortUpdate;
        for (FormData *form in _formDataDict[formTemplateId]) {
            if (form.completeFlag) {
                formSort = FormSortComplete;
            }
        }
    }
    return formSort;
}

-(NSMutableArray<FormTemplateField *> *)formTemplateField:(NSString *)formTemplateId{
    NSMutableArray<FormTemplateField *> *array = [NSMutableArray new];
    if(_formTemplateDict[formTemplateId] != nil){
        FormTemplate *field = _formTemplateDict[formTemplateId];
        array = field.fields;
    }
    [self tableField:array];
    return array;
}

-(void)tableField:(NSMutableArray<FormTemplateField *> *)formTemplateField{
    for (int i = 0; i < [formTemplateField count]; i++) {
        FormTemplateField *field = formTemplateField[i];
        if(field.controlType == FormTemplateControlTypeTable){
            //            FormTemplateField *footer = [FormTemplateField new];
            //            footer.controlType = FormTemplateControlTypeFooter;
            //            footer.id = field.id;
            NSMutableArray<FormTemplateField *> *tableField = [self formTemplateField:field.id];
            [formTemplateField insertArray:tableField atIndex:i];
        }
    }
}
-(void)saveFormData:(NSMutableArray<FormData *> *)formDatas{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_SAVE_FORMDATA];
    [HttpUtil post:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            
            
        }else{
            
        }
    }];
}

-(void)deleteFormData:(NSString *)formDataId{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_DELETE_FORMDATA,formDataId];
    [HttpUtil post:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            
            
        }else{
            
        }
    }];
}

@end
