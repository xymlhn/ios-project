//
//  PickupNoticeCell.h
//  qmcp
//
//  Created by 谢永明 on 16/7/7.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemComplete.h"

@interface PickupNoticeCell : UITableViewCell

@property(nonatomic,strong)UILabel *contentText;
@property (nonatomic, strong) ItemComplete *itemComplete;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
