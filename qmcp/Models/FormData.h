//
//  FormData.h
//  qmcp
//
//  Created by 谢永明 on 16/5/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormData : NSObject

@property (nonatomic,copy) NSString *formDataId;
@property (nonatomic,copy) NSString *formTemplateId;
@property (nonatomic,copy) NSString *salesOrderCode;
@property (nonatomic,copy) NSString *creatorOpenId;
@property (nonatomic,copy) NSString *signatureImage;
@property (nonatomic,assign) int orderNumber;
@property (nonatomic,assign) bool completeFlag;
@property (nonatomic,strong) NSMutableDictionary<NSString *,NSString *> *formData;

@end
