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
#import "CameraView.h"
#import "ScanViewController.h"
#import "QrCodeViewController.h"
@interface WorkOrderCameraController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) CameraView *camreaView;
@property (nonatomic, strong) NSMutableArray<CameraData *> *cameraArr;
@property (nonatomic, strong) CameraData *currentCamera;
@end

@implementation WorkOrderCameraController

#pragma mark - BaseWorkOrderViewController

-(void)loadView{
    _camreaView = [CameraView new];
    self.view = _camreaView;
    self.title = @"摄像头";
}

-(void)bindListener{
    _camreaView.tableView.delegate = self;
    _camreaView.tableView.dataSource = self;
    __weak typeof(self) weakSelf = self;
    _camreaView.scanBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        if(!_currentCamera){
            if([Config getQuickScan]){
                ScanViewController *scanViewController = [ScanViewController doneBlock:^(NSString *textValue) {
                    [weakSelf handleQrCode:textValue];
                }];
                [self.navigationController pushViewController:scanViewController animated:YES];
            }else{
                QrCodeViewController *info = [QrCodeViewController doneBlock:^(NSString *textValue) {
                    [weakSelf handleQrCode:textValue];
                }];
                [self.navigationController pushViewController:info animated:YES];
            }

        }else{
            [Utils showHudTipStr:@"请关闭当前摄像头"];
        }
        return [RACSignal empty];
    }];
    
    _camreaView.switchBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self closeCamera:_currentCamera];
        return [RACSignal empty];
    }];
}

-(void)handleQrCode:(NSString *)qrCode{
    CameraData *cameraData = [CameraData new];
    cameraData.cameraCode = qrCode;
    [self openCamera:cameraData];
}
-(void)loadData{
    _cameraArr = [[CameraManager getInstance] getAllCameraData];
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.detailsLabel.text = @"正在获取摄像头";
    NSString *URLString  = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,
                            _funcType == FuncTypeWorkOrder ?QMCPAPI_WORKORDER_CURRENT_CAMERA : QMCPAPI_SALESORDER_CURRENT_CAMERA,
                            _code];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if(!error){
            if(!obj){
                hub.mode = MBProgressHUDModeCustomView;
                hub.detailsLabel.text = @"";
                [hub hideAnimated:YES];
                [weakSelf.camreaView updateConstraints:NO];
            }else{
                hub.mode = MBProgressHUDModeCustomView;
                hub.detailsLabel.text = @"";
                [hub hideAnimated:YES];
                CameraData *currentCamera = [CameraData mj_objectWithKeyValues:obj];
                [weakSelf.cameraArr enumerateObjectsUsingBlock:^(CameraData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj.cameraCode isEqualToString:currentCamera.cameraCode]){
                        weakSelf.currentCamera = obj;
                        weakSelf.camreaView.nameLabel.text = obj.cameraLocation;
                        [weakSelf.camreaView updateConstraints:YES];
                        [weakSelf.cameraArr removeObject:obj];
                        [weakSelf.camreaView.tableView reloadData];
                        *stop = YES;
                    }
                    
                }];
                
            }
        }else{
            [weakSelf.camreaView updateConstraints:NO];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cameraArr.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    //1 创建可重用的自定义的cell
    WorkOrderCameraCell *cell = [WorkOrderCameraCell cellWithTableView:tableView];
    //2 设置cell内部的子控件
    CameraData *cameraData = _cameraArr[row];
    cell.cameraData = cameraData;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.switchBtn.tag = row;
    cell.switchBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self switchAction:cell.switchBtn];
        return [RACSignal empty];
    }];
    return cell;
}

-(void)switchAction:(UIButton*)switchButton{
    
    NSUInteger tag = switchButton.tag;
    CameraData *cameraData = _cameraArr[tag];
    
    if(!_currentCamera){
        [self openCamera:cameraData];
    }else{
        if([_currentCamera.cameraCode isEqualToString:cameraData.cameraCode]){
            [self closeCamera:cameraData];
        }else{
            [self.camreaView.tableView reloadData];
            [Utils showHudTipStr:@"请关闭当前摄像头"];
        }
        
    }
}

-(void)openCamera:(CameraData *)cameraData{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hub.detailsLabel.text = @"打开摄像头中...";
    __weak typeof(self) weakSelf = self;
    [[CameraManager getInstance] switchCameraByCode:_code withCameraCode:cameraData.cameraCode andFuncType:_funcType cameraStatus:YES finishBlock:^(NSDictionary *dict, NSString *error) {
        if (!error) {
            CameraData *data = [CameraData mj_objectWithKeyValues:dict];
            [weakSelf.cameraArr enumerateObjectsUsingBlock:^(CameraData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj.cameraCode isEqualToString:data.cameraCode]){
                    weakSelf.currentCamera = obj;
                    weakSelf.camreaView.nameLabel.text = obj.cameraLocation;
                    [weakSelf.cameraArr removeObject:obj];
                    [weakSelf.camreaView.tableView reloadData];
                     [weakSelf.camreaView updateConstraints:YES];
                    *stop = YES;
                }
                
            }];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.detailsLabel.text = @"打开摄像头成功";
            [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
    }];
}


-(void)closeCamera:(CameraData *)cameraData{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hub.detailsLabel.text = @"关闭摄像头";
    [[CameraManager getInstance] switchCameraByCode:_code withCameraCode:_currentCamera.cameraCode andFuncType:_funcType cameraStatus:NO finishBlock:^(NSDictionary *dict, NSString *error) {
        if (!error) {
            weakSelf.cameraArr = [[CameraManager getInstance] getAllCameraData];
            weakSelf.currentCamera = nil;
            [weakSelf.camreaView.tableView reloadData];
            [weakSelf.camreaView updateConstraints:NO];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.detailsLabel.text = @"关闭摄像头成功";
            [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            
        }else{
            
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
        
    }];
}
@end
