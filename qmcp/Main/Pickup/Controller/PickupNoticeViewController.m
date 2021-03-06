//
//  PickupNoticeViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/7/7.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "PickupNoticeViewController.h"
#import "PickupNoticeView.h"
#import "ScanViewController.h"
#import "QrCodeViewController.h"
#import "ItemComplete.h"
#import "PickupNoticeCell.h"
#import "UIScrollView+EmptyDataSet.h"
@interface PickupNoticeViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong) PickupNoticeView *pickupNoticeView;
@property (nonatomic,strong) NSMutableArray<ItemComplete *> *itemCompleteArray;
@end

@implementation PickupNoticeViewController

-(NSMutableArray<ItemComplete *> *)itemCompleteArray{
    if (_itemCompleteArray == nil) {
        _itemCompleteArray = [NSMutableArray new];
    }
    return _itemCompleteArray;
}

#pragma mark - BaseViewController
-(void)loadView{
    _pickupNoticeView = [PickupNoticeView viewInstance];
    self.view = _pickupNoticeView;
    self.navigationItem.title = @"完成物品";
}

-(void)bindListener{
    _pickupNoticeView.qrButton.userInteractionEnabled = YES;
    [_pickupNoticeView.qrButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrBtnClick:)]];
    
    _pickupNoticeView.tableView.delegate = self;
    _pickupNoticeView.tableView.dataSource = self;
    _pickupNoticeView.tableView.tableHeaderView = [UIView new];
    _pickupNoticeView.tableView.tableFooterView = [UIView new];
    _pickupNoticeView.tableView.emptyDataSetSource = self;
    _pickupNoticeView.tableView.emptyDataSetDelegate = self;
    _pickupNoticeView.searchBar.delegate = self;
}

-(void)loadData{
    
}

#pragma empty Table
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@""];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"点击左上角按钮扫描物品的二维码\n或\n输入物品的二维码编码";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kShierpt],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

/**
 * 跳转界面
 *
 *  @param controller
 */
-(void)p_pushWorkOrderInfoUI:(UIViewController *)controller{
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self p_handleResult:searchBar.text];
    searchBar.text =  @"";
    [searchBar resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemCompleteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    PickupNoticeCell *cell = [PickupNoticeCell cellWithTableView:tableView];
    ItemComplete *itemComplete = self.itemCompleteArray[row];
    cell.itemComplete = itemComplete;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - IBAction
-(void)qrBtnClick:(UITapGestureRecognizer *)recognizer{
    __weak typeof(self) weakSelf = self;
    if([Config getQuickScan]){
        ScanViewController *scanViewController =  [ScanViewController doneBlock:^(NSString *textValue) {
            [weakSelf p_handleResult:textValue];
        }];
        [self p_pushWorkOrderInfoUI:scanViewController];
    }else{
        QrCodeViewController *qrCodeViewController = [QrCodeViewController doneBlock:^(NSString *textValue) {
            [weakSelf p_handleResult:textValue];
        }];
        [self p_pushWorkOrderInfoUI:qrCodeViewController];
    }
}

-(void)p_handleResult:(NSString *)result{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hub.detailsLabel.text = @"请求中...";
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dict = @{@"code":result};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_ITEM_COMPLETE];
    [HttpUtil postFormData:URLString param:dict finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            [hub hideAnimated:YES];
            ItemComplete *itemComplete = [ItemComplete mj_objectWithKeyValues:obj];
            [weakSelf.itemCompleteArray insertObject:itemComplete atIndex:0];
            [weakSelf.pickupNoticeView.tableView reloadData];
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
    }];
}
@end
