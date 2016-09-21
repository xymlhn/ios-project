//
//  WorkOrderInventoryController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "InventoryController.h"
#import "InventoryCell.h"
#import "ItemSnapshot.h"
#import "InventoryEditController.h"
#import "QrCodeViewController.h"
#import "ScanViewController.h"
#import "InventoryView.h"
#import "SignViewController.h"
#import "Attachment.h"
#import "WorkOrderManager.h"
#import "SalesOrderSearchResult.h"
#import "InventoryManager.h"
@interface InventoryController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<ItemSnapshot *> *itemSnapshotList;
@property (nonatomic, strong) InventoryView *inventoryView;
@property (nonatomic, strong) SalesOrderSearchResult *salesOrderSearchResult;
@end

@implementation InventoryController

#pragma mark - BaseWorkOrderViewController
-(void)loadView{
    _inventoryView = [InventoryView viewInstance];
    self.view = _inventoryView;
    self.title = @"清点";
}

-(void)bindListener{
    _inventoryView.tableView.delegate = self;
    _inventoryView.tableView.dataSource = self;
    
    _inventoryView.addBtn.userInteractionEnabled = YES;
    [_inventoryView.addBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appendBtnClick:)]];

    _inventoryView.signBtn.userInteractionEnabled = YES;
    [_inventoryView.signBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveBtnClick:)]];
}

-(void)loadData{
    _salesOrderSearchResult = [[InventoryManager getInstance] getSalesOrderSearchResultByCode:_salesOrderCode];
    NSString *where = [NSString stringWithFormat:@"salesOrderCode = '%@'",_salesOrderSearchResult.code];
    _itemSnapshotList = [ItemSnapshot searchWithWhere:where];
}

#pragma mark - IBAction
- (void)appendBtnClick:(UITapGestureRecognizer *)recognizer{
    __weak typeof(self) weakSelf = self;
    ItemSnapshot *itemSnapshot = [ItemSnapshot new];
    itemSnapshot.salesOrderItemCode = [[NSUUID UUID] UUIDString];
    long size = _itemSnapshotList.count + 1;
    itemSnapshot.name = [NSString stringWithFormat:@"物品%lu",size];
    itemSnapshot.salesOrderCode = _salesOrderCode;
    [itemSnapshot saveToDB];
    
    InventoryEditController *info = [InventoryEditController doneBlock:^(BOOL isDelete, ItemSnapshot *item) {
        if(!isDelete){
            [weakSelf.itemSnapshotList addObject:item];
            [weakSelf.inventoryView.tableView reloadData];
        }
    }];
    info.itemSnapshotCode = itemSnapshot.salesOrderItemCode;
    info.salesOrderCode = _salesOrderCode;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)saveBtnClick:(UITapGestureRecognizer *)recognizer{
     __weak typeof(self) weakSelf = self;
    SignViewController *signController = [SignViewController doneBlock:^(UIImage *signImage) {
        [weakSelf reportSignImage:signImage];
    }];
    [self presentViewController:signController animated: YES completion:nil];
    
}

-(void) reportSignImage:(UIImage *)image{
    if(image){
        Attachment *attachment = [Attachment new];
        attachment.key = [NSString stringWithFormat:@"%@.jpg",[[NSUUID UUID] UUIDString]];
        attachment.salesOrderCode = _salesOrderCode;
        [Utils saveImage:image andName:attachment.key];
        [attachment saveToDB];
        
        _salesOrderSearchResult.itemConfirmed = YES;
        _salesOrderSearchResult.signatureImageKey = attachment.key;
        
        [self postWorkOrderInventoryWitCode:_salesOrderCode];
    }else{
        [Utils showHudTipStr:@"请重新签名!"];
    }
    
}

-(void)postWorkOrderInventoryWitCode:(NSString *)code{
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在上传清点数据";
    hub.userInteractionEnabled = NO;

    NSMutableArray *itemArray = [ItemSnapshot mj_keyValuesArrayWithObjectArray:_itemSnapshotList];
    
    NSDictionary *inventoryDict = @{@"itemConfirmed":[NSNumber numberWithBool:_salesOrderSearchResult.itemConfirmed],
                                    @"signatureImageKey":_salesOrderSearchResult.signatureImageKey,@"itemSnapshots":itemArray};

    [[WorkOrderManager getInstance] postWorkOrderInventoryWithCode:code andParams:inventoryDict finishBlock:^(NSDictionary *dict, NSString *error) {
        if (!error) {
            NSMutableArray *attachments = [NSMutableArray new];
            for (ItemSnapshot *item in _itemSnapshotList) {
                for(Attachment *attachment in item.attachments)
                {
                    if(!attachment.isUpload){
                        [attachments addObject:attachment];
                    }
                }
                
            }
            if(attachments.count > 0){
                int i= 0;
                for(Attachment *attachment in attachments)
                {
                    i++;
                    hub.labelText = [NSString stringWithFormat:@"正在上传附件"];
                    [[WorkOrderManager getInstance] postAttachment:attachment finishBlock:^(NSDictionary *obj,NSString *error) {
                        if (!error) {
                            attachment.isUpload = YES;
                            [attachment updateToDB];
                            if(i == attachments.count)
                            {
                                hub.labelText = [NSString stringWithFormat:@"上传工单附件成功"];
                                [hub hide:YES afterDelay:kEndSucceedDelayTime];
                            }
                        }else{
                            hub.mode = MBProgressHUDModeCustomView;
                            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                            hub.labelText = error;
                            [hub hide:YES afterDelay:kEndFailedDelayTime];
                        }
                    }];
                }
            }else
            {
                hub.labelText = [NSString stringWithFormat:@"上传工单步骤成功"];
                [hub hide:YES afterDelay:kEndSucceedDelayTime];
            }
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kEndFailedDelayTime];
            
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemSnapshotList.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    InventoryCell *cell = [InventoryCell cellWithTableView:tableView];
    ItemSnapshot *itemSnapshot = self.itemSnapshotList[row];
    cell.itemSnapshot = itemSnapshot;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    InventoryEditController *info = [InventoryEditController doneBlock:^(BOOL isDelete, ItemSnapshot *item) {
        [weakSelf loadData];
        [weakSelf.inventoryView.tableView reloadData];
    }];
    ItemSnapshot *itemSnapshot = self.itemSnapshotList[indexPath.row];
    info.itemSnapshotCode = itemSnapshot.salesOrderItemCode;
    info.salesOrderCode = _salesOrderCode;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if([_itemSnapshotList[indexPath.row] deleteToDB]){
            [_itemSnapshotList removeObjectAtIndex:indexPath.row];
            [_inventoryView.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}

@end
