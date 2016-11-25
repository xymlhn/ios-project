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
#import "SalesOrder.h"
#import "SalesOrderGrabCell.h"
#import "SalesOrderManager.h"
#import "SalesOrderInfoController.h"
@interface SalesOrderGrabListController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<SalesOrder *> *salesOrderList;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SalesOrderGrabListController

#pragma mark - BaseViewController
-(void)setupView{
    _tableView = [UITableView new];
    _tableView.rowHeight = 100;
    _tableView.backgroundColor = [UIColor themeColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor lineColor];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
}

-(void)loadData{
    
    MBProgressHUD *hub = [Utils createHUD];
    hub.detailsLabel.text = @"加载中...";
    
    [[SalesOrderManager getInstance] getSalesOrderConfirm:^(NSMutableArray *arr, NSString *error) {
        if(error == nil){
            [self refreshTableView:arr];
            if([arr count] > 0){
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HUD-done"]];
                hub.detailsLabel.text = @"加载成功";
                [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            }else{
                hub.detailsLabel.text = @"当前没有待抢订单！";
                [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            }
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
        
    }];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[SalesOrderManager getInstance] getSalesOrderConfirm:^(NSMutableArray *arr, NSString *error) {
            if(!error){
                [self refreshTableView:arr];
            }
            [_tableView.mj_header endRefreshing];
        }];
    }];
}

//刷新列表
- (void)refreshTableView:(NSMutableArray *)arr{
    _salesOrderList = arr;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _salesOrderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    SalesOrderGrabCell *cell = [SalesOrderGrabCell cellWithTableView:tableView];
    SalesOrder *salesOrderSnapshot = _salesOrderList[row];
    cell.grabBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self p_grabSalesOrder:salesOrderSnapshot];
        return [RACSignal empty];
    }];
    cell.salesOrder = salesOrderSnapshot;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 抢单
/**
 抢单

 @param salesOrder 订单
 */
-(void)p_grabSalesOrder:(SalesOrder *)salesOrder{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.detailsLabel.text = @"接单中...";
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERGRAB,salesOrder.code];
    NSDictionary *dict = @{@"grab":[NSNumber numberWithBool:YES]};
    [HttpUtil post:URLString param:dict finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.detailsLabel.text = [NSString stringWithFormat:@"接单成功"];
            [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            [weakSelf.salesOrderList removeObject:salesOrder];
            [weakSelf.tableView reloadData];
            [[SalesOrderManager getInstance] saveOrUpdateSalesOrder:salesOrder];
            
            SalesOrderInfoController *info = [SalesOrderInfoController doneBlock:^(NSString *code) {
                NSNotification * notice = [NSNotification notificationWithName:SalesOrderUpdateNotification object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }];
            info.code = salesOrder.code;
            info.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:info animated:YES];
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
    }];
    
}

@end
