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

-(void)getFormTemplate:(NSString *)salesOrderCode;

-(void)getFormData:(NSString *)salesOrderCode;

-(void)saveFormData:(NSMutableArray<FormData *> *)formDatas;

-(void)deleteFormData:(NSString *)formDataId;

@end
