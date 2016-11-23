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

@end

@implementation WorkOrderInfoController

#pragma mark - BaseWorkOrderViewController
-(void)loadView
{
    _infoView = [WorkOrderInfoView viewInstance];
    self.view = _infoView;
    self.title = @"信息";
 
}

-(void)setupView{
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                            target:self
                                                                                            action:@selector(rightBtnClick)];
}
-(void)bindListener
{
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

-(void)loadData
{
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",_workOrderCode];
    _workOrder = [WorkOrder searchSingleWithWhere:workWhere orderBy:nil];
    NSString *where = [NSString stringWithFormat:@"workOrderCode = '%@'",_workOrderCode];
    _workOrderStepList = [WorkOrderStep searchWithWhere:where];
    [self p_setInfo:_workOrder];
    
    _infoView.stepBtn.userInteractionEnabled = YES;
    [_infoView.stepBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stepBtnClick:)]];
    
    _infoView.cameraBtn.userInteractionEnabled = YES;
    [_infoView.cameraBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraBtnClick:)]];
    
    _infoView.formBtn.userInteractionEnabled = YES;
    [_infoView.formBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(formBtnClick:)]];
    
    _infoView.qrCodeBtn.userInteractionEnabled = YES;
    [_infoView.qrCodeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrCodeBtnClick:)]];
    
}


-(void)rightBtnClick{
    [YCXMenu setTintColor:[UIColor blackColor]];
    [YCXMenu setSelectedColor:[UIColor redColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        NSArray *menuItems = @[[YCXMenuItem menuItem:@"完结订单" image:[UIImage imageNamed:@"menu_order_icon"] target:self action:@selector(completeClick)]];
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 0, 50, 0) menuItems:menuItems selected:^(NSInteger index, YCXMenuItem *item) {
            NSLog(@"%@",item);
        }];
    }
}

-(void)completeClick{
    [self showOkayCancelAlert];
}

-(void)p_setInfo:(WorkOrder *)workOrder
{
    _infoView.remarkText.text = workOrder.salesOrderSnapshot.remark;
    _infoView.serviceText.text = workOrder.salesOrderSnapshot.organizationName;
    _infoView.appointmentTimeText.text = workOrder.salesOrderSnapshot.appointmentTime;
    
    _infoView.locationText.text = workOrder.salesOrderSnapshot.addressSnapshot.fullAddress;
    _infoView.passwordText.text = workOrder.salesOrderSnapshot.addressSnapshot.mobilePhone;
    _infoView.userNameText.text = workOrder.salesOrderSnapshot.addressSnapshot.contacts;
    _infoView.codeContent.text = workOrder.code;
    _infoView.workOrder = workOrder;
    switch (_workOrder.type) {
            case WorkOrderTypeOnsite:
                switch (_workOrder.onSiteStatus) {
                        case OnSiteStatusNone:
                        case OnSiteStatusWaiting:
                        case OnSiteStatusNotDepart:
                        [_infoView.starBtn setTitle:@"出发" forState:UIControlStateNormal];
                        break;
                        case OnSiteStatusOnRoute:
                        [_infoView.starBtn setTitle:@"到达" forState:UIControlStateNormal];
                        break;
                    default:
                        [_infoView.starBtn setHidden:YES];
                        break;
                }
            
            break;
            case WorkOrderTypeService:
                [_infoView.starBtn setHidden:YES];
            break;
        default:
            break;
    }
    
    
}

/**
 *  更新工单时间戳
 *
 *  @param workOrderCode 工单code
 *  @param timeStamp     TimeStamp枚举
 *  @param time          date
 */
-(void)p_updateTimeStampWithWorkOrderCode:(NSString *)workOrderCode andTimeStamp:(OnSiteTimeStamp)timeStamp andDate:(NSString *)time{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
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

#pragma mark - IBAction

-(void)stepBtnClick:(UITapGestureRecognizer *)recognizer
{
    if(_workOrder.type == WorkOrderTypeOnsite){
        if(_workOrder.onSiteStatus != OnSiteStatusArrived){
            return;
        }
    }
    
    WorkOrderStepController *info = [WorkOrderStepController new];
    info.code = _workOrderCode;
    info.funcType = FuncTypeWorkOrder;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)cameraBtnClick:(UITapGestureRecognizer *)recognizer
{
    WorkOrderCameraController *info =[WorkOrderCameraController new];
    info.code = _workOrderCode;
    info.funcType = FuncTypeWorkOrder;
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
    info.code = _workOrder.salesOrderSnapshot.code;;
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
        [weakSelf p_postWorkOrderStepWithWorkOrder:_workOrder andStepArray:_workOrderStepList];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)p_postWorkOrderStepWithWorkOrder:(WorkOrder *)workOrder andStepArray:(NSArray *)steps{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.detailsLabel.text = @"正在上传工单步骤";
    hub.userInteractionEnabled = NO;
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
                
                [self p_updateTimeStampWithWorkOrderCode:workOrder.code andTimeStampEnum:OnSiteTimeStampComplete andDate:[Utils formatDate:[NSDate new]]];
                
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


-(void)p_updateTimeStampWithWorkOrderCode:(NSString *)workOrderCode andTimeStampEnum:(OnSiteTimeStamp)timeStamp andDate:(NSString *)time{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.detailsLabel.text = @"正在完结工单";
    hub.userInteractionEnabled = NO;
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
