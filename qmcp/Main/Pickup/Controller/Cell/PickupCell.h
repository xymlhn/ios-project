//
//  PickupCell.h
//  qmcp
//
//  Created by 谢永明 on 16/7/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemComplete.h"
#import "PickupItem.h"

@interface PickupCell : UITableViewCell

@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *statusText;
@property(nonatomic,strong)UILabel *nameText;
@property(nonatomic,strong)UISwitch *chooseSwitch;
@property (nonatomic, strong) PickupItem *pickupItem;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
