//
//  WorkOrderInfoController.m
//  qmcp
//
//  Created by 谢永明 on 16/3/24.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderInfoController.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"
#import "WorkOrder.h"
#import "NSObject+LKDBHelper.h"
#import "Utils.h"
#import "UIColor+Util.h"
#import "WorkOrderStepController.h"
#import "WorkOrderInventoryController.h"
#import "WorkOrderInfoView.h"
#import "EnumUtil.h"
#import "WorkOrderManager.h"
#import "MBProgressHUD.h"
#import "WorkOrderFormsController.h"
#import "WorkOrderCameraController.h"
#import "WorkOrderStep.h"
#import "QrCodeIdentityController.h"
@interface WorkOrderInfoController ()
@property (nonatomic,strong)WorkOrderInfoView *infoView;
@property (nonatomic,copy)WorkOrder *workOrder;
@property (nonatomic, retain) NSMutableArray *workOrderStepList;
@end

@implementation WorkOrderInfoController

#pragma mark - BaseWorkOrderViewController
-(void)initView
{
    _infoView = [WorkOrderInfoView new];
    [_infoView initView:self.view];
 
}
-(void)bindListener
{
    _infoView.starBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        switch (_workOrder.type) {
            case WorkOrderTypeOnsite:
                switch (_workOrder.onSiteStatus) {
                    case OnSiteStatusWaiting:
                        [self updateTimeStampWithWorkOrderCode:[super workOrderCode] andTimeStamp:WorkOrderTimeStampAcknowledge andDate:[Utils formatDate:[NSDate new]]];
                        break;
                    case OnSiteStatusNotDepart:
                        [self updateTimeStampWithWorkOrderCode:[super workOrderCode] andTimeStamp:WorkOrderTimeStampEnroute andDate:[Utils formatDate:[NSDate new]]];
                        
                        break;
                    case OnSiteStatusOnRoute:
                        [self updateTimeStampWithWorkOrderCode:[super workOrderCode] andTimeStamp:WorkOrderTimeStampOnsite andDate:[Utils formatDate:[NSDate new]]];
                        break;

                    default:
                        [self showOkayCancelAlert];
                        break;
                }
                break;
            case WorkOrderTypeInventory:
                [self showOkayCancelAlert];
                break;
            case WorkOrderTypeService:
                [self showOkayCancelAlert];
                break;
            default:
                break;
        }
        return [RACSignal empty];
    }];
    
}

-(void)loadData
{
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",super.workOrderCode];
    _workOrder = [WorkOrder searchSingleWithWhere:workWhere orderBy:nil];
    NSString *where = [NSString stringWithFormat:@"workOrderCode = '%@'",super.workOrderCode];
    _workOrderStepList = [WorkOrderStep searchWithWhere:where];
    _infoView.workOrder = _workOrder;
    [self setTextWithWorkOrder:_workOrder];
    
    _infoView.stepBtn.userInteractionEnabled = YES;
    [_infoView.stepBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stepBtnClick:)]];
    
    _infoView.cameraBtn.userInteractionEnabled = YES;
    [_infoView.cameraBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraBtnClick:)]];
    
    _infoView.inventoryBtn.userInteractionEnabled = YES;
    [_infoView.inventoryBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inventoryBtnClick:)]];
    
    _infoView.formBtn.userInteractionEnabled = YES;
    [_infoView.formBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(formBtnClick:)]];
    
    _infoView.qrCodeBtn.userInteractionEnabled = YES;
    [_infoView.qrCodeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrCodeBtnClick:)]];
}


-(void)setTextWithWorkOrder:(WorkOrder *)workOrder
{
    _infoView.remarkText.text = workOrder.salesOrderSnapshot.remark;
    _infoView.serviceText.text = workOrder.salesOrderSnapshot.organizationName;
    _infoView.appointmentTimeText.text = workOrder.salesOrderSnapshot.appointmentTime;
    
    _infoView.locationText.text = workOrder.salesOrderSnapshot.addressSnapshot.addressDetail;
    _infoView.passwordText.text = workOrder.salesOrderSnapshot.addressSnapshot.mobilePhone;
    _infoView.userNameText.text = workOrder.salesOrderSnapshot.addressSnapshot.contacts;
    _infoView.codeContent.text = workOrder.code;
    NSString *title;
    if(workOrder.status == WorkOrderStatusCompleted)
    {
        title = @"查看";
    }else{
         _infoView.typeText.text = [EnumUtil workOrderTypeString:workOrder.type];
        switch (workOrder.type) {
            case WorkOrderTypeOnsite:
                switch (_workOrder.onSiteStatus) {
                    case OnSiteStatusWaiting:
                        title = @"接收";
                        break;
                    case OnSiteStatusNotDepart:
                        title = @"出发";
                        break;
                    case OnSiteStatusOnRoute:
                        title = @"到达";
                        break;
                    default:
                        title = @"完结";
                        break;
                }

                break;
            case WorkOrderTypeInventory:
                title = @"完结";
                break;
            case WorkOrderTypeService:

                title = @"完结";
                
                break;
            default:
                break;
        }
        [_infoView.starBtn setTitle:title forState:UIControlStateNormal];
    }
    
}

