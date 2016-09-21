//
//  CacheCell.h
//  qmcp
//
//  Created by 谢永明 on 16/8/17.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface CacheCell : UITableViewCell

@property (nonatomic,strong) UILabel *fontIcon;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *sizeLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(void)setCacheSize:(NSString *)size;
@end
