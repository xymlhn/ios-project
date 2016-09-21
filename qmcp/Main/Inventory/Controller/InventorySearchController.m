//
//  InventorySearchController.m
//  qmcp
//
//  Created by 谢永明 on 16/8/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "InventorySearchController.h"
#import "InventorySearchView.h"
#import "SalesOrderSearchResult.h"
#import "InventorySearchCell.h"
#import "InventoryManager.h"
#import "CommoditySnapshot.h"
#import "InventoryController.h"


@interface InventorySearchController()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) InventorySearchView *searchView;
@property(nonatomic,strong) NSMutableArray<SalesOrderSearchResult *> *resultList;

@end

@implementation InventorySearchController
-(void)loadView{
    _searchView = [InventorySearchView viewInstance];
    _searchView.searchBar.delegate = self;
    self.navigationItem.title = @"搜索";
    
    _searchView.tableView.delegate = self;
    _searchView.tableView.dataSource = self;
    self.view = _searchView;
}

-(void)bindListener{
    
}

-(void)loadData{
    
}

-(NSMutableArray<SalesOrderSearchResult *> *)resultList{
    if(_resultList == nil){
        _resultList = [NSMutableArray new];
    }
    return _resultList;
}

#pragma mark UISearchBarDelegate

//搜索框中的内容发生改变时 回调（即要搜索的内容改变）
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (_searchView.searchBar.text.length == 0) {
        [self setSearchControllerHidden:YES]; //控制下拉列表的隐现
    }else{
        [self setSearchControllerHidden:NO];
        
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.text = @"";
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *result = searchBar.text;
    
    [self searchWorkOrderByCode:result];
    
}

//点击搜索框上的 取消按钮时 调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchView.searchBar.text = @"";
    [_searchView.searchBar resignFirstResponder];
    [self setSearchControllerHidden:YES];
}

- (void) setSearchControllerHidden:(BOOL)hidden {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView commitAnimations];
}

-(void)searchWorkOrderByCode:(NSString *)string{
    
    [_searchView.searchBar resignFirstResponder];
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在搜索";
    hub.userInteractionEnabled = NO;
    
    [[InventoryManager getInstance] getSalesOrderSearchResult:string finishBlock:^(NSMutableArray<SalesOrderSearchResult *> *array, NSString *error) {
        if(!error){
            weakSelf.resultList = array;
            NSString *message;
            if(array.count == 0){
                message = @"搜索不到工单";
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                hub.labelText = message;
                [hub hide:YES afterDelay:kEndFailedDelayTime];
            }else{
                message = @"搜索成功";
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                hub.labelText = message;
                [hub hide:YES afterDelay:kEndSucceedDelayTime];
            }
            [weakSelf.searchView.tableView reloadData];
            
        }else{
            [weakSelf.resultList removeAllObjects];
            [weakSelf.searchView.tableView reloadData];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kEndFailedDelayTime];
        }
    }];
    

    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultList.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    //1 创建可重用的自定义的cell
    InventorySearchCell *cell = [InventorySearchCell cellWithTableView:tableView];
    //2 设置cell内部的子控件
    SalesOrderSearchResult *salesOrderSearchResult = self.resultList[row];
    cell.salesOrderSearchResult = salesOrderSearchResult;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //3 返回
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    SalesOrderSearchResult *salesOrderSearchResult = self.resultList[row];
    if(salesOrderSearchResult.itemConfirmed){
        [Utils showHudTipStr:@"该订单已经清点了!"];
    }else{
        [InventoryManager getInstance].currentSalesOrderCode = salesOrderSearchResult.code;
        __weak typeof(self) weakSelf = self;
        MBProgressHUD *hub = [Utils createHUD];
        hub.labelText = @"正在获取";
        hub.userInteractionEnabled = NO;
        NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERITEM,salesOrderSearchResult.code];
        [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
            if(!error){
                NSArray<CommoditySnapshot *> *commoditySnapshots = [CommoditySnapshot mj_objectArrayWithKeyValuesArray:obj];
                salesOrderSearchResult.commodityItemList = commoditySnapshots;
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                hub.labelText = @"获取成功";
                [hub hide:YES afterDelay:kEndSucceedDelayTime];
                [weakSelf pushInfoView:salesOrderSearchResult.code];
            }else{
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                hub.labelText = error;
                [hub hide:YES afterDelay:kEndFailedDelayTime];
            }

        }];
    }
}

- (void)pushInfoView:(NSString *)salesOrderCode{
    InventoryController *info = [InventoryController new];
    info.salesOrderCode = salesOrderCode;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}
@end