/**
 *  更新工单时间戳
 *
 *  @param workOrderCode 工单code
 *  @param timeStamp     TimeStamp枚举
 *  @param time          date
 */
-(void)updateTimeStampWithWorkOrderCode:(NSString *)workOrderCode andTimeStamp:(WorkOrderTimeStamp)timeStamp andDate:(NSString *)time{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在提交数据";
    hub.userInteractionEnabled = NO;
    NSDictionary *dict = @{@"timestamp":[NSNumber numberWithInt:timeStamp],@"value":time};
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_TIMESTAMP,workOrderCode];
    [[WorkOrderManager getInstance] updateTimeStampWithURL:URLString andParams:dict finishBlock:^(NSDictionary *obj, NSString *error) {
        if(!error){
            weakSelf.workOrder.isFailed = NO;
            [weakSelf.workOrder saveToDB];
            [[WorkOrderManager getInstance] sortAllWorkOrder];
            hub.labelText = [NSString stringWithFormat:@"提交数据成功"];
            [hub hide:YES afterDelay:1];
            switch (weakSelf.workOrder.status) {
                case WorkOrderStatusAssigned:
                    [weakSelf.infoView.starBtn setTitle:@"出发" forState:UIControlStateNormal];
                    weakSelf.workOrder.status = WorkOrderStatusAcknowledged;
                    [weakSelf.workOrder saveToDB];
                    break;
                case WorkOrderStatusAcknowledged:
                    [weakSelf.infoView.starBtn setTitle:@"到达" forState:UIControlStateNormal];
                    weakSelf.workOrder.status = WorkOrderStatusEnroute;
                    [weakSelf.workOrder saveToDB];
                    break;
                case WorkOrderStatusEnroute:
                    [weakSelf.infoView.starBtn setTitle:@"完结" forState:UIControlStateNormal];
                    weakSelf.workOrder.status = WorkOrderStatusOnSite;
                    [weakSelf.workOrder saveToDB];
                    [self loadData];
                    break;
                default:
                    [weakSelf.infoView.starBtn setTitle:@"完结" forState:UIControlStateNormal];
                    weakSelf.workOrder.status = WorkOrderStatusOnSite;
                    [weakSelf.workOrder saveToDB];
                    break;
            }
        }else{
            weakSelf.workOrder.isFailed = YES;
            [weakSelf.workOrder saveToDB];
            [[WorkOrderManager getInstance] sortAllWorkOrder];
            NSString *message = @"";
            if(obj == nil){
                message =@"提交数据失败,请重试";
            }else{
                message = [obj valueForKey:@"message"];
            }
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = message;
            [hub hide:YES afterDelay:1];
        }
    }];
    
}

