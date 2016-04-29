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
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeStamp:) name:@"timeStamp" object:nil];
}
-(void)bindListener
{
    _infoView.starBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        switch (_workOrder.type) {
            case WorkOrderTypeOnsite:
                switch (_workOrder.status) {
                    case WorkOrderStatusAssigned:
                        [[WorkOrderManager getInstance] updateTimeStamp:[super workOrderCode] timeStamp:WorkOrderTimeStampAcknowledge time:[Utils formatDate:[NSDate new]]];
                        break;
                    case WorkOrderStatusAcknowledged:
                        [[WorkOrderManager getInstance] updateTimeStamp:[super workOrderCode] timeStamp:
                         WorkOrderTimeStampEnroute time:[Utils formatDate:[NSDate new]]];
                        
                        break;
                    case WorkOrderStatusEnroute:
                        [[WorkOrderManager getInstance] updateTimeStamp:[super workOrderCode] timeStamp:
                         WorkOrderTimeStampOnsite time:[Utils formatDate:[NSDate new]]];
                        
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

-(void)loadData
{
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",super.workOrderCode];
    _workOrder = [WorkOrder searchSingleWithWhere:workWhere orderBy:nil];
    [self setText:_workOrder];
}

#pragma mark - Notification
- (void)timeStamp:(NSNotification *)text{
    NSNumber *time = text.userInfo[@"timeStamp"];
    switch ([time integerValue]) {
            
        case WorkOrderStatusAssigned:
            [_infoView.starBtn setTitle:@"出发" forState:UIControlStateNormal];// 添加文字
            _workOrder.status = WorkOrderStatusAcknowledged;
            [_workOrder saveToDB];
            break;
        case WorkOrderStatusAcknowledged:
            [_infoView.starBtn setTitle:@"到达" forState:UIControlStateNormal];// 添加文字
            _workOrder.status = WorkOrderStatusEnroute;
            [_workOrder saveToDB];
            break;
        default:
            [_infoView.starBtn setTitle:@"服务" forState:UIControlStateNormal];// 添加文字
            _workOrder.status = WorkOrderStatusOnSite;
            [_workOrder saveToDB];
            break;
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
