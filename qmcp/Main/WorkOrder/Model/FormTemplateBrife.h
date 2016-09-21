//
//  FormTemplateBrife.h
//  qmcp
//
//  Created by 谢永明 on 16/6/12.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FormSort) {
    FormSortCreate = 10,//创建
    FormSortUpdate = 20,//编辑
    FormSortComplete = 30,//完成
};


@interface FormTemplateBrife : NSObject

@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) FormSort formSort;
@property (nonatomic,copy) NSString *formTemplateCode;

@end
