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
@implementation FormManager

+ (FormManager *)getInstance {
    static FormManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

-(void)getFormTemplate:(NSString *)salesOrderCode{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_FORMTEMPLATE,salesOrderCode];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            
            
        }else{
            [self getFormTemplate:salesOrderCode];
        }
    }];
}

-(void)getFormData:(NSString *)salesOrderCode{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_FORMDATA,salesOrderCode];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            
            
        }else{
            [self getFormTemplate:salesOrderCode];
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
