//
//  InventoryChooseCell.h
//  qmcp
//
//  Created by 谢永明 on 16/8/29.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommoditySnapshot.h"

@interface InventoryChooseCell : UITableViewCell

@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic, strong) CommoditySnapshot *commoditySnapshot;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
