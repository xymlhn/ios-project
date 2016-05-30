//
//  WorkOrderCameraController.m
//  qmcp
//
//  Created by 谢永明 on 16/5/14.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderCameraController.h"
#import "CameraManager.h"
#import "WorkOrderListCell.h"
#import "WorkOrderCameraCell.h"
#import "CameraData.h"
#import "UITableView+Common.h"

@interface WorkOrderCameraController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cameraArr;
@end

@implementation WorkOrderCameraController

#pragma mark - BaseWorkOrderViewController
-(void)initView
{
    _tableView = [UITableView new];
    _tableView.rowHeight = 45;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor themeColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraUpdate:) name:kCameraNotification object:nil];
}

-(void)bindListener
{
    
}

-(void)loadData
{
    _cameraArr = [NSMutableArray new];
    [[CameraManager getInstance] getCurrentCameraByWorkOrderCode:[super workOrderCode]];
}

-(void)saveData{
    
}


#pragma mark - Notification
- (void)cameraUpdate:(NSNotification *)text{
   
    [_cameraArr removeAllObjects];
    [_cameraArr addObjectsFromArray:text.userInfo[@"all_camera"]];
    [self.tableView reloadData];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cameraArr.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    //1 创建可重用的自定义的cell
    WorkOrderCameraCell *cell = [WorkOrderCameraCell cellWithTableView:tableView];
    //2 设置cell内部的子控件
    CameraData *cameraData = _cameraArr[row];
    cell.cameraData = cameraData;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
    cell.switchBtn.tag = row;
    [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

-(void)switchAction:(UISwitch*)switchButton
{
    
    NSUInteger tag = switchButton.tag;
    CameraData *cameraData = _cameraArr[tag];
    if(!cameraData.isChoose){
        CameraData *current = [self getCurrentOnCamera];
        if(current == nil){
            [[CameraManager getInstance] switchCameraByWorkOrderCode:[super workOrderCode] withCameraCode:cameraData.cameraCode cameraStatus:YES needOpen:NO];
        }else{
            [[CameraManager getInstance] setNeedOpenCamera:cameraData];
            [[CameraManager getInstance] switchCameraByWorkOrderCode:[super workOrderCode] withCameraCode:current.cameraCode cameraStatus:NO needOpen:YES];
        }
    }else{
        [[CameraManager getInstance] switchCameraByWorkOrderCode:[super workOrderCode] withCameraCode:cameraData.cameraCode cameraStatus:NO needOpen:NO];
    }
}

/**
 *  获取当前工单已选择的摄像头
 *
 *  @return 摄像头信息
 */
-(CameraData *)getCurrentOnCamera{
    for (CameraData *data in _cameraArr) {
        if(data.isChoose){
            return data;
        }
    }
    return nil;
}

@end
