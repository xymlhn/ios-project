//
//  WorkOrderControllerViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/3/29.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderListController.h"
#import "NSObject+LKDBHelper.h"
#import "WorkOrderListCell.h"
#import "UIColor+Util.h"
#import "WorkOrderManager.h"
#import "MJRefresh.h"
#import "WorkOrderInfoController.h"
#import "WorkOrderListCell.h"
#import "Masonry.h"
#import "Config.h"
@interface WorkOrderListController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *workOrderList;
@property (nonatomic, assign) WorkOrderStatus status;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation WorkOrderListController

- (instancetype)initWithStatus:(WorkOrderStatus)status
{
    if(self)
    {
        self = [super init];
        _status = status;
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self loadData];
}

-(void)initView
{
    _tableView = [UITableView new];
    _tableView.rowHeight = 120;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor themeColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_top).with.offset(-10);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(workOrderUpdate:) name:@"workOrderUpdate" object:nil];
    
}

-(void)loadData
{
    _workOrderList = [NSMutableArray new];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[WorkOrderManager getInstance] getAllWorkOrder:[Config getWorkOrderTime]];
    }];
}


- (void)workOrderUpdate:(NSNotification *)text{
    [self.tableView.mj_header endRefreshing];
    [_workOrderList removeAllObjects];
    switch (_status) {
        case WorkOrderStatusDefault:
            [_workOrderList addObjectsFromArray:text.userInfo[@"default"]];
            break;
        case WorkOrderStatusCompleted:
            [_workOrderList addObjectsFromArray:text.userInfo[@"complete"]];
            break;
        case WorkOrderStatusInProgress:
            [_workOrderList addObjectsFromArray:text.userInfo[@"progress"]];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.workOrderList.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    //1 创建可重用的自定义的cell
    WorkOrderListCell *cell = [WorkOrderListCell cellWithTableView:tableView];
    //2 设置cell内部的子控件
    WorkOrder *workOrder = self.workOrderList[row];
    cell.workOrder = workOrder;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.middleView.tag = row;
    cell.topView.tag = row;
    [cell.middleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushInfoView:)]];
    [cell.topView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushInfoView:)]];
    //3 返回
    return cell;
}

- (void)pushInfoView:(UITapGestureRecognizer *)recognizer
{
    WorkOrderInfoController *info = [WorkOrderInfoController new];
    WorkOrder *workOrder = self.workOrderList[recognizer.view.tag];
    info.workOrderCode = workOrder.code;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
