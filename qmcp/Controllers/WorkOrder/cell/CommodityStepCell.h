//
//  CommodityStepCell.h
//  qmcp
//
//  Created by 谢永明 on 16/9/1.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityStepCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) UILabel *contentLabel;
@end