#pragma mark - IBAction
-(void)stepBtnClick:(UITapGestureRecognizer *)recognizer
{
    if(_workOrder.type == WorkOrderTypeOnsite){
        if(_workOrder.onSiteStatus != OnSiteStatusArrived){
            return;
        }
    }
    
    WorkOrderStepController *info = [WorkOrderStepController new];
    info.workOrderCode = [super workOrderCode];
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

-(void)inventoryBtnClick:(UITapGestureRecognizer *)recognizer
{
    if(_workOrder.type == WorkOrderTypeOnsite){
        if(_workOrder.onSiteStatus != OnSiteStatusArrived){
            return;
        }
    }
    WorkOrderInventoryController *info = [WorkOrderInventoryController new];
    info.workOrderCode = [super workOrderCode];
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)cameraBtnClick:(UITapGestureRecognizer *)recognizer
{
    WorkOrderCameraController *info =[WorkOrderCameraController new];
    info.workOrderCode = [super workOrderCode];
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}
- (void)formBtnClick:(UITapGestureRecognizer *)recognizer
{
    if(_workOrder.type == WorkOrderTypeOnsite){
        if(_workOrder.onSiteStatus != OnSiteStatusArrived){
            return;
        }
    }
    WorkOrderFormsController *info =[WorkOrderFormsController new];
    info.workOrderCode = [super workOrderCode];
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}


-(void)qrCodeBtnClick:(UITapGestureRecognizer *)recognizer
{
    QrCodeIdentityController *controller = [QrCodeIdentityController new];

    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.qrCodeUrl = _workOrder.qrCodeUrl;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        controller.providesPresentationContextTransitionStyle = YES;
        controller.definesPresentationContext = YES;
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.tabBarController presentViewController:controller animated:YES completion:nil];
        
    } else {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:controller animated:NO completion:nil];
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}


- (void)showOkayCancelAlert {
    NSString *title = @"提示";
    NSString *message = @"是否完结工单？";
    NSString *cancelButtonTitle = @"否";
    NSString *otherButtonTitle = @"是";
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf postWorkOrderStepWithWorkOrder:_workOrder andStepArray:_workOrderStepList];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)postWorkOrderStepWithWorkOrder:(WorkOrder *)workOrder andStepArray:(NSArray *)steps{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在上传工单步骤";
    hub.userInteractionEnabled = NO;
    NSDictionary *stepDict = @{@"steps":[WorkOrderStep mj_keyValuesArrayWithObjectArray:steps]};
    NSDictionary *dict = @{@"code":workOrder.code,@"status":[NSNumber numberWithInteger:workOrder.status],@"processDetail":stepDict};
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_POSTWORKORDERSTEP,workOrder.code];
    [[WorkOrderManager getInstance] postWorkOrderStepWithURL:URLString andParams:dict finishBlock:^(NSDictionary *obj,NSString *error){
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
                            NSString *message = @"";
                            if(obj == nil){
                                message =@"上传工单附件失败,请重试";
                            }else{
                                message = [obj valueForKey:@"message"];
                            }
                            hub.mode = MBProgressHUDModeCustomView;
                            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                            hub.labelText = message;
                            [hub hide:YES afterDelay:1];
                        }
                    }];
                }
            }else
            {
                hub.labelText = [NSString stringWithFormat:@"上传工单步骤成功"];
                [hub hide:YES afterDelay:1];
                
                [self updateTimeStampWithWorkOrderCode:workOrder.code andTimeStampEnum:WorkOrderTimeStampComplete andDate:[Utils formatDate:[NSDate new]]];
                
            }
        }else{
            weakSelf.workOrder.isFailed = YES;
            [weakSelf.workOrder saveToDB];
            [[WorkOrderManager getInstance] sortAllWorkOrder];
            NSString *message = @"";
            if(obj == nil){
                message =@"上传工单步骤失败,请重试";
            }else{
                message = [obj valueForKey:@"message"];
            }
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = message;
            [hub hide:YES afterDelay:1];
            
        }
    }];
}


-(void)updateTimeStampWithWorkOrderCode:(NSString *)workOrderCode andTimeStampEnum:(WorkOrderTimeStamp)timeStamp andDate:(NSString *)time{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在完结工单";
    hub.userInteractionEnabled = NO;
    NSDictionary *dict = @{@"timestamp":[NSNumber numberWithInt:timeStamp],@"value":time};
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_TIMESTAMP,workOrderCode];
    [[WorkOrderManager getInstance] updateTimeStampWithURL:URLString andParams:dict finishBlock:^(NSDictionary *obj, NSString *error) {
        if(!error){
            hub.labelText = [NSString stringWithFormat:@"完结工单成功"];
            [hub hide:YES afterDelay:1];

            [weakSelf.workOrder deleteToDB];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [[WorkOrderManager getInstance] sortAllWorkOrder];
        }else{
            weakSelf.workOrder.isFailed = YES;
            [[WorkOrderManager getInstance] sortAllWorkOrder];
            [weakSelf.workOrder saveToDB];
            NSString *message = @"";
            if(obj == nil){
                message =@"完结工单失败,请重试";
            }else{
                message = [obj valueForKey:@"message"];
            }
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = message;
            [hub hide:YES afterDelay:1];
        }
    }];
    
}

@end
