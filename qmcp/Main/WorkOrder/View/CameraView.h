//
//  CameraView.h
//  qmcp
//
//  Created by 谢永明 on 2016/11/28.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface CameraView : BaseView
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong ) UIButton *scanBtn;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UIButton *switchBtn;

-(void)updateConstraints:(BOOL)show;
+ (instancetype)viewInstance;
@end
