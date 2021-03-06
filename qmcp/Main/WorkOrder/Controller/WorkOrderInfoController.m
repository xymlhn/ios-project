//
//  WorkOrderInfoController.m
//  qmcp
//
//  Created by 谢永明 on 16/3/24.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderInfoController.h"
#import "WorkOrderStepController.h"
#import "InventoryController.h"
#import "WorkOrderInfoView.h"
#import "WorkOrderManager.h"
#import "WorkOrderFormsController.h"
#import "WorkOrderCameraController.h"
#import "WorkOrderStep.h"
#import "QrCodeIdentityController.h"
#import "YCXMenu.h"
@interface WorkOrderInfoController ()
@property (nonatomic,strong)WorkOrderInfoView *infoView;
@property (nonatomic,copy)WorkOrder *workOrder;
@property (nonatomic, retain) NSMutableArray *workOrderStepList;
@property (nonatomic,strong) NSMutableArray<NSString *> *tabIcon;
@property (nonatomic,strong) NSMutableArray<NSString *> *tabLabel;

@end

@implementation WorkOrderInfoController

-(NSMutableArray<NSString *> *)tabIcon{
    if (_tabIcon == nil) {
        _tabIcon = [@[@"tab_step",@"tab_form",@"tab_video",@"tab_qr"] mutableCopy];
    }
    return _tabIcon;
}

-(NSMutableArray<NSString *> *)tabLabel{
    if(_tabLabel == nil){
        _tabLabel = [@[@"步骤",@"表单",@"摄像头",@"二维码"] mutableCopy];
    }
    return _tabLabel;
}

#pragma mark - BaseWorkOrderViewController
-(void)loadView{
    _infoView = [WorkOrderInfoView viewInstance];
    self.view = _infoView;
    self.title = @"信息";
    
}

-(void)setupView{
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                            target:self
                                                                                            action:@selector(rightBtnClick)];
}

-(void)bindListener{
    _infoView.starBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        switch (_workOrder.onSiteStatus) {
            case OnSiteStatusNone:
            case OnSiteStatusNotDepart:
            case OnSiteStatusWaiting:
                [self p_updateTimeStampWithWorkOrderCode:_workOrderCode andTimeStamp:OnSiteTimeStampEnroute andDate:[Utils formatDate:[NSDate new]]];
                break;
            case OnSiteStatusOnRoute:
                [self p_updateTimeStampWithWorkOrderCode:_workOrderCode andTimeStamp:OnSiteTimeStampOnsite andDate:[Utils formatDate:[NSDate new]]];
                break;
            default:
                break;
        }
        return [RACSignal empty];
    }];
    
}

-(void)loadData{
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",_workOrderCode];
    _workOrder = [WorkOrder searchSingleWithWhere:workWhere orderBy:nil];
    NSString *where = [NSString stringWithFormat:@"workOrderCode = '%@'",_workOrderCode];
    _workOrderStepList = [WorkOrderStep searchWithWhere:where];
    _infoView.tabIcon = self.tabIcon;
    _infoView.tabLabel = self.tabLabel;
    _infoView.workOrder = _workOrder;
    [_infoView.tabView enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog ( @"frame: %@, bounds: %@" , NSStringFromCGRect (obj. frame), NSStringFromCGRect (obj. bounds ));
        obj.userInteractionEnabled = YES;
        [obj addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabBtnClick:)]];
    }];
}

#pragma mark - IBAction

-(void)tabBtnClick:(UITapGestureRecognizer *)recognizer{
    NSString *tagStr = self.tabLabel[recognizer.view.tag];
    if(_workOrder.type == WorkOrderTypeOnsite){
        if(_workOrder.onSiteStatus != OnSiteStatusArrived){
            [Utils showHudTipStr:@"请先完成上门步骤"];
            return;
        }
    }
    if ([tagStr isEqualToString:@"步骤"]) {
        WorkOrderStepController *info = [WorkOrderStepController new];
        info.code = _workOrderCode;
        info.funcType = FuncTypeWorkOrder;
        info.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:info animated:YES];
    }else if ([tagStr isEqualToString:@"表单"]){
        WorkOrderFormsController *info =[WorkOrderFormsController new];
        info.code = _workOrder.salesOrderSnapshot.code;;
        info.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:info animated:YES];
    }else if ([tagStr isEqualToString:@"摄像头"]){
        WorkOrderCameraController *info =[WorkOrderCameraController new];
        info.code = _workOrderCode;
        info.funcType = FuncTypeWorkOrder;
        info.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:info animated:YES];
    }else if ([tagStr isEqualToString:@"二维码"]){
        QrCodeIdentityController *controller = [QrCodeIdentityController new];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.qrCodeUrl = _workOrder.qrCodeUrl;
        controller.providesPresentationContextTransitionStyle = YES;
        controller.definesPresentationContext = YES;
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.tabBarController presentViewController:controller animated:YES completion:nil];
    }
}

