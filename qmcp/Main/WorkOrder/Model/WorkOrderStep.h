//
//  WorkOrderStep.h
//  qmcp
//
//  Created by 谢永明 on 16/3/11.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkOrderStep : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *submitTime;

@property (nonatomic, copy) NSString *workOrderCode;

@property (nonatomic, copy) NSString *salesOrderCode;

@property (nonatomic, copy) NSString *submitUser;

@property (nonatomic, copy) NSString *stepName;

@property (nonatomic, copy) NSString *userOpenId;

@property (nonatomic, copy) NSMutableArray *attachments;
@end
