//
//  SalesOrderBindCell.h
//  qmcp
//
//  Created by 谢永明 on 16/4/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesOrderSnapshot.h"

@interface SalesOrderBindCell : UITableViewCell

@property(nonatomic,strong)UILabel *typeText;
@property(nonatomic,strong)UILabel *codeText;
@property(nonatomic,strong)UILabel *commodityNameText;
@property(nonatomic,strong)UILabel *nameText;
@property(nonatomic,strong)UILabel *phoneText;


@property (nonatomic, strong) SalesOrderSnapshot *salesOrderSnapshot;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
