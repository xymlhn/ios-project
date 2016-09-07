//
//  InventoryChooseView.h
//  qmcp
//
//  Created by 谢永明 on 16/8/29.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface InventoryChooseView : BaseView

@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) UILabel *priceLabel;
+ (instancetype)viewInstance;

@end
