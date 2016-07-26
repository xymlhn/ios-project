//
//  WorkOrderCameraCell.h
//  qmcp
//
//  Created by 谢永明 on 16/5/14.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CameraData;
@interface WorkOrderCameraCell : UITableViewCell

@property (nonatomic, strong) CameraData *cameraData;
@property (nonatomic, strong) UISwitch *switchBtn;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *cameraIcon;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
