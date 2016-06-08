//
//  WorkOrderStepView.h
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface WorkOrderStepView : BaseView

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong ) UILabel     *addBtn;
@property (nonatomic,strong ) UILabel     *saveBtn;
@property (nonatomic,strong ) UILabel     *formBtn;
@property (nonatomic,strong ) UILabel     *cameraBtn;
@property (nonatomic,strong ) UILabel     *completeBtn;
@end
