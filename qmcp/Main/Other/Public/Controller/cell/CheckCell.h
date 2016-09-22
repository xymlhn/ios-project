//
//  CheckCell.h
//  qmcp
//
//  Created by 谢永明 on 16/7/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckCell : UITableViewCell

@property (nonatomic,strong) UISwitch *jsSwitch;

@property (nonatomic,strong) UILabel *jsText;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
