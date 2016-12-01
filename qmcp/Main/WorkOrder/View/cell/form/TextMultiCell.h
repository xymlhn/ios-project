//
//  TextMultiCell.h
//  qmcp
//
//  Created by 谢永明 on 16/7/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormTemplateField.h"
@interface TextMultiCell : UITableViewCell
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UITextView *value;
@property (nonatomic, strong) FormTemplateField *field;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
