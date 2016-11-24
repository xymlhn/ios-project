//
//  SalesOrderBindListController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderMineListController.h"
#import "MJRefresh.h"
#import "SalesOrder.h"
#import "SalesOrderMineCell.h"
#import "SalesOrderManager.h"
#import "SalesOrderInfoController.h"
@interface SalesOrderMineListController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *salesOrderList;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SalesOrderMineListController
-(void)setupView
{
    _tableView = [UITableView new];
    _tableView.rowHeight = 100;
    _tableView.separatorColor = [UIColor lineColor];
    _tableView.backgroundColor = [UIColor themeColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(salesOrderUpdate:) name:SalesOrderUpdateNotification object:nil];
}

#pragma mark - Notification
- (void)salesOrderUpdate:(NSNotification *)text{
    self.salesOrderList = [[SalesOrderManager getInstance] getAllSalesOrder];
    [self.tableView reloadData];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(NSMutableArray *)salesOrderList{
    if(_salesOrderList == nil)
    {
        _salesOrderList = [NSMutableArray new];
    }
    return _salesOrderList;
}

-(void)loadData
{
    self.salesOrderList = [[SalesOrderManager getInstance] getAllSalesOrder];
    MBProgressHUD *hub = [Utils createHUD];
    hub.detailsLabel.text = @"加载中...";
    [[SalesOrderManager getInstance] getSalesOrderMineByLastUpdateTime:[Config getSalesOrderMineTime] finishBlock:^(NSMutableArray *arr, NSString *error) {
        if(error == nil){
            [self refreshTableView:arr];
            if([arr count] > 0){
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                hub.detailsLabel.text = @"加载成功";
                [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            }else{
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                hub.detailsLabel.text = @"当前没有订单";
                [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
            }
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
        
    }];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[SalesOrderManager getInstance] getSalesOrderMineByLastUpdateTime:[Config getSalesOrderMineTime] finishBlock:^(NSMutableArray *arr, NSString *error) {
            if(!error){
                [self refreshTableView:arr];
            }
            [_tableView.mj_header endRefreshing];
        }];
    }];
}

-(void)refreshTableView:(NSMutableArray *)arr{
    self.salesOrderList = arr;
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.salesOrderList.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    //1 创建可重用的自定义的cell
    SalesOrderMineCell *cell = [SalesOrderMineCell cellWithTableView:tableView];
    //2 设置cell内部的子控件
    SalesOrder *salesOrderSnapshot = self.salesOrderList[row];
    cell.salesOrder = salesOrderSnapshot;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //3 返回
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesOrder *salesOrder = self.salesOrderList[indexPath.row];
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.detailsLabel.text = @"正在获取订单详细信息";
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERDETAIL,salesOrder.code];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if(!error){
            hub.detailsLabel.text = @"";
            [hub hideAnimated:YES];
            SalesOrder *tempSalesOrder = [SalesOrder mj_objectWithKeyValues:obj];
            [[SalesOrderManager getInstance] saveOrUpdateSalesOrder:tempSalesOrder];
            SalesOrderInfoController *info = [SalesOrderInfoController doneBlock:^(NSString *code) {
                [weakSelf.salesOrderList removeObject:salesOrder];
                [weakSelf.tableView reloadData];
            }];
            info.code = salesOrder.code;
            info.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:info animated:YES];
            
        }else{
            if(![error isEqualToString:kServiceError]){
                [weakSelf.salesOrderList removeObject:salesOrder];
                [weakSelf.tableView reloadData];
            }
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
        
    }];

}




@end
