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
    self.salesOrderList = [[SalesOrderManager getInstance] sortSalesOrder:NO];
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"加载中...";
    hub.userInteractionEnabled = NO;
    [[SalesOrderManager getInstance] getSalesOrderConfirmByLastUpdateTime:[Config getSalesOrderGrabTime]  finishBlock:^(NSMutableArray *arr, NSString *error) {
        if(error == nil){
            [self refreshTableView:arr];
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
        [[SalesOrderManager getInstance] getSalesOrderConfirmByLastUpdateTime:[Config getSalesOrderGrabTime] finishBlock:^(NSMutableArray *arr, NSString *error) {
            if(error != nil){
                [self refreshTableView:arr];
            }
            [_tableView.mj_header endRefreshing];
        }];
    }];
}

- (void)refreshTableView:(NSMutableArray *)arr{
    _salesOrderList = arr;
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
        [self grabSalesOrder:salesOrderSnapshot];
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
            
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = [NSString stringWithFormat:@"接单成功"];
            [hub hide:YES afterDelay:kEndSucceedDelayTime];
            
        }else{
            
            [weakSelf.salesOrderList removeObject:salesOrderSnapshot];
            [weakSelf.tableView reloadData];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kEndFailedDelayTime];
        }
    }];
    
}


@end
