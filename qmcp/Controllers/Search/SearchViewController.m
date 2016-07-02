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
@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) SearchView *searchView;
@property(nonatomic,strong) HistoryViewController *historyViewController;
@property(nonatomic,strong) NSMutableArray<WorkOrder *> *workOrderList;
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
    _workOrderList = [NSMutableArray new];
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
    WorkOrder *workOrder = [[WorkOrderManager getInstance] findWorkOrderByCode:result];
    if(workOrder){
        [_workOrderList addObject:workOrder];
        [_searchView.tableView reloadData];
    }
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.workOrderList.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    //1 创建可重用的自定义的cell
    WorkOrderCell *cell = [WorkOrderCell cellWithTableView:tableView];
    //2 设置cell内部的子控件
    WorkOrder *workOrder = self.workOrderList[row];
    cell.workOrder = workOrder;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushInfoView:)]];
    //3 返回
    return cell;
}

#pragma mark - IBAction
- (void)pushInfoView:(UITapGestureRecognizer *)recognizer
{
    WorkOrderInfoController *info = [WorkOrderInfoController new];
    WorkOrder *workOrder = self.workOrderList[recognizer.view.tag];
    info.workOrderCode = workOrder.code;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}
@end
