//
//  WorkOrderStepController.m
//  qmcp
//
//  Created by 谢永明 on 16/3/30.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderStepController.h"
#import "WorkOrderStep.h"
#import "WorkOrderStepCell.h"
#import "WorkOrderStepEditController.h"
#import "WorkOrderStepView.h"
#import "WorkOrderManager.h"
#import "WorkOrderCameraController.h"
#import "WorkOrderFormsController.h"
#import "AppManager.h"
@interface WorkOrderStepController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray<WorkOrderStep *> *workOrderStepList;
@property (nonatomic, strong) WorkOrderStepView *stepView;
@property (nonatomic, strong) WorkOrder *workOrder;
@end

@implementation WorkOrderStepController

#pragma mark - BaseWorkOrderViewController
-(void)loadView
{
    _stepView = [WorkOrderStepView viewInstance];
    self.view = _stepView;
    self.title = @"步骤";
}

-(void)bindListener
{
    _stepView.tableView.delegate = self;
    _stepView.tableView.dataSource = self;
    _stepView.addBtn.userInteractionEnabled = YES;
    [_stepView.addBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appendBtnClick:)]];
    
    _stepView.saveBtn.userInteractionEnabled = YES;
    [_stepView.saveBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveBtnClick:)]];

}

-(void)loadData
{
    NSString *where = [NSString stringWithFormat:@"workOrderCode = '%@'",super.workOrderCode];
    _workOrderStepList = [WorkOrderStep searchWithWhere:where];
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",super.workOrderCode];
    _workOrder = [WorkOrder searchWithWhere:workWhere][0];
}

#pragma mark - IBAction

- (void)appendBtnClick:(UITapGestureRecognizer *)recognizer
{
    WorkOrderStep *step = [WorkOrderStep new];
    step.id = [[NSUUID UUID] UUIDString];

    long size = _workOrderStepList.count + 1;
    step.stepName = [NSString stringWithFormat:@"步骤%lu",size];
    step.workOrderCode = [super workOrderCode];
    step.submitTime = [Utils formatDate:[NSDate new]];
    step.userOpenId = [[AppManager getInstance] getUser].userOpenId;
    [step saveToDB];
    [self pushWorkOrderStepEditControllerWithWorkOrderStepId:step.id andType:SaveTypeAdd];
}

-(void)appendWorkOrder:(WorkOrderStep *)workOrderStep{
    BOOL flag = NO;
    for(int i = 0;i < [_workOrderStepList count];i++){
        NSString *code = _workOrderStepList[i].id;
        if([code isEqualToString:workOrderStep.id]){
            flag = YES;
        }
    }
    if(!flag){
        [_workOrderStepList addObject:workOrderStep];
    }
}

-(void)pushWorkOrderStepEditControllerWithWorkOrderStepId:(NSString *)stepId andType:(SaveType)type
{
     __weak typeof(self) weakSelf = self;
    WorkOrderStepEditController *info = [WorkOrderStepEditController doneBlock:^(WorkOrderStep *step, SaveType type) {
        
        switch (type) {
            case SaveTypeAdd:
                [weakSelf appendWorkOrder:step];
                break;
            case SaveTypeUpdate:
                for (WorkOrderStep *temp in _workOrderStepList) {
                    if([temp.id isEqualToString:step.id]){
                        temp.content = step.content;
                        temp.attachments = step.attachments;
                        break;
                    }
                }

                break;
            case SaveTypeDelete:
                for (WorkOrderStep *temp in _workOrderStepList) {
                    if([temp.id isEqualToString:step.id]){
                        [weakSelf.workOrderStepList removeObject:temp];
                        break;
                    }
                }
                break;
            default:
                break;
        }
        [weakSelf.stepView.tableView reloadData];
    }];
    info.workOrderCode = [super workOrderCode];
    info.workOrderStepCode = stepId;
    info.type = type;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)saveBtnClick:(UITapGestureRecognizer *)recognizer
{
    [self postWorkOrderStepWithWorkOrder:_workOrder andStepArray:_workOrderStepList isCompleteAll:NO];
}


- (void)postWorkOrderStepWithWorkOrder:(WorkOrder *)workOrder andStepArray:(NSArray *)steps isCompleteAll:(BOOL)isCompleteAll{
    
    MBProgressHUD *hub = [Utils createHUD];
    hub.label.text = @"正在上传工单步骤";
    hub.userInteractionEnabled = NO;
    NSDictionary *stepDict = @{@"steps":[WorkOrderStep mj_keyValuesArrayWithObjectArray:steps]};
    NSDictionary *dict = @{@"code":workOrder.code,@"status":[NSNumber numberWithInteger:workOrder.status],@"processDetail":stepDict};
    
    [[WorkOrderManager getInstance] postWorkOrderStepWithCode:workOrder.code andParams:dict finishBlock:^(NSDictionary *dict, NSString *error) {
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
                    hub.label.text = [NSString stringWithFormat:@"正在上传附件"];
                    [[WorkOrderManager getInstance] postAttachment:attachment finishBlock:^(NSDictionary *obj,NSString *error) {
                        if (!error) {
                            attachment.isUpload = YES;
                            [attachment updateToDB];
                            if(i == attachments.count)
                            {
                                hub.label.text = [NSString stringWithFormat:@"上传工单附件成功"];
                                [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
                            }
                        }else{
                            hub.mode = MBProgressHUDModeCustomView;
                            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                            hub.label.text = error;
                            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
                        }
                    }];
                }
            }else
            {
                hub.label.text = [NSString stringWithFormat:@"上传工单步骤成功"];
                [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            }
        }else{
            
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.label.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
            
        }
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.workOrderStepList.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *imageName;
    if(self.workOrderStepList.count == 1)
    {
        imageName = @"singleblock.9";
    }else
    {
        if(row == 0)
        {
            imageName = @"topblock.9";
        }else
        {
            imageName = @"middleblock.9";
        }
    }
    WorkOrderStepCell *cell = [WorkOrderStepCell cellWithTableView:tableView];
    [cell imageBackgroud:imageName];
    WorkOrderStep *step = self.workOrderStepList[row];
    cell.workOrderStep = step;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //3 返回
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    WorkOrderStep *step = self.workOrderStepList[indexPath.row];
    [self pushWorkOrderStepEditControllerWithWorkOrderStepId:step.id andType:SaveTypeUpdate];
}


@end
