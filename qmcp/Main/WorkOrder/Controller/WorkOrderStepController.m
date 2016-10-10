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

}

-(void)loadData
{
    NSString *where = [NSString stringWithFormat:@"workOrderCode = '%@'",_workOrderCode];
    _workOrderStepList = [WorkOrderStep searchWithWhere:where];
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",_workOrderCode];
    _workOrder = [WorkOrder searchWithWhere:workWhere][0];
}

#pragma mark - IBAction

- (void)appendBtnClick:(UITapGestureRecognizer *)recognizer
{
    WorkOrderStep *step = [WorkOrderStep new];
    step.id = [[NSUUID UUID] UUIDString];

    long size = _workOrderStepList.count + 1;
    step.stepName = [NSString stringWithFormat:@"步骤%lu",size];
    step.workOrderCode = _workOrderCode;
    step.submitTime = [Utils formatDate:[NSDate new]];
    step.userOpenId = [[AppManager getInstance] getUser].userOpenId;
    [step saveToDB];
    [self pushWorkOrderStepEditControllerWithWorkOrderStepId:step.id andType:SaveTypeAdd];
}

-(void)p_appendWorkOrder:(WorkOrderStep *)workOrderStep{
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
                [weakSelf p_appendWorkOrder:step];
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
    info.workOrderCode = _workOrderCode;
    info.workOrderStepCode = stepId;
    info.type = type;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
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
    WorkOrderStepCell *cell = [WorkOrderStepCell cellWithTableView:tableView];
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