-(void)rightBtnClick{
    [YCXMenu setTitleFont:[UIFont systemFontOfSize:kShisanpt]];
    [YCXMenu setTintColor:[UIColor blackColor]];
    [YCXMenu setSelectedColor:[UIColor redColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        NSArray *menuItems = @[[YCXMenuItem menuItem:@"完结订单" image:[UIImage imageNamed:@"menu_order_icon"] target:self action:@selector(completeClick)]];
        [YCXMenu showMenuInView:self.navigationController.view fromRect:CGRectMake(self.view.frame.size.width - 50, 55, 50, 0) menuItems:menuItems selected:^(NSInteger index, YCXMenuItem *item) {
            NSLog(@"%@",item);
        }];
    }
}

-(void)completeClick{
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否完结工单？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf p_postWorkOrderStepWithWorkOrder:_workOrder andStepArray:_workOrderStepList];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - func

/**
 *  更新工单时间戳
 *
 *  @param workOrderCode 工单code
 *  @param timeStamp     TimeStamp枚举
 *  @param time          date
 */
-(void)p_updateTimeStampWithWorkOrderCode:(NSString *)workOrderCode andTimeStamp:(OnSiteTimeStamp)timeStamp andDate:(NSString *)time{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hub.detailsLabel.text = @"正在提交数据";
    NSDictionary *dict = @{@"timestamp":[NSNumber numberWithInt:timeStamp],@"value":time};
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_TIMESTAMP,workOrderCode];
    
    [HttpUtil postFormData:URLString param:dict finish:^(NSDictionary *obj, NSString *error) {
        if(!error){
            weakSelf.workOrder.isFailed = NO;
            [weakSelf.workOrder saveToDB];
            [[WorkOrderManager getInstance] sortAllWorkOrder];
            hub.detailsLabel.text = [NSString stringWithFormat:@"提交数据成功"];
            [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            
            switch (weakSelf.workOrder.onSiteStatus) {
                case OnSiteStatusNone:
                case OnSiteStatusWaiting:
                case OnSiteStatusNotDepart:
                    [weakSelf.infoView.starBtn setTitle:@"到达" forState:UIControlStateNormal];
                    weakSelf.workOrder.onSiteStatus = OnSiteStatusOnRoute;
                    [weakSelf.workOrder saveToDB];
                    break;
                case OnSiteStatusOnRoute:
                    [weakSelf.infoView.starBtn setHidden:YES];
                    weakSelf.workOrder.onSiteStatus = OnSiteStatusArrived;
                    [weakSelf.workOrder saveToDB];
                    [weakSelf loadData];
                    break;
                default:
                    break;
            }
        }else{
            weakSelf.workOrder.isFailed = YES;
            [weakSelf.workOrder saveToDB];
            [[WorkOrderManager getInstance] sortAllWorkOrder];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
    }];
    
}

/**
 提交工单步骤

 @param workOrder 工单
 @param steps 工单步骤
 */
- (void)p_postWorkOrderStepWithWorkOrder:(WorkOrder *)workOrder andStepArray:(NSArray *)steps{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hub.detailsLabel.text = @"正在上传工单步骤";
    
    NSDictionary *stepDict = @{@"steps":[WorkOrderStep mj_keyValuesArrayWithObjectArray:steps]};
    NSDictionary *dict = @{@"code":workOrder.code,@"status":[NSNumber numberWithInteger:workOrder.status],@"processDetail":stepDict};
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_POSTWORKORDERSTEP,workOrder];
    [HttpUtil post:URLString param:dict finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            NSMutableArray *attachments = [NSMutableArray new];
            for (WorkOrderStep *step in steps) {
                for(Attachment *attachment in step.attachments)
                {
                    if(!attachment.isUpload){
                        [attachments addObject:attachment];
                    }
                }
                
            }
            if(attachments.count > 0){
                for(Attachment *attachment in attachments)
                {
                    [[WorkOrderManager getInstance] postAttachment:attachment finishBlock:^(NSDictionary *obj,NSString *error) {
                        if (!error) {
                            attachment.isUpload = YES;
                            [attachment updateToDB];
                        }else{
                            weakSelf.workOrder.isFailed = YES;
                            [weakSelf.workOrder saveToDB];
                            [[WorkOrderManager getInstance] sortAllWorkOrder];
                            hub.mode = MBProgressHUDModeCustomView;
                            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                            hub.detailsLabel.text = error;
                            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
                        }
                    }];
                }
            }else
            {
                hub.detailsLabel.text = [NSString stringWithFormat:@"上传工单步骤成功"];
                [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
                
                [self p_completeWorkOrder:workOrder.code andTimeStampEnum:OnSiteTimeStampComplete andDate:[Utils formatDate:[NSDate new]]];
                
            }
        }else{
            weakSelf.workOrder.isFailed = YES;
            [weakSelf.workOrder saveToDB];
            [[WorkOrderManager getInstance] sortAllWorkOrder];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
            
        }
        
    }];
    

}

/**
 完结工单

 @param workOrderCode 工单code
 @param timeStamp 时间戳
 @param time 时间
 */
-(void)p_completeWorkOrder:(NSString *)workOrderCode andTimeStampEnum:(OnSiteTimeStamp)timeStamp andDate:(NSString *)time{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hub.detailsLabel.text = @"正在完结工单";
    NSDictionary *dict = @{@"timestamp":[NSNumber numberWithInt:timeStamp],@"value":time};
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_TIMESTAMP,workOrderCode];
    [HttpUtil postFormData:URLString param:dict finish:^(NSDictionary *obj, NSString *error) {
        if(!error){
            hub.detailsLabel.text = [NSString stringWithFormat:@"完结工单成功"];
            [hub hideAnimated:YES afterDelay:1];
            
            [weakSelf.workOrder deleteToDB];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [[WorkOrderManager getInstance] sortAllWorkOrder];
        }else{
            weakSelf.workOrder.isFailed = YES;
            [[WorkOrderManager getInstance] sortAllWorkOrder];
            [weakSelf.workOrder saveToDB];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:1];
        }
    }];
    
    
    
}

@end
