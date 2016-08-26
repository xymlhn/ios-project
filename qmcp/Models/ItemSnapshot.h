//
//  ItemSnapshot.h
//  qmcp
//
//  Created by 谢永明 on 16/3/11.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemSnapshot : NSObject

@property (nonatomic, copy) NSString *salesOrderItemCode;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSMutableArray *commodities;

@property (nonatomic, copy) NSMutableArray *attachments;
\
@property (nonatomic, copy) NSString *salesOrderCode;

@property (nonatomic, assign) BOOL isUse;
@end
