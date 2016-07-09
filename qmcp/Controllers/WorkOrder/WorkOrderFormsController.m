//
//  WorkOrderFormsController.m
//  qmcp
//
//  Created by 谢永明 on 16/6/12.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderFormsController.h"
#import "FormTemplateBrife.h"
#import "FormManager.h"
#import "FormTemplateCell.h"
#import "WorkOrderFormController.h"

@interface WorkOrderFormsController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) WorkOrder *workOrder;
@property (nonatomic, strong) NSMutableArray<FormTemplateBrife *> * workOrderFormList;
@end

@implementation WorkOrderFormsController

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
    
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在获取表单数据";
    hub.userInteractionEnabled = NO;
    [[FormManager getInstance] getFormTemplateAndFormData:_workOrder.salesOrderSnapshot.code finishBlock:^(NSMutableArray *arr, NSString *error) {
        if (error == nil) {
            hub.labelText = [NSString stringWithFormat:@"获取表单数据成功"];
            [hub hide:YES afterDelay:0.5];
            _workOrderFormList = arr;
            [_tableView reloadData];
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = @"获取表单数据失败!";
            [hub hide:YES afterDelay:1];
        }
    }];
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
    FormTemplateBrife *field = _workOrderFormList[row];
    FormTemplateCell *cell = [FormTemplateCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.formTemplateBrife = field;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    FormTemplateBrife *formTemplateBrife = _workOrderFormList[indexPath.row];
    WorkOrderFormController *info =[WorkOrderFormController new];
    info.workOrderCode = [super workOrderCode];
    info.formTemplateId = formTemplateBrife.formTemplateCode;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}


@end
