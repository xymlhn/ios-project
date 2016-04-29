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
@interface WorkOrderStepController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *workOrderStepList;
@property (nonatomic, strong) WorkOrderStepView *stepView;

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
}

-(void)loadData
{
    NSString *where = [NSString stringWithFormat:@"workOrderCode = '%@'",super.workOrderCode];
    _workOrderStepList = [WorkOrderStep searchWithWhere:where];
}

#pragma mark - IBAction
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
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",super.workOrderCode];
    WorkOrder *workOrder = [WorkOrder searchWithWhere:workWhere][0];
    NSString *where = [NSString stringWithFormat:@"workOrderCode = '%@'",super.workOrderCode];
    NSArray *steps = [WorkOrderStep searchWithWhere:where];
    [[WorkOrderManager getInstance]postWorkOrderStep:workOrder andStep:steps];
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
