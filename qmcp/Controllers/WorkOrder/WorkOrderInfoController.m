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
                switch (_workOrder.status) {
                    case WorkOrderStatusAssigned:
                        [self updateTimeStampWithWorkOrderCode:[super workOrderCode] andTimeStamp:WorkOrderTimeStampAcknowledge andDate:[Utils formatDate:[NSDate new]]];
                        break;
                    case WorkOrderStatusAcknowledged:
                        [self updateTimeStampWithWorkOrderCode:[super workOrderCode] andTimeStamp:WorkOrderTimeStampEnroute andDate:[Utils formatDate:[NSDate new]]];
                        
                        break;
                    case WorkOrderStatusEnroute:
                        [self updateTimeStampWithWorkOrderCode:[super workOrderCode] andTimeStamp:WorkOrderTimeStampOnsite andDate:[Utils formatDate:[NSDate new]]];
                        break;
                    case WorkOrderStatusOnSite:
                        [self completeBtnClick];
                        break;
                    default:
                        break;
                }
                break;
            case WorkOrderTypeInventory:
                [self completeBtnClick];
                break;
            case WorkOrderTypeService:
                [self completeBtnClick];
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
    
    if(_workOrder.type == WorkOrderTypeOnsite && _workOrder.status != WorkOrderStatusOnSite){
        
    }else{
        _infoView.workOrder = _workOrder;

    }
    [self setTextWithWorkOrder:_workOrder];
    
    _infoView.stepBtn.userInteractionEnabled = YES;
    [_infoView.stepBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stepBtnClick:)]];
    
    _infoView.saveBtn.userInteractionEnabled = YES;
    [_infoView.saveBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveBtnClick:)]];
    
    _infoView.cameraBtn.userInteractionEnabled = YES;
    [_infoView.cameraBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraBtnClick:)]];
    
    _infoView.inventoryBtn.userInteractionEnabled = YES;
    [_infoView.inventoryBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inventoryBtnClick:)]];
    
    _infoView.formBtn.userInteractionEnabled = YES;
    [_infoView.formBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(formBtnClick:)]];
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
                switch (_workOrder.status) {
                    case WorkOrderStatusAssigned:
                        title = @"接收";
                        break;
                    case WorkOrderStatusAcknowledged:
                        title = @"出发";
                        break;
                    case WorkOrderStatusEnroute:
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
    [[WorkOrderManager getInstance] updateTimeStampWithURL:URLString andParams:dict finishBlock:^(NSDictionary *obj, NSError *error) {
        if(!error){
            hub.labelText = [NSString stringWithFormat:@"上传数据成功"];
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
            NSString *message = @"";
            if(obj == nil){
                message =@"上传数据失败,请重试";
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
    WorkOrderStepController *info = [WorkOrderStepController new];
    info.workOrderCode = [super workOrderCode];
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

-(void)inventoryBtnClick:(UITapGestureRecognizer *)recognizer
{
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
    WorkOrderFormsController *info =[WorkOrderFormsController new];
    info.workOrderCode = [super workOrderCode];
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)saveBtnClick:(UITapGestureRecognizer *)recognizer
{
    [self showOkayCancelAlert];
}

- (void)completeBtnClick
{
    [self showCompleteAlert];
}

- (void)showCompleteAlert {
    NSString *title = @"提示";
    NSString *message = @"是否完成所有步骤？";
    NSString *cancelButtonTitle = @"否";
    NSString *otherButtonTitle = @"是";
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf postWorkOrderStepWithWorkOrder:_workOrder andStepArray:_workOrderStepList isCompleteAll:YES];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
        [weakSelf postWorkOrderStepWithWorkOrder:_workOrder andStepArray:_workOrderStepList isCompleteAll:NO];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)postWorkOrderStepWithWorkOrder:(WorkOrder *)workOrder andStepArray:(NSArray *)steps isCompleteAll:(BOOL)isCompleteAll{
    
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在上传工单步骤";
    hub.userInteractionEnabled = NO;
    NSDictionary *stepDict = @{@"steps":[WorkOrderStep mj_keyValuesArrayWithObjectArray:steps]};
    NSDictionary *dict = @{@"code":workOrder.code,@"status":[NSNumber numberWithInteger:workOrder.status],@"processDetail":stepDict};
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_POSTWORKORDERSTEP,workOrder.code];
    [[WorkOrderManager getInstance] postWorkOrderStepWithURL:URLString andParams:dict finishBlock:^(NSDictionary *obj,NSError *error){
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
                int i= 0;
                for(Attachment *attachment in attachments)
                {
                    i++;
                    hub.labelText = [NSString stringWithFormat:@"正在上传附件"];
                    [[WorkOrderManager getInstance] postAttachment:attachment finishBlock:^(NSDictionary *obj,NSError *error) {
                        if (!error) {
                            attachment.isUpload = YES;
                            [attachment updateToDB];
                            if(i == attachments.count)
                            {
                                hub.labelText = [NSString stringWithFormat:@"上传工单附件成功"];
                                [hub hide:YES afterDelay:1];
                            }
                        }else{
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
                if(isCompleteAll){
                    [self completeAllSteps:workOrder.code];
                }
                
            }
        }else{
            
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
    [[WorkOrderManager getInstance] updateTimeStampWithURL:URLString andParams:dict finishBlock:^(NSDictionary *obj, NSError *error) {
        if(!error){
            hub.labelText = [NSString stringWithFormat:@"完结工单成功"];
            [hub hide:YES afterDelay:1];
            weakSelf.workOrder.status = WorkOrderStatusCompleted;
            [weakSelf.workOrder saveToDB];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [[WorkOrderManager getInstance] sortAllWorkOrder];
        }else{
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
-(void)completeAllSteps:(NSString*)workOrderCode
{
    
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在完成所有步骤";
    hub.userInteractionEnabled = NO;
    
    NSDictionary *dict = @{@"workOrderCode":workOrderCode};
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_COMPLTER_ALL_STEPS,workOrderCode];
    [HttpUtil postFormData:URLString param:dict finish:^(NSDictionary *obj,NSError *error){
        if (!error) {
            hub.labelText = [NSString stringWithFormat:@"提交成功"];
            [hub hide:YES afterDelay:1];
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = @"提交失败,请重试";
            [hub hide:YES afterDelay:1];
        }
    }];
}
@end
