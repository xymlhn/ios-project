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

-(void)bindListener{
    
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
    self.salesOrderList = [[SalesOrderManager getInstance] sortSalesOrder:YES];
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"加载中...";
    [[SalesOrderManager getInstance] getSalesOrderMineByLastUpdateTime:[Config getSalesOrderMineTime] finishBlock:^(NSMutableArray *arr, NSString *error) {
        if(error == nil){
            [self refreshTableView:arr];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = @"加载成功";
            [hub hide:YES afterDelay:kEndSucceedDelayTime];
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kEndFailedDelayTime];
        }
        
    }];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[SalesOrderManager getInstance] getSalesOrderMineByLastUpdateTime:[Config getSalesOrderMineTime] finishBlock:^(NSMutableArray *arr, NSString *error) {
            [self refreshTableView:arr];
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
    SalesOrderInfoController *info = [SalesOrderInfoController doneBlock:^(NSString *code) {
        [self.salesOrderList removeObject:salesOrder];
        [self.tableView reloadData];
    }];
    info.code = salesOrder.code;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}




@end
