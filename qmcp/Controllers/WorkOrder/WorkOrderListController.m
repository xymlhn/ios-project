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
#import "WorkOrderCell.h"
@interface WorkOrderListController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *workOrderList;
@property (nonatomic, assign) WorkOrderStatus status;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MBProgressHUD *hub;
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
    _tableView.backgroundColor = [UIColor themeColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];

    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(workOrderUpdate:) name:WorkOrderUpdateNotification object:nil];
    
}

-(void)loadData
{
    _hub = [Utils createHUD];
    _hub.labelText = @"加载中...";
    _hub.userInteractionEnabled = NO;
    _workOrderList = [NSMutableArray new];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[WorkOrderManager getInstance] getWorkOrderByLastUpdateTime:[Config getWorkOrderTime]];
    }];
}

#pragma mark - Notification
- (void)workOrderUpdate:(NSNotification *)text{
    [_workOrderList removeAllObjects];
    [_tableView.mj_header endRefreshing];
    
    _hub.mode = MBProgressHUDModeCustomView;
    _hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
    _hub.labelText = [NSString stringWithFormat:@"加载成功"];
    [_hub hide:YES];
    switch (_status) {
        case WorkOrderStatusCompleted:
            [_workOrderList addObjectsFromArray:text.userInfo[@"failed"]];
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
    //3 返回
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkOrderInfoController *info = [WorkOrderInfoController new];
    WorkOrder *workOrder = self.workOrderList[indexPath.row];
    info.workOrderCode = workOrder.code;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}


@end
