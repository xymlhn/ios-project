//
//  SalesOrderBindListController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderGrabListController.h"
#import "UIColor+Util.h"
#import "MJRefresh.h"
#import "SalesOrderSnapshot.h"
#import "SalesOrderGrabCell.h"
#import "SalesOrderManager.h"
#import "WorkOrder.h"
#import "WorkOrderManager.h"
#import "WorkOrderInfoController.h"
@interface SalesOrderGrabListController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<SalesOrderSnapshot *> *salesOrderList;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SalesOrderGrabListController


-(void)setupView
{
    _tableView = [UITableView new];
    _tableView.rowHeight = 100;
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
    
}

-(void)loadData{
    _salesOrderList = [NSMutableArray new];
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"加载中...";
    hub.userInteractionEnabled = NO;
    [[SalesOrderManager getInstance] getSalesOrderConfirmByLastUpdateTime:[Config getSalesOrderGrabTime] finishBlock:^(NSDictionary *dict, NSString *error) {
        if(error == nil){
            [self salesOrderUpdate:dict];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = [NSString stringWithFormat:@"加载成功"];
            [hub hide:YES afterDelay:kEndSucceedDelayTime];
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kEndFailedDelayTime];
        }
        
    }];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[SalesOrderManager getInstance] getSalesOrderConfirmByLastUpdateTime:[Config getSalesOrderGrabTime] finishBlock:^(NSDictionary *dict, NSString *error) {
            [self salesOrderUpdate:dict];
        }];
    }];
}

- (void)salesOrderUpdate:(NSDictionary *)dict{
    [_tableView.mj_header endRefreshing];
    [_salesOrderList removeAllObjects];
    [_salesOrderList addObjectsFromArray:[SalesOrderSnapshot mj_objectArrayWithKeyValuesArray:[dict allValues]]];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _salesOrderList.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    //1 创建可重用的自定义的cell
    SalesOrderGrabCell *cell = [SalesOrderGrabCell cellWithTableView:tableView];
    //2 设置cell内部的子控件
    SalesOrderSnapshot *salesOrderSnapshot = _salesOrderList[row];
    cell.grabBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        if(salesOrderSnapshot.confirmationFlag){
            [self assignSalesOrder:salesOrderSnapshot];
        }else{
            [self grabSalesOrder:salesOrderSnapshot];
        }
        return [RACSignal empty];
    }];
    cell.salesOrderSnapshot = salesOrderSnapshot;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //3 返回
    return cell;
}


-(void)bindListener{
    
}

-(void)grabSalesOrder:(SalesOrderSnapshot *)salesOrderSnapshot
{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"接单中...";
    hub.userInteractionEnabled = NO;
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERGRAB,salesOrderSnapshot.code];
    NSDictionary *dict = @{@"grab":[NSNumber numberWithBool:YES]};
    [HttpUtil post:URLString param:dict finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            salesOrderSnapshot.confirmationFlag = YES;
            [weakSelf.tableView reloadData];
            [[SalesOrderManager getInstance] updateGrabDictSalesOrderSnapshot:salesOrderSnapshot];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = [NSString stringWithFormat:@"接单成功"];
            [hub hide:YES afterDelay:kEndSucceedDelayTime];
            
        }else{
            
            [weakSelf.salesOrderList removeObject:salesOrderSnapshot];
            [weakSelf.tableView reloadData];
            [[SalesOrderManager getInstance]removeGrabDictSalesOrderSnapshotByCode:salesOrderSnapshot.code];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kEndFailedDelayTime];
        }
    }];
    
}

-(void)assignSalesOrder:(SalesOrderSnapshot *)salesOrderSnapshot
{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"派单中...";
    hub.userInteractionEnabled = NO;
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERASSIGN,salesOrderSnapshot.code];
    [HttpUtil post:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            [weakSelf.salesOrderList removeObject:salesOrderSnapshot];
            [weakSelf.tableView reloadData];
            [[SalesOrderManager getInstance]removeGrabDictSalesOrderSnapshotByCode:salesOrderSnapshot.code];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = [NSString stringWithFormat:@"派单成功"];
            [hub hide:YES afterDelay:kEndSucceedDelayTime];
            WorkOrder *workOrder = [WorkOrder mj_objectWithKeyValues:obj];
            [workOrder saveToDB];
            [[WorkOrderManager getInstance] sortAllWorkOrder];
            [self pushWorkOrderInfoUI:workOrder.code];
            
        }else{
            
            [weakSelf.salesOrderList removeObject:salesOrderSnapshot];
            [weakSelf.tableView reloadData];
            [[SalesOrderManager getInstance]removeGrabDictSalesOrderSnapshotByCode:salesOrderSnapshot.code];
            
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kEndFailedDelayTime];
        }
    }];
    
}
/**
 * 跳转到WorkOrderInfo界面
 *
 *  @param code 工单code
 */
-(void)pushWorkOrderInfoUI:(NSString *)code{
    WorkOrderInfoController *info = [WorkOrderInfoController new];
    info.workOrderCode = code;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}
@end
