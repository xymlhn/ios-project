//
//  WorkOrderCameraController.m
//  qmcp
//
//  Created by 谢永明 on 16/5/14.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderCameraController.h"
#import "CameraManager.h"
#import "WorkOrderCameraCell.h"
#import "CameraData.h"
#import "UITableView+Common.h"

@interface WorkOrderCameraController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cameraArr;
@property (nonatomic, strong) CameraData *currentCamera;
@end

@implementation WorkOrderCameraController

#pragma mark - BaseWorkOrderViewController
-(void)initView
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
    [[CameraManager getInstance] getCurrentCameraByWorkOrderCode:[super workOrderCode] finishBlock:^(NSDictionary *obj, NSString *error) {
        if(!error){
            if(!obj){
                hub.mode = MBProgressHUDModeCustomView;
                hub.labelText = @"当前工单没有设置摄像头";
                [hub hide:YES afterDelay:1.5];
            }else{
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                hub.labelText = [NSString stringWithFormat:@"获取摄像头成功"];
                [hub hide:YES];
                
                CameraData *currentCamera = [CameraData mj_objectWithKeyValues:obj];
                for(CameraData *cameraData in weakSelf.cameraArr){
                    if([cameraData.cameraCode isEqualToString:currentCamera.cameraCode]){
                        cameraData.isChoose = YES;
                        weakSelf.currentCamera = cameraData;
                    }
                }
            }
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:1];
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
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
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
        [[CameraManager getInstance] switchCameraByWorkOrderCode:[super workOrderCode] withCameraCode:cameraData.cameraCode cameraStatus:YES finishBlock:^(NSDictionary *obj, NSString *error) {
            if (!error) {
                CameraData *data = [CameraData mj_objectWithKeyValues:obj];
                for(CameraData *cameraData in _cameraArr){
                    if([cameraData.cameraCode isEqualToString:data.cameraCode]){
                        cameraData.isChoose = true;
                        _currentCamera = cameraData;
                    }
                }

                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                hub.labelText = @"打开摄像头成功";
                [hub hide:YES afterDelay:0.5];
                
            }else{
                
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                hub.labelText = error;
                [hub hide:YES afterDelay:1.5];
            }
        }];
    }else{
        
        if([_currentCamera.cameraCode isEqualToString:cameraData.cameraCode]){
            MBProgressHUD *hub = [Utils createHUD];
            hub.labelText = @"关闭摄像头";
            hub.userInteractionEnabled = NO;
            [[CameraManager getInstance] switchCameraByWorkOrderCode:[super workOrderCode] withCameraCode:_currentCamera.cameraCode cameraStatus:NO finishBlock:^(NSDictionary *obj, NSString *error) {
                if (!error) {
                    CameraData *currentCamera = [CameraData mj_objectWithKeyValues:obj];
                    for(CameraData *cameraData in _cameraArr){
                        if([cameraData.cameraCode isEqualToString:currentCamera.cameraCode]){
                            cameraData.isChoose = NO;
                        }
                    }
                    _currentCamera = nil;
                    hub.mode = MBProgressHUDModeCustomView;
                    hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                    hub.labelText = @"关闭摄像头成功";
                    [hub hide:YES afterDelay:0.5];
                    
                }else{
                    
                    hub.mode = MBProgressHUDModeCustomView;
                    hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                    hub.labelText = error;
                    [hub hide:YES afterDelay:1.5];
                }
            }];
        }else{
            MBProgressHUD *hub = [Utils createHUD];
            hub.labelText = @"打开摄像头中...";
            hub.userInteractionEnabled = NO;
            [[CameraManager getInstance] switchCameraByWorkOrderCode:[super workOrderCode] withCameraCode:_currentCamera.cameraCode cameraStatus:NO finishBlock:^(NSDictionary *obj, NSString *error) {
                if (!error) {
                    [[CameraManager getInstance] switchCameraByWorkOrderCode:[super workOrderCode] withCameraCode:cameraData.cameraCode cameraStatus:YES finishBlock:^(NSDictionary *obj, NSString *error) {
                        if (!error) {
                            CameraData *currentCamera = [CameraData mj_objectWithKeyValues:obj];
                            for(CameraData *cameraData in _cameraArr){
                                if([cameraData.cameraCode isEqualToString:currentCamera.cameraCode]){
                                    cameraData.isChoose = true;
                                    _currentCamera = cameraData;
                                }
                            }
                            hub.mode = MBProgressHUDModeCustomView;
                            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                            hub.labelText = @"打开摄像头成功";
                            [hub hide:YES afterDelay:0.5];
                            [_tableView reloadData];
                            
                        }else{
                            hub.mode = MBProgressHUDModeCustomView;
                            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                            hub.labelText = error;
                            [hub hide:YES afterDelay:1.5];
                        }
                    }];
                    
                    
                }else{
                    
                    hub.mode = MBProgressHUDModeCustomView;
                    hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                    hub.labelText = error;
                    [hub hide:YES afterDelay:1.5];
                }
            }];
        }
    }
}

@end
