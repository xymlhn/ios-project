//
//  PickupViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/7/1.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "PickupViewController.h"
#import "PickupView.h"
#import "ScanViewController.h"
#import "QrCodeViewController.h"
#import "SignViewController.h"
#import "Attachment.h"
#import "PickupItem.h"
#import "PickupCell.h"
#import "PickupData.h"
#import "PickupSignature.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppManager.h"
#import "UIScrollView+EmptyDataSet.h"
@interface PickupViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong) PickupView *pickView;
@property (nonatomic,strong) NSMutableArray<PickupItem *> *pickupItemArray;
@property (nonatomic,strong) PickupData *pickupData;
@end

@implementation PickupViewController

-(NSMutableArray<PickupItem *> *)pickupItemArray{
    if(_pickupItemArray == nil){
        _pickupItemArray = [NSMutableArray new];
    }
    return _pickupItemArray;
}
-(void)loadView{
    _pickView = [PickupView viewInstance];
    self.view = _pickView;
    self.navigationItem.title = @"客户取件";
}

-(void)bindListener{
    _pickView.qrButton.userInteractionEnabled = YES;
    [_pickView.qrButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrBtnClick:)]];
    
    _pickView.searchBar.delegate = self;
    _pickView.tableView.delegate = self;
    _pickView.tableView.dataSource = self;
    _pickView.tableView.tableHeaderView = [UIView new];
    _pickView.tableView.tableFooterView = [UIView new];
    _pickView.tableView.emptyDataSetSource = self;
    _pickView.tableView.emptyDataSetDelegate = self;
    
    _pickView.signBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        __weak typeof(self) weakSelf = self;
        if(_pickView.signBtn.enabled){
            SignViewController *signController = [SignViewController doneBlock:^(UIImage *signImage) {
                [weakSelf p_reportSignImage:signImage];
            }];
            [self presentViewController:signController animated: YES completion:nil];
        }
        return [RACSignal empty];
    }];
}

-(void)loadData{
    
}

#pragma mark - empty Table
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@""];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"点击左上角按钮扫描任意物品的二维码\n或\n搜索订单号进行取件";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:kJiupt],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self p_handleResult:searchBar.text];
    searchBar.text =  @"";
    [searchBar resignFirstResponder];
}

#pragma mark - func
/**
 签名图片
 
 @param image 图片
 */
-(void)p_reportSignImage:(UIImage *)image{
    if(image){
        Attachment *attachment = [Attachment new];
        attachment.key = [NSString stringWithFormat:@"%@.jpg",[[NSUUID UUID] UUIDString]];
        [attachment saveToDB];
        PickupSignature *pickupSignature = [PickupSignature new];
        pickupSignature.salesOrderCode = _pickupData.salesOrderCode;
        pickupSignature.pickupTime = [Utils formatDate:[NSDate new]];
        pickupSignature.signatureImageKey = attachment.key;
        NSMutableArray *arr = [NSMutableArray new];
        for (PickupItem *item in self.pickupItemArray) {
            if(item.isChoose){
                [arr addObject:item.code];
            }
        }
        pickupSignature.itemCodes = arr;
        [self p_postPickupData:pickupSignature];
    }
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


/**
 处理返回字符串
 
 @param result result description
 */
-(void)p_handleResult:(NSString *)result{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hub.detailsLabel.text = @"加载中...";
    __weak typeof(self) weakSelf = self;
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_PICKUPITEM,result];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.detailsLabel.text = [NSString stringWithFormat:@"加载成功"];
            [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            _pickupData = [PickupData mj_objectWithKeyValues:obj];
            NSArray<PickupItem *> * items = [PickupItem mj_objectArrayWithKeyValuesArray:_pickupData.items];
            for (PickupItem *pickItem in items) {
                NSArray *attachments = [Attachment mj_objectArrayWithKeyValuesArray:pickItem.attachments];
                pickItem.attachments = attachments;
            }
            if(items.count > 0){
                [weakSelf.pickupItemArray addObjectsFromArray:items];
                [weakSelf.pickView.tableView reloadData];
            }
            [weakSelf.pickView.headView setHidden:NO];
            weakSelf.pickView.signBtn.enabled = YES;
            weakSelf.pickView.nameText.text = [NSString stringWithFormat:@"%@%@",@"客户名:",_pickupData.addressSnapshot.contacts] ;
            weakSelf.pickView.phoneText.text = [NSString stringWithFormat:@"%@%@",@"联系电话:",_pickupData.addressSnapshot.mobilePhone] ;
            weakSelf.pickView.codeText.text = [NSString stringWithFormat:@"%@%@",@"订单编号:",_pickupData.salesOrderCode] ;
        }else{
            weakSelf.pickupData = nil;
            weakSelf.pickView.signBtn.enabled = NO;
            [weakSelf.pickView.headView setHidden:YES];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
    }];
    
}

/**
 提交取件数据
 
 @param pickupSignature pickupSignature
 */
-(void)p_postPickupData:(PickupSignature *)pickupSignature{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hub.detailsLabel.text = @"完成中...";
    __weak typeof(self) weakSelf = self;
    NSDictionary *obj = [pickupSignature mj_keyValues];
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_PICKUPSIGNATURE];
    [HttpUtil post:URLString param:obj finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            [weakSelf.pickView.headView setHidden:YES];
            weakSelf.pickView.signBtn.enabled = YES;
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.detailsLabel.text = [NSString stringWithFormat:@"成功"];
            [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            [weakSelf.pickupItemArray removeAllObjects];
            [weakSelf.pickView.tableView reloadData];
        }else{
            [weakSelf.pickView.headView setHidden:YES];
            weakSelf.pickView.signBtn.enabled = NO;
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
    }];
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pickupItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    PickupCell *cell = [PickupCell cellWithTableView:tableView];
    PickupItem *pickupItem = self.pickupItemArray[row];
    cell.pickupItem = pickupItem;
    
    [[AppManager getInstance]getImageUrlByKey:pickupItem.attachments[0].key andType:pickupItem.attachments[0].type finishBlock:^(NSDictionary *dict, NSString *error) {
        [cell.icon sd_setImageWithURL:[NSURL URLWithString:dict[pickupItem.attachments[0].key]]
                     placeholderImage:[UIImage imageNamed:@"default－portrait.png"]];
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
