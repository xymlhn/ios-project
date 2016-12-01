//
//  ItemSnapshot.h
//  qmcp
//
//  Created by 谢永明 on 16/3/11.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemSnapshot : NSObject

@property (nonatomic, copy) NSString *itemSnapshotCode; //物品code，主键

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code; //二维码

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) float price;

@property (nonatomic, copy) NSMutableArray *commodities;

@property (nonatomic, copy) NSMutableArray *attachments;

@property (nonatomic, copy) NSString *salesOrderCode;

@property (nonatomic, assign) BOOL isUse;
@end
