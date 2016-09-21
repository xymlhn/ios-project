//
//  SearchViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/7/2.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchView.h"
#import "WorkOrderManager.h"
#import "WorkOrderCell.h"
#import "WorkOrderInfoController.h"
#import "WorkOrderSearchResult.h"
#import "SearchViewCell.h"
#import "Config.h"
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) SearchView *searchView;
@property(nonatomic,strong) NSMutableArray<WorkOrderSearchResult *> *resultList;
@end

@implementation SearchViewController

-(void)loadView{
    _searchView = [SearchView viewInstance];
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

-(NSMutableArray<WorkOrderSearchResult *> *)resultList{
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
    
    [self searchWorkOrderByCode:result andCondition:[Config getSearch]];

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

-(void)searchWorkOrderByCode:(NSString *)string
                andCondition:(BOOL)condition{
    
    [_searchView.searchBar resignFirstResponder];
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在搜索";
    hub.userInteractionEnabled = NO;

    [[WorkOrderManager getInstance] searchWorkOrderWithString:string andCondition:condition finishBlock:^(NSDictionary *obj, NSString *error) {
        if(!error){
            [weakSelf.resultList removeAllObjects];
            NSArray<WorkOrderSearchResult *> *arr = [WorkOrderSearchResult mj_objectArrayWithKeyValuesArray:obj];
            [weakSelf.resultList addObjectsFromArray:arr];
            [weakSelf.searchView.tableView reloadData];
            weakSelf.searchView.searchBar.text = @"";
            NSString *message;
            if(arr.count == 0){
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultList.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    //1 创建可重用的自定义的cell
    SearchViewCell *cell = [SearchViewCell cellWithTableView:tableView];
    //2 设置cell内部的子控件
    WorkOrderSearchResult *workOrderSearchResult = self.resultList[row];
    cell.workOrderSearchResult = workOrderSearchResult;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //3 返回
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    WorkOrderSearchResult *workOrderSearchResult = self.resultList[row];
    if(workOrderSearchResult.dispatchToMeFlag && workOrderSearchResult.status != WorkOrderStatusCompleted){
        WorkOrder *workOrder = [[WorkOrderManager getInstance] findWorkOrderByCode:workOrderSearchResult.code];
        [self pushInfoView:workOrder.code];
    }else{
        
    }
    
    
}

- (void)pushInfoView:(NSString *)code
{
    WorkOrderInfoController *info = [WorkOrderInfoController new];
    info.workOrderCode = code;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}
@end
