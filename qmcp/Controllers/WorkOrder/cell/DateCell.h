//
//  DateCell.h
//  qmcp
//
//  Created by 谢永明 on 16/6/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormTemplateField.h"

@interface DateCell : UITableViewCell

@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *value;
@property (nonatomic, strong) FormTemplateField *field;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
