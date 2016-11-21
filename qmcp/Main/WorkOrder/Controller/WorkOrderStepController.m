//
//  WorkOrderStepController.m
//  qmcp
//
//  Created by 谢永明 on 16/3/30.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderStepController.h"
#import "WorkOrderStep.h"
#import "SDTimeLineCell.h"
#import "Attachment.h"
#import "SDTimeLineCellModel.h"
#import "WorkOrderStepCell.h"
#import "WorkOrderStepEditController.h"
#import "WorkOrderStepView.h"
#import "WorkOrderManager.h"
#import "WorkOrderCameraController.h"
#import "WorkOrderFormsController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "AppManager.h"
#import "SalesOrder.h"
#import "UIScrollView+EmptyDataSet.h"
#define kTimeLineTableViewCellId @"SDTimeLineCell"
@interface WorkOrderStepController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, retain) NSMutableArray<WorkOrderStep *> *workOrderStepList;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) WorkOrderStepView *stepView;
@property (nonatomic, strong) WorkOrder *workOrder;
@property (nonatomic, strong) SalesOrder *salesOrder;
@end

@implementation WorkOrderStepController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

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
    _stepView.tableView.tableHeaderView = [UIView new];
    _stepView.tableView.tableFooterView = [UIView new];
    _stepView.tableView.emptyDataSetSource = self;
    _stepView.tableView.emptyDataSetDelegate = self;
    [_stepView.addBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appendBtnClick:)]];

}

-(void)loadData
{
    if (_funcType == FuncTypeWorkOrder) {
        NSString *where = [NSString stringWithFormat:@"workOrderCode = '%@'",_code];
        _workOrderStepList = [WorkOrderStep searchWithWhere:where];
        NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",_code];
        _workOrder = [WorkOrder searchWithWhere:workWhere][0];
    }else{
        NSString *where = [NSString stringWithFormat:@"salesOrderCode = '%@'",_code];
        _workOrderStepList = [WorkOrderStep searchWithWhere:where];
        NSString *salesWhere = [NSString stringWithFormat:@"code = '%@'",_code];
        _salesOrder = [SalesOrder searchSingleWithWhere:salesWhere orderBy:nil];
    }
    
    [self.dataArray addObjectsFromArray:[self creatModels]];
}
- (NSMutableArray *)creatModels{
    NSMutableArray *resArr = [NSMutableArray new];
    for (WorkOrderStep *step in _workOrderStepList) {
        SDTimeLineCellModel *model = [SDTimeLineCellModel new];
        model.iconName = @"default－portrait";
        model.name = step.submitUser;
        model.msgContent = step.content;
        model.timeText = step.submitTime;
        NSMutableArray *picImageNamesArray = [NSMutableArray new];
        for (Attachment *attachment in step.attachments) {
            [picImageNamesArray addObject:attachment.key];
        }
        model.picNamesArray = picImageNamesArray;
        [resArr addObject:model];
    }
    
    return resArr;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"default－portrait"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"请添加步骤";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kJiupt],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
#pragma mark - IBAction

- (void)appendBtnClick:(UITapGestureRecognizer *)recognizer
{
    WorkOrderStep *step = [WorkOrderStep new];
    step.id = [[NSUUID UUID] UUIDString];
    long size = _workOrderStepList.count + 1;
    step.stepName = [NSString stringWithFormat:@"步骤%lu",size];
    if(_funcType == FuncTypeWorkOrder){
        step.workOrderCode = _code;
    }else{
        step.salesOrderCode = _code;
    }
    step.submitUser = [[AppManager getInstance] getUser].userNickName;
    step.submitTime = [Utils formatDate:[NSDate new]];
    step.userOpenId = [[AppManager getInstance] getUser].userOpenId;
    [step saveToDB];
    [self pushWorkOrderStepEditController:step.id withType:SaveTypeAdd];
    
}

-(void)p_appendStep:(WorkOrderStep *)workOrderStep{
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

-(void)pushWorkOrderStepEditController:(NSString *)stepId withType:(SaveType)type
{
     __weak typeof(self) weakSelf = self;
    WorkOrderStepEditController *info = [WorkOrderStepEditController doneBlock:^(WorkOrderStep *step, SaveType type) {
        
        switch (type) {
            case SaveTypeAdd:
                [weakSelf p_appendStep:step];
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
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:[weakSelf creatModels]];
        [weakSelf.stepView.tableView reloadData];
    }];
    info.code = _code;
    info.stepCode = stepId;
    info.type = type;
    info.funcType = _funcType;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *indexPath) {
            SDTimeLineCellModel *model = weakSelf.dataArray[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.stepView.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.dataArray[indexPath.row];
    return [self.stepView.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    WorkOrderStep *step = self.workOrderStepList[indexPath.row];
    [self pushWorkOrderStepEditController:step.id withType:SaveTypeUpdate];
}


@end
