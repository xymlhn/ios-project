//
//  FormTemplateCell.h
//  qmcp
//
//  Created by 谢永明 on 16/6/13.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormTemplateBrife.h"

@interface FormTemplateCell : UITableViewCell

@property (nonatomic, strong) FormTemplateBrife *formTemplateBrife;
@property (nonatomic, strong) UILabel *sort;
@property (nonatomic, strong) UILabel *name;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
