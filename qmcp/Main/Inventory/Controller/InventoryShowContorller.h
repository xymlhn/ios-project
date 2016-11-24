//
//  InventoryShowContorller.h
//  qmcp
//
//  Created by 谢永明 on 2016/11/24.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseViewController.h"

@interface InventoryShowContorller : BaseViewController

@property (nonatomic,strong) NSMutableArray<CommoditySnapshot *> *chooseCommodityList;

@property (copy, nonatomic) void(^doneBlock)(NSMutableArray<CommoditySnapshot *> *commodies);

+ (instancetype) doneBlock:(void(^)(NSMutableArray<CommoditySnapshot *> *commodies))block;
@end
