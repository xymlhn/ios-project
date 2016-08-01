//
//  PickupViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/7/1.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "PickupViewController.h"
#import "PickupView.h"
#import "Config.h"
#import "ScanViewController.h"
#import "QrCodeViewController.h"
#import "MBProgressHUD.h"
#import "SignViewController.h"
#import "Attachment.h"
#import "PickupManager.h"
#import "PickupItem.h"
#import "PickupCell.h"
#import "PickupData.h"
#import "MJExtension.h"
#import "PickupSignature.h"
#import "Utils.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppManager.h"
@interface PickupViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) PickupView *pickView;
@property (nonatomic,strong) NSMutableArray<PickupItem *> *pickupItemArray;
@property (nonatomic,strong) PickupData *pickupData;
@end

@implementation PickupViewController

-(void)loadView{
    _pickView = [PickupView viewInstance];
    self.view = _pickView;
    self.navigationItem.title = @"客户取件";
}

-(void)bindListener{
    _pickView.qrButton.userInteractionEnabled = YES;
    [_pickView.qrButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrBtnClick:)]];
    
    _pickView.signButton.userInteractionEnabled = YES;
    [_pickView.signButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signBtnClick:)]];
    
    _pickView.searchBar.delegate = self;
    
    _pickView.tableView.delegate = self;
    _pickView.tableView.dataSource = self;
}

-(void)loadData{
    
}


-(NSMutableArray<PickupItem *> *)pickupItemArray{
    if(_pickupItemArray == nil){
        _pickupItemArray = [NSMutableArray new];
    }
    return _pickupItemArray;
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
    return self.pickupItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

-(void)signBtnClick:(UITapGestureRecognizer *)recognizer
{
    if(_pickupData == nil)
    {
        return;
    }
    __weak typeof(self) weakSelf = self;
    SignViewController *signController = [SignViewController doneBlock:^(UIImage *signImage) {
        [weakSelf reportSignImage:signImage];
    }];
    [self presentViewController:signController animated: YES completion:nil];
}

-(void)reportSignImage:(UIImage *)image
{
    if(image){
        Attachment *attachment = [Attachment new];
        attachment.key = [NSString stringWithFormat:@"%@.jpg",[[NSUUID UUID] UUIDString]];
        
        attachment.path = [Utils saveImage:image andName:attachment.key];
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
        [self postPickupData:pickupSignature];
    }
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


-(void)handleResult:(NSString *)result
{
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"加载中...";
    __weak typeof(self) weakSelf = self;
    [[PickupManager getInstance] getPickupItemByCode:result finishBlock:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = [NSString stringWithFormat:@"加载成功"];
            [hub hide:YES];
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
            weakSelf.pickView.nameText.text = [NSString stringWithFormat:@"%@%@",@"客户名:",_pickupData.addressSnapshot.contacts] ;
            weakSelf.pickView.phoneText.text = [NSString stringWithFormat:@"%@%@",@"联系电话:",_pickupData.addressSnapshot.mobilePhone] ;
            weakSelf.pickView.codeText.text = [NSString stringWithFormat:@"%@%@",@"订单编号:",_pickupData.salesOrderCode] ;
        }else{
            weakSelf.pickupData = nil;
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kDelayTime];
        }
    }];
    
    
}

-(void)postPickupData:(PickupSignature *)pickupSignature
{
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"完成中...";
    hub.userInteractionEnabled = NO;
    
    [[PickupManager getInstance] postPickupSignature:pickupSignature finishBlock:^(NSDictionary *obj, NSString *error) {
        
        
        if (!error) {
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = [NSString stringWithFormat:@"成功"];
            [hub hide:YES];
        }else{

            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kDelayTime];
        }
    }];
    
}
@end
