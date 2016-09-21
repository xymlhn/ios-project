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
#import "PickupManager.h"
#import "ItemComplete.h"
#import "PickupNoticeCell.h"

@interface PickupNoticeViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic,strong) PickupNoticeView *pickupNoticeView;
@property (nonatomic,strong) NSMutableArray<ItemComplete *> *itemCompleteArray;
@end

@implementation PickupNoticeViewController

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
    
    _pickupNoticeView.searchBar.delegate = self;
}

-(void)loadData{
 
}

-(NSMutableArray<ItemComplete *> *)itemCompleteArray{
    if (_itemCompleteArray == nil) {
        _itemCompleteArray = [NSMutableArray new];
    }
    return _itemCompleteArray;
}

/**
 * 跳转界面
 *
 *  @param controller
 */
-(void)pushWorkOrderInfoUI:(UIViewController *)controller{
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self handleResult:searchBar.text];
    searchBar.text =  @"";
    [searchBar resignFirstResponder];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemCompleteArray.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    //1 创建可重用的自定义的cell
    PickupNoticeCell *cell = [PickupNoticeCell cellWithTableView:tableView];
    //2 设置cell内部的子控件
    ItemComplete *itemComplete = self.itemCompleteArray[row];
    cell.itemComplete = itemComplete;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //3 返回
    return cell;
}

#pragma mark - IBAction
-(void)qrBtnClick:(UITapGestureRecognizer *)recognizer
{
     __weak typeof(self) weakSelf = self;
    if([Config getQuickScan]){
        ScanViewController *scanViewController =  [ScanViewController doneBlock:^(NSString *textValue) {
            [weakSelf handleResult:textValue];
        }];
        [self pushWorkOrderInfoUI:scanViewController];
    }else{
        QrCodeViewController *qrCodeViewController = [QrCodeViewController doneBlock:^(NSString *textValue) {
            [weakSelf handleResult:textValue];
        }];
        [self pushWorkOrderInfoUI:qrCodeViewController];
    }
}

-(void)handleResult:(NSString *)result
{
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"加载中...";
    hub.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [[PickupManager getInstance] itemCompleteByCode:result finishBlock:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            [hub hide:YES afterDelay:kEndSucceedDelayTime];
            ItemComplete *itemComplete = [ItemComplete mj_objectWithKeyValues:obj];
            [weakSelf.itemCompleteArray insertObject:itemComplete atIndex:0];
            [weakSelf.pickupNoticeView.tableView reloadData];
        }else{

            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kEndFailedDelayTime];
        }
    }];
    
    
}
@end