//
//  SideMenuControllerTableViewCell.h
//  qmcp
//
//  Created by 谢永明 on 16/3/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SideMenuCell : UITableViewCell

/**
 *  设置内容和图标
 *
 *  @param content 内容
 *  @param icon    awesomefont字体
 */
-(void)setContent:(NSString *)content andIcon:(NSString *)icon;

+ (instancetype)SideMenuCellWithTableView:(UITableView *)tableView;

@end
