//
//  WorkOrderCommodityStepController.h
//  qmcp
//
//  Created by 谢永明 on 16/9/1.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseViewController.h"

@interface CommodityStepController : BaseViewController
@property (nonatomic, strong)NSMutableArray *dataArray;//数据
@property (copy, nonatomic) void(^doneBlock)(NSString *textValue);

+ (instancetype) doneBlock:(void(^)(NSString *textValue))block;

@end
