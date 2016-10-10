//
//  SalesOrderCameraController.m
//  qmcp
//
//  Created by 谢永明 on 2016/9/23.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderCameraController.h"
#import "CameraData.h"
#import "WorkOrderCameraCell.h"
#import "CameraManager.h"
@interface SalesOrderCameraController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cameraArr;
@property (nonatomic, strong) CameraData *currentCamera;

@end

@implementation SalesOrderCameraController

-(void)setupView
{
    self.title = @"摄像头";
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
    
}

-(void)bindListener
{
    
}

-(void)loadData
{
    _cameraArr = [[CameraManager getInstance] getAllCameraData];
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在获取摄像头";
    hub.userInteractionEnabled = NO;
    [[CameraManager getInstance] getCurrentCameraBySalesOrderCode:_code finishBlock:^(NSDictionary *obj, NSString *error) {
        if(!error){
            if(!obj){
                hub.mode = MBProgressHUDModeCustomView;
                hub.labelText = @"当前订单没有设置摄像头";
                [hub hide:YES afterDelay:kEndFailedDelayTime];
            }else{
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                hub.labelText = [NSString stringWithFormat:@"获取摄像头成功"];
                [hub hide:YES afterDelay:kEndSucceedDelayTime];
                
                CameraData *currentCamera = [CameraData mj_objectWithKeyValues:obj];
                for(CameraData *cameraData in weakSelf.cameraArr){
                    if([cameraData.cameraCode isEqualToString:currentCamera.cameraCode]){
                        cameraData.isChoose = YES;
                        weakSelf.currentCamera = cameraData;
                        [weakSelf.tableView reloadData];
                    }
                }
            }
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kEndFailedDelayTime];
        }
    }];
}

-(void)saveData{
    
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
    cell.switchBtn.tag = row;
    [cell.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

-(void)switchAction:(UISwitch*)switchButton
{
    
    NSUInteger tag = switchButton.tag;
    CameraData *cameraData = _cameraArr[tag];
    
    if(!_currentCamera){
        MBProgressHUD *hub = [Utils createHUD];
        hub.labelText = @"打开摄像头中...";
        hub.userInteractionEnabled = NO;
        [[CameraManager getInstance] switchCameraBySalesOrderCode:_code withCameraCode:cameraData.cameraCode cameraStatus:YES finishBlock:^(NSDictionary *obj, NSString *error) {
            if (!error) {
                CameraData *data = [CameraData mj_objectWithKeyValues:obj];
                for(CameraData *cameraData in _cameraArr){
                    if([cameraData.cameraCode isEqualToString:data.cameraCode]){
                        cameraData.isChoose = true;
                        _currentCamera = cameraData;
                    }
                }
                [self.tableView reloadData];
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                hub.labelText = @"打开摄像头成功";
                [hub hide:YES afterDelay:kEndSucceedDelayTime];
                
            }else{
                [self.tableView reloadData];
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                hub.labelText = error;
                [hub hide:YES afterDelay:kEndFailedDelayTime];
            }
        }];
    }else{
        
        if([_currentCamera.cameraCode isEqualToString:cameraData.cameraCode]){
            MBProgressHUD *hub = [Utils createHUD];
            hub.labelText = @"关闭摄像头";
            hub.userInteractionEnabled = NO;
            [[CameraManager getInstance] switchCameraBySalesOrderCode:_code withCameraCode:_currentCamera.cameraCode cameraStatus:NO finishBlock:^(NSDictionary *obj, NSString *error) {
                if (!error) {
                    CameraData *currentCamera = [CameraData mj_objectWithKeyValues:obj];
                    for(CameraData *cameraData in _cameraArr){
                        if([cameraData.cameraCode isEqualToString:currentCamera.cameraCode]){
                            cameraData.isChoose = NO;
                        }
                    }
                    _currentCamera = nil;
                    [self.tableView reloadData];
                    hub.mode = MBProgressHUDModeCustomView;
                    hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                    hub.labelText = @"关闭摄像头成功";
                    [hub hide:YES afterDelay:kEndSucceedDelayTime];
                    
                }else{
                    
                    hub.mode = MBProgressHUDModeCustomView;
                    hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                    hub.labelText = error;
                    [hub hide:YES afterDelay:kEndFailedDelayTime];
                }
            }];
        }else{
            [self.tableView reloadData];
            [Utils showHudTipStr:@"请关闭当前摄像头"];
        }
    }

}
@end
