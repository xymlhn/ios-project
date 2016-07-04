//
//  ChooseCommodityCell.h
//  qmcp
//
//  Created by 谢永明 on 16/7/4.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyChoose.h"

@interface ChooseCommodityCell : UITableViewCell
@property (nonatomic, strong) PropertyChoose *propertyChoose;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
