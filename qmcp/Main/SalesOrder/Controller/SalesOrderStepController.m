//
//  SalesOrderStepTableViewController.m
//  qmcp
//
//  Created by 谢永明 on 2016/11/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderStepController.h"
#import "WorkOrderStep.h"
#import "SalesOrder.h"
#import "SDTimeLineCell.h"
#import "Attachment.h"
#import "SDTimeLineCellModel.h"
#import "SalesOrderStepEditController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "WorkOrderStepView.h"
#import "AppManager.h"
#define kTimeLineTableViewCellId @"SDTimeLineCell"
@interface SalesOrderStepController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray<WorkOrderStep *> *stepList;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) WorkOrderStepView *stepView;
@property (nonatomic, strong) SalesOrder *salesOrder;

@end

@implementation SalesOrderStepController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

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
     [self.dataArray addObjectsFromArray:[self creatModels]];
}

- (NSMutableArray *)creatModels
{

    NSMutableArray *resArr = [NSMutableArray new];
    
    for (WorkOrderStep *step in _stepList) {
        
        SDTimeLineCellModel *model = [SDTimeLineCellModel new];
        model.iconName = @"default－portrait";
        model.name = _salesOrder.addressSnapshot.contacts;
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


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkOrderStep *step = self.stepList[indexPath.row];
    [self p_pushWorkOrderStepEditController:step.id andType:SaveTypeUpdate];
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
    [self p_pushWorkOrderStepEditController:step.id andType:SaveTypeAdd];
}

-(void)p_appendStep:(WorkOrderStep *)workOrderStep{
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
-(void)p_pushWorkOrderStepEditController:(NSString *)stepId andType:(SaveType)type
{
    __weak typeof(self) weakSelf = self;
    SalesOrderStepEditController *info = [SalesOrderStepEditController doneBlock:^(WorkOrderStep *step, SaveType type) {
        
        switch (type) {
            case SaveTypeAdd:
                [weakSelf p_appendStep:step];
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
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:[weakSelf creatModels]];
        [weakSelf.stepView.tableView reloadData];
    }];
    info.code = _code;
    info.stepId = stepId;
    info.saveType = type;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}
@end
