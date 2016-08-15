//
//  InventorySearchCell.h
//  qmcp
//
//  Created by 谢永明 on 16/8/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesOrderSearchResult.h"

@interface InventorySearchCell : UITableViewCell
@property (nonatomic, strong) SalesOrderSearchResult *salesOrderSearchResult;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
