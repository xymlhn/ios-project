//
//  WorkOrderFormController.m
//  qmcp
//
//  Created by 谢永明 on 16/6/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderFormController.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "FormTemplateField.h"
#import "TextCell.h"
#import "DateCell.h"
#import "FormManager.h"
#import "WorkOrder.h"

@interface WorkOrderFormController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<FormTemplateField* > *workOrderFormList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,copy)WorkOrder *workOrder;
@end

@implementation WorkOrderFormController

#pragma mark - UIViewController

-(void)initView
{
    _tableView = [UITableView new];
    _tableView.rowHeight = 30;
    _tableView.separatorStyle = YES;
    _tableView.backgroundColor = [UIColor themeColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
}

-(void)loadData
{
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",super.workOrderCode];
    _workOrder = [WorkOrder searchSingleWithWhere:workWhere orderBy:nil];
    _workOrderFormList = [NSMutableArray new];
    [[FormManager getInstance] getFormTemplate:_workOrder.salesOrderSnapshot.code];
    [[FormManager getInstance] getFormData:_workOrder.salesOrderSnapshot.code];
}

-(void)bindListener
{
    
}



-(void)saveData{
    
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.workOrderFormList.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    FormTemplateField *field = _workOrderFormList[row];
    UITableViewCell *cell;
    switch (field.controlType) {
        case FormTemplateControlTypeText:
            cell = [TextCell cellWithTableView:tableView];
            ((TextCell *)cell).field = field;
            break;
        case FormTemplateControlTypeDate:
            cell = [DateCell cellWithTableView:tableView];
            ((DateCell *)cell).field = field;
            break;
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end






















