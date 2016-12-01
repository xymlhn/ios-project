//
//  WorkOrderSearchResult.h
//  qmcp
//
//  Created by 谢永明 on 16/7/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkOrder.h"

@interface WorkOrderSearchResult : NSObject

@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *salesOrderCode;

@property (nonatomic,copy) NSString *salesOrderCreationTime;

@property (nonatomic,assign) BOOL *dispatchToMeFlag;

@property (nonatomic, assign) WorkOrderStatus status;

@property (nonatomic, assign) WorkOrderType type;


@end
