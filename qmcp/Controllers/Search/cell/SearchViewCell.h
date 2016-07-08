//
//  SearchViewCell.h
//  qmcp
//
//  Created by 谢永明 on 16/7/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrderSearchResult.h"

@interface SearchViewCell : UITableViewCell

@property (nonatomic, strong) WorkOrderSearchResult *workOrderSearchResult;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
