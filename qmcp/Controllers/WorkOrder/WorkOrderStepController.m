//
//  WorkOrderStepController.m
//  qmcp
//
//  Created by 谢永明 on 16/3/30.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderStepController.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "WorkOrderStep.h"
#import "WorkOrderStepCell.h"
#import "NSObject+LKDBHelper.h"
#import "WorkOrderStepEditController.h"
#import "NSObject+LKDBHelper.h"
#import "WorkOrderStepView.h"
#import "Utils.h"
#import "WorkOrderManager.h"
#import "WorkOrderCameraController.h"
@interface WorkOrderStepController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *workOrderStepList;
@property (nonatomic, strong) WorkOrderStepView *stepView;
@property (nonatomic, strong) WorkOrder *workOrder;
@end

@implementation WorkOrderStepController

#pragma mark - BaseWorkOrderViewController
-(void)initView
{
    _stepView = [WorkOrderStepView new];
    [_stepView initView:self.view];
}

-(void)bindListener
{
    _stepView.tableView.delegate = self;
    _stepView.tableView.dataSource = self;
    _stepView.addBtn.userInteractionEnabled = YES;
    [_stepView.addBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addBtnClick:)]];
    
    _stepView.saveBtn.userInteractionEnabled = YES;
    [_stepView.saveBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveBtnClick:)]];
    
    _stepView.cameraBtn.userInteractionEnabled = YES;
    [_stepView.cameraBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraBtnClick:)]];
    
    _stepView.completeBtn.userInteractionEnabled = YES;
    [_stepView.completeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeBtnClick:)]];
}

-(void)loadData
{
    NSString *where = [NSString stringWithFormat:@"workOrderCode = '%@'",super.workOrderCode];
    _workOrderStepList = [WorkOrderStep searchWithWhere:where];
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",super.workOrderCode];
    _workOrder = [WorkOrder searchWithWhere:workWhere][0];
}

#pragma mark - IBAction
- (void)cameraBtnClick:(UITapGestureRecognizer *)recognizer
{
    WorkOrderCameraController *info =[WorkOrderCameraController new];
    info.workOrderCode = [super workOrderCode];
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)addBtnClick:(UITapGestureRecognizer *)recognizer
{
    WorkOrderStep *step = [WorkOrderStep new];
    step.id = [[NSUUID UUID] UUIDString];

    long size = _workOrderStepList.count + 1;
    step.stepName = [NSString stringWithFormat:@"步骤%lu",size];
    step.workOrderCode = [super workOrderCode];
    step.submitTime = [Utils formatDate:[NSDate new]];
    [step saveToDB];
    [self pushToWorkOrderStepEditController:step.id andType:SaveTypeAdd];
}

-(void)pushToWorkOrderStepEditController:(NSString *)stepId andType:(SaveType)type
{
     __weak typeof(self) weakSelf = self;
    WorkOrderStepEditController *info = [WorkOrderStepEditController doneBlock:^(WorkOrderStep *step, SaveType type) {
        
        switch (type) {
            case SaveTypeAdd:
                [weakSelf.workOrderStepList addObject:step];
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
    [self postWorkOrderStep:_workOrder andStep:_workOrderStepList isCompleteAll:NO];
}

- (void)completeBtnClick:(UITapGestureRecognizer *)recognizer
{
    [self postWorkOrderStep:_workOrder andStep:_workOrderStepList isCompleteAll:YES];
}

- (void)postWorkOrderStep:(WorkOrder *)workOrder andStep:(NSArray *)steps isCompleteAll:(BOOL)isCompleteAll{
    
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在上传工单步骤";
    hub.userInteractionEnabled = NO;
    NSDictionary *stepDict = @{@"steps":[WorkOrderStep mj_keyValuesArrayWithObjectArray:steps]};
    NSDictionary *dict = @{@"code":workOrder.code,@"status":[NSNumber numberWithInteger:workOrder.status],@"processDetail":stepDict};
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_POSTWORKORDERSTEP,workOrder.code];
    [[WorkOrderManager getInstance] postWorkOrderStep:URLString params:dict finish:^(NSDictionary *obj,NSError *error){
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
                    [[WorkOrderManager getInstance] postAttachment:attachment finish:^(NSDictionary *obj,NSError *error) {
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
            
                [self updateTimeStamp:workOrder.code timeStamp:WorkOrderTimeStampComplete time:[Utils formatDate:[NSDate new]]];
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

-(void)updateTimeStamp:(NSString *)workOrderCode timeStamp:(WorkOrderTimeStamp)timeStamp time:(NSString *)time{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在完成工单";
    hub.userInteractionEnabled = NO;
    NSDictionary *dict = @{@"timestamp":[NSNumber numberWithInt:timeStamp],@"value":time};
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_TIMESTAMP,workOrderCode];
    [[WorkOrderManager getInstance] updateTimeStamp:URLString params:dict finish:^(NSDictionary *obj, NSError *error) {
        if(!error){
            hub.labelText = [NSString stringWithFormat:@"完成工单成功"];
            [hub hide:YES afterDelay:1];
            weakSelf.workOrder.status = WorkOrderStatusCompleted;
            [weakSelf.workOrder saveToDB];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [[WorkOrderManager getInstance] sortAllWorkOrder];
        }else{
            NSString *message = @"";
            if(obj == nil){
                message =@"完成工单失败,请重试";
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
    [self pushToWorkOrderStepEditController:step.id andType:SaveTypeUpdate];
}


@end
