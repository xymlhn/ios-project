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
    
    ItemSnapshot *itemSnapshot = [ItemSnapshot new];
    itemSnapshot.salesOrderItemCode = [[NSUUID UUID] UUIDString];
    long size = _itemSnapshotList.count + 1;
    itemSnapshot.name = [NSString stringWithFormat:@"物品%lu",size];
    itemSnapshot.salesOrderCode = _salesOrderCode;
    [itemSnapshot saveToDB];
    [self p_pushInventoryEditController:itemSnapshot.salesOrderItemCode andType:SaveTypeAdd];
    
}

- (void)saveBtnClick:(UITapGestureRecognizer *)recognizer{
    if (_itemSnapshotList.count == 0) {
        return;
    }
     __weak typeof(self) weakSelf = self;
    SignViewController *signController = [SignViewController doneBlock:^(UIImage *signImage) {
        [weakSelf p_reportSignImage:signImage];
    }];
    [self presentViewController:signController animated: YES completion:nil];
    
}

-(void)p_appendInventory:(ItemSnapshot *)item{
    BOOL flag = NO;
    for(int i = 0;i < _itemSnapshotList.count;i++){
        NSString *code = _itemSnapshotList[i].code;
        if([code isEqualToString:item.code]){
            flag = YES;
        }
    }
    if(!flag){
        [_itemSnapshotList addObject:item];
    }
}

-(void)p_pushInventoryEditController:(NSString *)itemSnapshotCode andType:(SaveType)type{
    __weak typeof(self) weakSelf = self;
    InventoryEditController *info = [InventoryEditController doneBlock:^(ItemSnapshot *item,SaveType type) {
        switch (type) {
            case SaveTypeAdd:
                [weakSelf p_appendInventory:item];
                break;
            case SaveTypeUpdate:
                for (ItemSnapshot *temp in _itemSnapshotList) {
                    if([temp.code isEqualToString:item.code]){
                        item.remark = temp.remark;
                        item.salesOrderItemCode = temp.salesOrderItemCode;
                        item.commodities = temp.commodities;
                        item.attachments = temp.attachments;
                        break;
                    }
                }
                
                break;
            case SaveTypeDelete:
                for (ItemSnapshot *temp in weakSelf.itemSnapshotList) {
                    if([temp.code isEqualToString:item.code]){
                        [weakSelf.itemSnapshotList removeObject:temp];
                        break;
                    }
                }
                break;
            default:
                break;
        }
        [weakSelf.inventoryView.tableView reloadData];
    }];
    info.salesOrderCode = _salesOrderCode;
    info.itemSnapshotCode = itemSnapshotCode;
    info.saveType = type;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

-(void) p_reportSignImage:(UIImage *)image{
    if(image){
        Attachment *attachment = [Attachment new];
        attachment.key = [NSString stringWithFormat:@"%@.jpg",[[NSUUID UUID] UUIDString]];
        attachment.salesOrderCode = _salesOrderCode;
        [Utils saveImage:image andName:attachment.key];
        [attachment saveToDB];
        
        _salesOrderSearchResult.itemConfirmed = YES;
        _salesOrderSearchResult.signatureImageKey = attachment.key;
        
        [self p_postInventoryDataWitCode:_salesOrderCode];
    }else{
        [Utils showHudTipStr:@"请重新签名!"];
    }
    
}

-(void)p_postInventoryDataWitCode:(NSString *)code{
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在上传清点数据";
    NSMutableArray *itemArray = [ItemSnapshot mj_keyValuesArrayWithObjectArray:_itemSnapshotList];
    NSDictionary *inventoryDict = @{@"itemConfirmed":[NSNumber numberWithBool:_salesOrderSearchResult.itemConfirmed],
                                    @"signatureImageKey":_salesOrderSearchResult.signatureImageKey,@"itemSnapshots":itemArray};

    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_POSTINVENTORY,code];
    [HttpUtil post:URLString param:inventoryDict finish:^(NSDictionary *obj, NSString *error) {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    InventoryCell *cell = [InventoryCell cellWithTableView:tableView];
    ItemSnapshot *itemSnapshot = self.itemSnapshotList[row];
    cell.itemSnapshot = itemSnapshot;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemSnapshot *itemSnapshot = self.itemSnapshotList[indexPath.row];
    [self p_pushInventoryEditController:itemSnapshot.salesOrderItemCode andType:SaveTypeUpdate];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ItemSnapshot *itemSnapshot = _itemSnapshotList[indexPath.row];
        if([itemSnapshot deleteToDB]){
            for (Attachment *attachment in itemSnapshot.attachments) {
                 [Utils deleteImage:attachment.key];
            }
            [_itemSnapshotList removeObjectAtIndex:indexPath.row];
            [_inventoryView.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

@end
