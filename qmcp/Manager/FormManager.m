//
//  FormManager.m
//  qmcp
//
//  Created by 谢永明 on 16/5/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "FormManager.h"
#import "QMCPAPI.h"
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
    NSString *URLStringTemplate = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_FORMTEMPLATE,salesOrderCode];
    [HttpUtil get:URLStringTemplate param:nil finish:^(NSDictionary *obj, NSString *error1) {
        if (!error1) {
            [_formTemplateDict removeAllObjects];
            NSArray *array = [FormTemplate mj_objectArrayWithKeyValuesArray:obj];
            for (FormTemplate *form in array) {
                form.fields = [FormTemplateField mj_objectArrayWithKeyValuesArray:form.fields];
                [_formTemplateDict setValue:form forKey:form.formTemplateId];
            }
            NSString *URLStringData= [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_FORMDATA,salesOrderCode];
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
                        if(formTemplate.parentCode == nil){
                            FormTemplateBrife *formTemplateBrife = [FormTemplateBrife new];
                            formTemplateBrife.key = formTemplate.formTemplateId;
                            formTemplateBrife.name = formTemplate.formTemplateName;
                            formTemplateBrife.formTemplateCode = formTemplate.formTemplateId;
                            formTemplateBrife.formSort = [self getFormSort:formTemplate.formTemplateId];
                            [brife addObject:formTemplateBrife];
                        }
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

-(void)handleFormTable:(NSMutableArray<FormTemplateField *> *)formList formTemplateId:(NSString *)formTemplateId
{
    if(![self isExistsFormData:formTemplateId]){
        int tableNumber = [self formTableNumber:formList];
        for (int i = 0; i < tableNumber; i++) {
            [self replaceFormTable:formList];
        }
    }else{
        
    }

}

-(void)replaceFormTable:(NSMutableArray<FormTemplateField *> *)formList{
    for (int i = 0; i < formList.count; i++) {
        FormTemplateField *field = formList[i];
        if(field.controlType == FormTemplateControlTypeTable){
            FormTemplateField *footer = [FormTemplateField new];
            footer.controlType = FormTemplateControlTypeFooter;
            footer.tableTemplateId = field.tableTemplateId;
            
            NSMutableArray<FormTemplateField *> *tableList = [self formTemplateField:field.tableTemplateId];
            
            FormTemplateField *header = [FormTemplateField new];

            header.controlType = FormTemplateControlTypeHeader;
            header.id = [[NSUUID UUID] UUIDString];
            header.tableTemplateId = field.tableTemplateId;
            header.templateFields = tableList;
            header.tempOrder = 1;
            footer.id = header.id;
            footer.tableTemplateId = field.tableTemplateId;

            field.tempMap = [NSMutableDictionary new];
            [field.tempMap setObject:tableList forKey:header.id];
            [tableList insertObject:header atIndex:0];
            
            [formList replaceObjectAtIndex:i withObject:footer];
            
            NSRange range = NSMakeRange(i, [tableList count]);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [formList insertObjects:tableList atIndexes:indexSet];
            break;
        }
    }
}

-(NSMutableArray<FormTemplateField*> *)plusFormTemplate:(NSString *)tableFormTemplateId withOrder:(NSUInteger)order{
    NSMutableArray<FormTemplateField *> *tableList = [self formTemplateField:tableFormTemplateId];
    
    FormTemplateField *header = [FormTemplateField new];
    header.tempOrder = order + 1;
    header.controlType = FormTemplateControlTypeHeader;
    header.id = [[NSUUID UUID] UUIDString];
    header.tableTemplateId = tableFormTemplateId;
    header.templateFields = tableList;
    [tableList insertObject:header atIndex:0];
    return tableList;
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

/**
 *  表单是否已经有数据
 *
 *  @param formTemplateId 表单id
 *
 *  @return boolean
 */
-(BOOL)isExistsFormData:(NSString *)formTemplateId{
    if([_formDataDict objectForKey:formTemplateId] != nil){
        return YES;
    }else{
        return NO;
    }
}

/**
 * 表单里面不同表格数量
 *
 *  @param formList 表单数组
 *
 *  @return int
 */
-(int)formTableNumber:(NSMutableArray<FormTemplateField *> *)formList{
    int number = 0;
    for (FormTemplateField *field in formList) {
        if(field.controlType == FormTemplateControlTypeTable){
            number++;
        }
    }
    return number;
}

-(NSMutableArray<FormTemplateField *> *)formTemplateField:(NSString *)formTemplateId{
    NSMutableArray<FormTemplateField *> *array = [NSMutableArray new];
    if(_formTemplateDict[formTemplateId] != nil){
        FormTemplate *field = _formTemplateDict[formTemplateId];
        array = [FormTemplateField mj_objectArrayWithKeyValuesArray:[field.fields mj_keyValues]];
    }
    return array;
}




-(void)saveFormData:(NSMutableArray<FormData *> *)formDatas{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_SAVE_FORMDATA];
    [HttpUtil post:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            
            
        }else{
            
        }
    }];
}

-(void)deleteFormData:(NSString *)formDataId{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_DELETE_FORMDATA,formDataId];
    [HttpUtil post:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            
            
        }else{
            
        }
    }];
}

@end
