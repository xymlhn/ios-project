//
//  SalesOrderStepController.m
//  qmcp
//
//  Created by 谢永明 on 2016/9/23.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderStepController.h"
#import "WorkOrderStepView.h"
#import "SalesOrder.h"
#import "WorkOrderStep.h"
#import "AppManager.h"
#import "WorkOrderStepCell.h"
#import "SalesOrderStepEditController.h"
@interface SalesOrderStepController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, retain) NSMutableArray<WorkOrderStep *> *stepList;
@property (nonatomic, strong) WorkOrderStepView *stepView;
@property (nonatomic, strong) SalesOrder *salesOrder;
@end

@implementation SalesOrderStepController


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
    NSString *where = [NSString stringWithFormat:@"salesOrderCode = '%@'",_code];
    _stepList = [WorkOrderStep searchWithWhere:where];
    NSString *salesWhere = [NSString stringWithFormat:@"code = '%@'",_code];
    _salesOrder = [SalesOrder searchSingleWithWhere:salesWhere orderBy:nil];
}

#pragma mark - IBAction

- (void)appendBtnClick:(UITapGestureRecognizer *)recognizer
{
    WorkOrderStep *step = [WorkOrderStep new];
    step.id = [[NSUUID UUID] UUIDString];
    long size = _stepList.count + 1;
    step.stepName = [NSString stringWithFormat:@"步骤%lu",size];
    step.salesOrderCode = _code;
    step.submitTime = [Utils formatDate:[NSDate new]];
    step.userOpenId = [[AppManager getInstance] getUser].userOpenId;
    [step saveToDB];
    [self pushWorkOrderStepEditController:step.id andType:SaveTypeAdd];
}

-(void)appendStep:(WorkOrderStep *)workOrderStep{
    BOOL flag = NO;
    for(int i = 0;i < [_stepList count];i++){
        NSString *code = _stepList[i].id;
        if([code isEqualToString:workOrderStep.id]){
            flag = YES;
        }
    }
    if(!flag){
        [_stepList addObject:workOrderStep];
    }
}

-(void)pushWorkOrderStepEditController:(NSString *)stepId andType:(SaveType)type
{
    __weak typeof(self) weakSelf = self;
    SalesOrderStepEditController *info = [SalesOrderStepEditController doneBlock:^(WorkOrderStep *step, SaveType type) {
        
        switch (type) {
            case SaveTypeAdd:
                [weakSelf appendStep:step];
                break;
            case SaveTypeUpdate:
                for (WorkOrderStep *temp in _stepList) {
                    if([temp.id isEqualToString:step.id]){
                        temp.content = step.content;
                        temp.attachments = step.attachments;
                        break;
                    }
                }
                
                break;
            case SaveTypeDelete:
                for (WorkOrderStep *temp in _stepList) {
                    if([temp.id isEqualToString:step.id]){
                        [weakSelf.stepList removeObject:temp];
                        break;
                    }
                }
                break;
            default:
                break;
        }
        [weakSelf.stepView.tableView reloadData];
    }];
    info.code = _code;
    info.stepId = stepId;
    info.saveType = type;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stepList.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    WorkOrderStepCell *cell = [WorkOrderStepCell cellWithTableView:tableView];
    WorkOrderStep *step = self.stepList[row];
    cell.workOrderStep = step;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //3 返回
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    WorkOrderStep *step = self.stepList[indexPath.row];
    [self pushWorkOrderStepEditController:step.id andType:SaveTypeUpdate];
}

@end
