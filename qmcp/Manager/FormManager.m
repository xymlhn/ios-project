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

@interface FormManager()

@property (nonatomic, strong) NSMutableDictionary<NSString *,FormTemplate *> * formTemplateDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *,FormData *> * formDataDict;

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

-(void)getFormTemplate:(NSString *)salesOrderCode{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_FORMTEMPLATE,salesOrderCode];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            [_formTemplateDict removeAllObjects];
            NSArray *array = [FormTemplate mj_objectArrayWithKeyValuesArray:obj];
            for (FormTemplate *form in array) {
                [_formTemplateDict setValue:form forKey:form.formTemplateId];
            }
        }else{
            
        }
    }];
}

-(void)getFormData:(NSString *)salesOrderCode{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_FORMDATA,salesOrderCode];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            [_formDataDict removeAllObjects];
            NSArray *array = [FormData mj_objectArrayWithKeyValuesArray:obj];
            for (FormData *form in array) {
                [_formDataDict setValue:form forKey:form.formTemplateId];
            }
        }else{
            
        }
    }];
}

-(void)saveFormData:(NSMutableArray<FormData *> *)formDatas{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_SAVE_FORMDATA];
    [HttpUtil post:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            
            
        }else{
            
        }
    }];
}

-(void)deleteFormData:(NSString *)formDataId{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_DELETE_FORMDATA,formDataId];
    [HttpUtil post:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            
            
        }else{
            
        }
    }];
}

@end
