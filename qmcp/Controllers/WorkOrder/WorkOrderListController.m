//
//  WorkOrderControllerViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/3/29.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderListController.h"
#import "NSObject+LKDBHelper.h"
#import "UIColor+Util.h"
#import "WorkOrderManager.h"
#import "MJRefresh.h"
#import "WorkOrderInfoController.h"
#import "Masonry.h"
#import "Config.h"
#import "PchHeader.h"
#import "UITableView+Common.h"
#import "WorkOrderCell.h"
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

#pragma mark - UIViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self loadData];
}

-(void)initView
{
    _tableView = [UITableView new];
    _tableView.rowHeight = 80;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor themeColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(workOrderUpdate:) name:kWorkOrderUpdateNotification object:nil];
    
}

-(void)loadData
{
    _workOrderList = [NSMutableArray new];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[WorkOrderManager getInstance] getWorkOrderByLastUpdateTime:[Config getWorkOrderTime]];
    }];
}

#pragma mark - Notification
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

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    WorkOrderCell *cell = [WorkOrderCell cellWithTableView:tableView];
    //2 设置cell内部的子控件
    WorkOrder *workOrder = self.workOrderList[row];
    cell.workOrder = workOrder;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushInfoView:)]];
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
    //3 返回
    return cell;
}

#pragma mark - IBAction
- (void)pushInfoView:(UITapGestureRecognizer *)recognizer
{
    WorkOrderInfoController *info = [WorkOrderInfoController new];
    WorkOrder *workOrder = self.workOrderList[recognizer.view.tag];
    info.workOrderCode = workOrder.code;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

@end
