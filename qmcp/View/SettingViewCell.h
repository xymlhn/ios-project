//
//  SettingViewCell.h
//  qmcp
//
//  Created by 谢永明 on 16/4/10.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
@interface SettingViewCell : UITableViewCell

@property (nonatomic,strong) UISwitch *jsSwitch;

@property (nonatomic,strong) UILabel *jsText;

@property (nonatomic,strong) UILabel *iconView;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)initSetting:(BOOL)on contentText:(NSString *)content icon:(NSString *)image;
@end
