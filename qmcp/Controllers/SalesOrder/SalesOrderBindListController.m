//
//  SalesOrderBindListController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderBindListController.h"
#import "UIColor+Util.h"
#import "NSObject+LKDBHelper.h"
#import "UIColor+Util.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "SalesOrderSnapshot.h"
#import "SalesOrderBindCell.h"
#import "Utils.h"
#import "OSCAPI.h"
#import "SalesOrderManager.h"
#import "Config.h"
#import "PchHeader.h"
#import "QrCodeBindController.h"
@interface SalesOrderBindListController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *salesOrderList;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SalesOrderBindListController

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
    [[SalesOrderManager getInstance] getSalesOrderBindByLastUpdateTime:[Config getSalesOrderBindTime] finishBlock:^(NSDictionary *dict, NSError *error) {
        [self refreshUIWithDict:dict];
    }];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[SalesOrderManager getInstance] getSalesOrderBindByLastUpdateTime:[Config getSalesOrderBindTime] finishBlock:^(NSDictionary *dict, NSError *error) {
            [self refreshUIWithDict:dict];
        }];
    }];
}

-(void)refreshUIWithDict:(NSDictionary *)dict{
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
    SalesOrderBindCell *cell = [SalesOrderBindCell cellWithTableView:tableView];
    //2 设置cell内部的子控件
    SalesOrderSnapshot *salesOrderSnapshot = self.salesOrderList[row];
    cell.salesOrderSnapshot = salesOrderSnapshot;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //3 返回
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesOrderSnapshot *salesOrderSnapshot = self.salesOrderList[indexPath.row];
    NSString *url = [NSString stringWithFormat:@"%@%@",OSCAPI_ADDRESS,salesOrderSnapshot.qrCodeUrl];
    QrCodeBindController *controller = [QrCodeBindController doneBlock:^(NSString *salesOrderCode) {
        [_salesOrderList removeObject:salesOrderSnapshot];
        [[SalesOrderManager getInstance] removeBindDictSalesOrderSnapshotByCode:salesOrderCode];
        [self.tableView reloadData];
    }];
    controller.salesOrderCode = salesOrderSnapshot.code;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.qrCodeUrl = url;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        controller.providesPresentationContextTransitionStyle = YES;
        controller.definesPresentationContext = YES;
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.tabBarController presentViewController:controller animated:YES completion:nil];
        
    } else {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:controller animated:NO completion:nil];
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}


-(void)dealloc {

}


@end
