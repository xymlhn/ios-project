//
//  WorkOrderInventoryController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderInventoryController.h"
#import "UIColor+Util.h"
#import "WorkOrderInventoryCell.h"
#import "ItemSnapshot.h"
#import "WorkOrderInventoryEditController.h"
#import "QrCodeViewController.h"
#import "ScanViewController.h"
#import "WorkOrderInventoryView.h"
#import "Config.h"
#import "SignViewController.h"
#import "Attachment.h"
#import "Utils.h"
@interface WorkOrderInventoryController ()<UITableViewDataSource,UITableViewDelegate,
                                            QrCodeImageView,ScanImageView,SignView>

@property (nonatomic, strong) NSMutableArray *itemSnapshotList;
@property WorkOrderInventoryView *inventoryView;
@end

@implementation WorkOrderInventoryController

-(void)initView
{
    _inventoryView = [WorkOrderInventoryView new];
    [_inventoryView initView:self.view];
}


-(void)bindListener
{
    _inventoryView.tableView.delegate = self;
    _inventoryView.tableView.dataSource = self;
    
    _inventoryView.addBtn.userInteractionEnabled = YES;
    [_inventoryView.addBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addBtnClick:)]];

    _inventoryView.signBtn.userInteractionEnabled = YES;
    [_inventoryView.signBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveBtnClick:)]];
}

-(void)loadData
{
    NSString *where = [NSString stringWithFormat:@"workOrderCode = '%@'",super.workOrderCode];
    _itemSnapshotList = [ItemSnapshot searchWithWhere:where];
}
- (void)addBtnClick:(UITapGestureRecognizer *)recognizer
{
    if([Config getQuickScan]){
        ScanViewController *info = [ScanViewController new];
        info.hidesBottomBarWhenPushed = YES;
        info.delegate = self;
        [self.navigationController pushViewController:info animated:YES];
    }else{
        QrCodeViewController *info = [QrCodeViewController new];
        info.hidesBottomBarWhenPushed = YES;
        info.delegate = self;
        [self presentViewController:info animated:YES completion:nil];
    }
}

- (void)saveBtnClick:(UITapGestureRecognizer *)recognizer
{
    SignViewController *signController = [SignViewController new];
    signController.hidesBottomBarWhenPushed = YES;
    signController.delegate = self;
    [self.navigationController pushViewController:signController animated:YES];
    
}

-(void)reloadView
{
    [self loadData];
    [_inventoryView.tableView reloadData];
}

-(void)reportSignImage:(UIImage *)image
{
    if(image){
        Attachment *attachment = [Attachment new];
        attachment.key = [NSString stringWithFormat:@"%@.jpg",[[NSUUID UUID] UUIDString]];
        attachment.workOrderCode = [super workOrderCode];
        attachment.path = [Utils saveImage:image andName:attachment.key];
        [attachment saveToDB];
    }
}

#pragma mark code
- (void)reportQrCodeResult:(NSString *)result
{
    [self handleResult:result];
}

- (void)reportScanResult:(NSString *)result
{
    [self handleResult:result];
}

-(void)handleResult:(NSString *)result
{
    ItemSnapshot *itemSnapshot = [ItemSnapshot new];
    itemSnapshot.salesOrderItemCode = [[NSUUID UUID] UUIDString];
    itemSnapshot.code = result;
    long size = _itemSnapshotList.count + 1;
    itemSnapshot.name = [NSString stringWithFormat:@"物品%lu",size];
    itemSnapshot.workOrderCode = [super workOrderCode];
    [itemSnapshot saveToDB];
    WorkOrderInventoryEditController *info = [WorkOrderInventoryEditController new];
    info.workOrderCode = [super workOrderCode];
    info.workOrderStepCode = itemSnapshot.salesOrderItemCode;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemSnapshotList.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    WorkOrderInventoryCell *cell = [WorkOrderInventoryCell cellWithTableView:tableView];
    ItemSnapshot *itemSnapshot = self.itemSnapshotList[row];
    cell.itemSnapshot = itemSnapshot;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    WorkOrderInventoryEditController *info = [WorkOrderInventoryEditController new];
    ItemSnapshot *itemSnapshot = self.itemSnapshotList[indexPath.row];
    info.workOrderCode = [super workOrderCode];
    info.workOrderStepCode = itemSnapshot.code;
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
        }else{
            
        }
        
    }
}

@end
