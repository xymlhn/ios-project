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
@interface WorkOrderInfoController ()
@property (nonatomic,strong)WorkOrderInfoView *infoView;
@property (nonatomic,copy)WorkOrder *workOrder;

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
                        [self updateTimeStamp:[super workOrderCode] timeStamp:WorkOrderTimeStampAcknowledge time:[Utils formatDate:[NSDate new]]];
                        break;
                    case WorkOrderStatusAcknowledged:
                        [self updateTimeStamp:[super workOrderCode] timeStamp:WorkOrderTimeStampEnroute time:[Utils formatDate:[NSDate new]]];
                        
                        break;
                    case WorkOrderStatusEnroute:
                        [self updateTimeStamp:[super workOrderCode] timeStamp:WorkOrderTimeStampOnsite time:[Utils formatDate:[NSDate new]]];
                    case WorkOrderStatusOnSite:
                        [self pushServiceUI];
                        break;
                    default:
                        break;
                }
                break;
            case WorkOrderTypeInventory:
                [self pushInventoryUI];
                break;
            case WorkOrderTypeService:
                [self pushServiceUI];
                break;
            default:
                break;
        }
        return [RACSignal empty];
    }];
    
}

-(void)updateTimeStamp:(NSString *)workOrderCode timeStamp:(WorkOrderTimeStamp)timeStamp time:(NSString *)time{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在提交数据";
    hub.userInteractionEnabled = NO;
    NSDictionary *dict = @{@"timestamp":[NSNumber numberWithInt:timeStamp],@"value":time};
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_TIMESTAMP,workOrderCode];
    [[WorkOrderManager getInstance] updateTimeStamp:URLString params:dict finish:^(NSDictionary *obj, NSError *error) {
        if(!error){
            hub.labelText = [NSString stringWithFormat:@"上传数据成功"];
            [hub hide:YES afterDelay:1];
            switch (weakSelf.workOrder.status) {
                case WorkOrderStatusAssigned:
                    [weakSelf.infoView.starBtn setTitle:@"出发" forState:UIControlStateNormal];
                    _workOrder.status = WorkOrderStatusAcknowledged;
                    [_workOrder saveToDB];
                    break;
                case WorkOrderStatusAcknowledged:
                    [weakSelf.infoView.starBtn setTitle:@"出发" forState:UIControlStateNormal];
                    _workOrder.status = WorkOrderStatusEnroute;
                    [_workOrder saveToDB];
                    break;
                case WorkOrderStatusEnroute:
                    [weakSelf.infoView.starBtn setTitle:@"到达" forState:UIControlStateNormal];
                    _workOrder.status = WorkOrderStatusOnSite;
                    [_workOrder saveToDB];
                    break;
                default:
                    [weakSelf.infoView.starBtn setTitle:@"服务" forState:UIControlStateNormal];
                    _workOrder.status = WorkOrderStatusOnSite;
                    [_workOrder saveToDB];
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
-(void)loadData
{
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",super.workOrderCode];
    _workOrder = [WorkOrder searchSingleWithWhere:workWhere orderBy:nil];
    [self setText:_workOrder];
}


-(void)setText:(WorkOrder *)workOrder
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
                        title = @"服务";
                        break;
                }

                break;
            case WorkOrderTypeInventory:

                title = @"清点";
                break;
            case WorkOrderTypeService:

                title = @"服务";
                
                break;
            default:
                break;
        }
        [_infoView.starBtn setTitle:title forState:UIControlStateNormal];
    }
    
}

#pragma mark - IBAction
-(void)pushServiceUI
{
    WorkOrderStepController *info = [WorkOrderStepController new];
    info.workOrderCode = [super workOrderCode];
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

-(void)pushInventoryUI
{
    WorkOrderInventoryController *info = [WorkOrderInventoryController new];
    info.workOrderCode = [super workOrderCode];
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

@end
