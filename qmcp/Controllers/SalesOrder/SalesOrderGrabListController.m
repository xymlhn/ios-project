//
//  SalesOrderBindListController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderGrabListController.h"
#import "UIColor+Util.h"
#import "NSObject+LKDBHelper.h"
#import "UIColor+Util.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "SalesOrderSnapshot.h"
#import "SalesOrderGrabCell.h"
#import "Utils.h"
#import "OSCAPI.h"
#import "SalesOrderManager.h"
#import "Config.h"
#import "ReactiveCocoa.h"
#import "MBProgressHUD.h"
#import "HttpUtil.h"
#import "PchHeader.h"
@interface SalesOrderGrabListController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *salesOrderList;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SalesOrderGrabListController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self loadData];
}

-(void)initView
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

-(void)loadData
{
    if(_salesOrderList == nil)
    {
        _salesOrderList = [NSMutableArray new];
    }
    [[SalesOrderManager getInstance] getSalesOrderConfirmByLastUpdateTime:[Config getSalesOrderGrabTime] finishBlock:^(NSDictionary *dict, NSError *error) {
        [self salesOrderUpdate:dict];
    }];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[SalesOrderManager getInstance] getSalesOrderConfirmByLastUpdateTime:[Config getSalesOrderGrabTime] finishBlock:^(NSDictionary *dict, NSError *error) {
            [self salesOrderUpdate:dict];
        }];
    }];
}

- (void)salesOrderUpdate:(NSDictionary *)dict{
    [self.tableView.mj_header endRefreshing];
    [_salesOrderList removeAllObjects];
    [_salesOrderList addObjectsFromArray:[dict allValues]];
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
    SalesOrderGrabCell *cell = [SalesOrderGrabCell cellWithTableView:tableView];
    //2 设置cell内部的子控件
    SalesOrderSnapshot *salesOrderSnapshot = self.salesOrderList[row];
    cell.grabBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self grabSalesOrder:salesOrderSnapshot];
        return [RACSignal empty];
    }];
    cell.salesOrderSnapshot = salesOrderSnapshot;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //3 返回
    return cell;
}


-(void)dealloc {

}

-(void)grabSalesOrder:(SalesOrderSnapshot *)salesOrderSnapshot
{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"抢单中...";
    hub.userInteractionEnabled = NO;
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_SALESORDERGRAB,salesOrderSnapshot.code];
    NSDictionary *dict = @{@"grab":[NSNumber numberWithBool:YES]};
    [HttpUtil post:URLString param:dict finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            [weakSelf.salesOrderList removeObject:salesOrderSnapshot];
            [weakSelf.tableView reloadData];
            [[SalesOrderManager getInstance]removeGrabDictSalesOrderSnapshotByCode:salesOrderSnapshot.code];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = [NSString stringWithFormat:@"抢单成功"];
            [hub hide:YES afterDelay:0.5];
        }else{
            NSString *message = @"";
            if(obj == nil){
                message =@"抢单失败";
            }else{
                message = [obj valueForKey:@"message"];
                [weakSelf.salesOrderList removeObject:salesOrderSnapshot];
                [weakSelf.tableView reloadData];
                [[SalesOrderManager getInstance]removeGrabDictSalesOrderSnapshotByCode:salesOrderSnapshot.code];
            }
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = message;
            [hub hide:YES afterDelay:0.5];
        }
    }];
    
}

@end
