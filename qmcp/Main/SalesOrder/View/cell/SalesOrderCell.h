//
//  SalesOrderGrabCell.h
//  qmcp
//
//  Created by 谢永明 on 16/4/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesOrder.h"
@interface SalesOrderCell : UITableViewCell

@property(nonatomic,strong)UIImageView *typeImage;
@property(nonatomic,strong)UILabel *codeText;
@property(nonatomic,strong)UILabel *commodityNameText;
@property(nonatomic,strong)UILabel *nameText;
@property(nonatomic,strong)UILabel *phoneText;
@property(nonatomic,strong)UIButton *grabBtn;
@property (nonatomic, strong) SalesOrder *salesOrder;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
