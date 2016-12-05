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
#import "UIScrollView+EmptyDataSet.h"
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(nonatomic,strong) SearchView *searchView;
@property(nonatomic,strong) NSMutableArray<WorkOrderSearchResult *> *resultList;
@end

@implementation SearchViewController

-(void)loadView{
    _searchView = [SearchView viewInstance];
    self.view = _searchView;
    self.navigationItem.title = @"搜索";
}

-(void)bindListener{
    _searchView.searchBar.delegate = self;
    _searchView.tableView.delegate = self;
    _searchView.tableView.dataSource = self;
    _searchView.tableView.tableHeaderView = [UIView new];
    _searchView.tableView.tableFooterView = [UIView new];
    _searchView.tableView.emptyDataSetSource = self;
    _searchView.tableView.emptyDataSetDelegate = self;
}

-(void)loadData{
    
}

-(NSMutableArray<WorkOrderSearchResult *> *)resultList{
    if(_resultList == nil){
        _resultList = [NSMutableArray new];
    }
    return _resultList;
}

#pragma mark empty Table
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@""];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"输入工单的编号、时间、客户信息\n或\n表单内容进行搜索";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kJiupt],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)p_pushInfoView:(NSString *)code{
    WorkOrderInfoController *info = [WorkOrderInfoController new];
    info.workOrderCode = code;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
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
    
    [self p_searchWorkOrderByCode:result andCondition:[Config getSearch]];
    
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

-(void)p_searchWorkOrderByCode:(NSString *)string
                  andCondition:(BOOL)condition{
    
    [_searchView.searchBar resignFirstResponder];
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hub.detailsLabel.text = @"正在搜索";
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
                hub.detailsLabel.text = message;
                [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
            }else{
                message = @"搜索成功";
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                hub.detailsLabel.text = message;
                [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            }
            
        }else{
            [weakSelf.resultList removeAllObjects];
            [weakSelf.searchView.tableView reloadData];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
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
    SearchViewCell *cell = [SearchViewCell cellWithTableView:tableView];
    WorkOrderSearchResult *workOrderSearchResult = self.resultList[row];
    cell.workOrderSearchResult = workOrderSearchResult;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    WorkOrderSearchResult *workOrderSearchResult = self.resultList[row];
    if(workOrderSearchResult.dispatchToMeFlag && workOrderSearchResult.status != WorkOrderStatusCompleted){
        WorkOrder *workOrder = [[WorkOrderManager getInstance] findWorkOrderByCode:workOrderSearchResult.code];
        [self p_pushInfoView:workOrder.code];
    }
}


@end
