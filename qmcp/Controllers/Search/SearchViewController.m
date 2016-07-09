//
//  SearchViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/7/2.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchView.h"
#import "HistoryViewController.h"
#import "WorkOrderManager.h"
#import "WorkOrderCell.h"
#import "WorkOrderInfoController.h"
#import "WorkOrderSearchResult.h"
#import "SearchViewCell.h"
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) SearchView *searchView;
@property(nonatomic,strong) HistoryViewController *historyViewController;
@property(nonatomic,strong) NSMutableArray<WorkOrderSearchResult *> *resultList;
@end

@implementation SearchViewController
-(void)initView{
    _searchView = [SearchView new];
    [_searchView initView:self.view];
    _searchView.searchBar.delegate = self;
    self.navigationItem.title = @"搜索";
    
    _historyViewController = [[HistoryViewController alloc] initWithStyle:UITableViewStylePlain];
    [_historyViewController.view setFrame:CGRectMake(30, 40, 200, 0)];
    
    _searchView.tableView.delegate = self;
    _searchView.tableView.dataSource = self;
}

-(void)bindListener{
    
}

-(void)loadData{
    _resultList = [NSMutableArray new];
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
    
    [self searchWorkOrderByCode:result andCondition:NO];

}

//点击搜索框上的 取消按钮时 调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchView.searchBar.text = @"";
    [_searchView.searchBar resignFirstResponder];
    [self setSearchControllerHidden:YES];
}

- (void) setSearchControllerHidden:(BOOL)hidden {
    NSInteger height = hidden ? 0: 180;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    [_historyViewController.view setFrame:CGRectMake(30, 36, 200, height)];
    [UIView commitAnimations];
}

-(void)searchWorkOrderByCode:(NSString *)string andCondition:(BOOL)condition{
    
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
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = [NSString stringWithFormat:@"搜索成功"];
            [hub hide:YES];
        }else{
            [weakSelf.resultList removeAllObjects];
            [weakSelf.searchView.tableView reloadData];
            NSString *message = @"";
            if(obj == nil){
                message =@"搜索失败";
            }else{
                message = [obj valueForKey:@"message"];
            }
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = message;
            [hub hide:YES afterDelay:1];
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
