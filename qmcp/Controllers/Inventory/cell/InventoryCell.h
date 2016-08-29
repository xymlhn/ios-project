//
//  WorkOrderInventoryCell.h
//  qmcp
//
//  Created by 谢永明 on 16/4/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemSnapshot.h"
 
@interface InventoryCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic, strong) ItemSnapshot  *itemSnapshot;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
