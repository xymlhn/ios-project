
//
//  WorkOrderInventoryEditController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderInventoryEditController.h"
#import "WorkOrder.h"
#import "Attachment.h"
#import "ItemSnapshot.h"
#import "PhotoCell.h"
#import "WorkOrderInventoryEditView.h"
#import "WorkOrderInventoryView.h"
#import "CommodityCell.h"
#import "Commodity.h"
#import "SettingViewCell.h"
#import "StandardsView.h"
#import "PropertyManager.h"
#import "CommodityProperty.h"
#import "PropertyChoose.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ChooseViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "ScanViewController.h"
#import "QrCodeViewController.h"
@interface WorkOrderInventoryEditController ()<UINavigationControllerDelegate,UICollectionViewDataSource,
                                                UICollectionViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) ItemSnapshot *itemSnapshot;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) WorkOrderInventoryEditView *inventoryEditView;
@property (nonatomic, assign) BOOL unLock;



@end

@implementation WorkOrderInventoryEditController

#pragma mark - BaseWorkOrderViewController
-(void)loadView
{
     _inventoryEditView = [WorkOrderInventoryEditView viewInstance];
    self.view = _inventoryEditView;
    self.title = @"清点编辑";
}

-(void)bindListener
{
    _inventoryEditView.photoTableView.delegate = self;
    _inventoryEditView.photoTableView.dataSource = self;
    
    _inventoryEditView.lockIcon.userInteractionEnabled = YES;
    [_inventoryEditView.lockIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lockIconClick:)]];

    
     __weak typeof(self) weakSelf = self;
    _inventoryEditView.qrBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        if([Config getQuickScan]){
            ScanViewController *scanViewController = [ScanViewController doneBlock:^(NSString *textValue) {
                [weakSelf handleQrCode:textValue];
            }];
            [self.navigationController pushViewController:scanViewController animated:YES];
        }else{
            QrCodeViewController *info = [QrCodeViewController doneBlock:^(NSString *textValue) {
                [weakSelf handleQrCode:textValue];
            }];
            [self.navigationController pushViewController:info animated:YES];
        }
        return [RACSignal empty];
    }];
}

-(void)loadData
{
    _inventoryEditView.qrText.enabled = _unLock;
    NSString *itemWhere = [NSString stringWithFormat:@"salesOrderItemCode = '%@'",_itemSnapshotCode];
    _itemSnapshot = [ItemSnapshot searchSingleWithWhere:itemWhere orderBy:nil];
    
    _attachments = [NSMutableArray new];
    if(_itemSnapshot.attachments != nil){
        [_attachments addObjectsFromArray:_itemSnapshot.attachments];
    }

}

-(void)saveData{
    _itemSnapshot.code = _inventoryEditView.qrText.text;
    _itemSnapshot.remark = _inventoryEditView.remarkText.text;
    _itemSnapshot.name = _inventoryEditView.goodNameText.text;
    
    [_itemSnapshot updateToDB];
    if (self.doneBlock) {
        self.doneBlock(_itemSnapshot);
    }
}

+(instancetype)doneBlock:(void (^)(ItemSnapshot *))block{
    
    WorkOrderInventoryEditController *vc = [[WorkOrderInventoryEditController alloc] init];
    vc.doneBlock = block;
    return vc;
    
}

#pragma mark - IBAction
- (void)lockIconClick:(UITapGestureRecognizer *)recognizer
{
    _unLock = !_unLock;
    _inventoryEditView.lockIcon.text = _unLock ?  @"" :@"";
    _inventoryEditView.qrText.enabled = _unLock;
}

- (void)photoIconClick:(UITapGestureRecognizer *)recognizer
{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showOkayCancelAlert];
    } else {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = YES;
        imagePickerController.showsCameraControls = YES;
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }

}

- (void)showOkayCancelAlert {
    NSString *title = NSLocalizedString(@"提示", nil);
    NSString *message = NSLocalizedString(@"当前机器没有摄像头!", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"好的", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^ {
        Attachment *attachment = [Attachment new];
        attachment.key = [NSString stringWithFormat:@"%@.jpg",[[NSUUID UUID] UUIDString]];
        attachment.itemSnapShotId = _itemSnapshotCode;
        attachment.sort = 20;
        attachment.type = 10;
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        //当选择的类型是图片
        if ([type isEqualToString:@"public.image"])
        {
            UIImage *image = info[UIImagePickerControllerEditedImage];
            attachment.path = [Utils saveImage:image andName:attachment.key];
        }
        
        [_attachments addObject:attachment];
        _itemSnapshot.attachments = _attachments;
        [_itemSnapshot saveToDB];
        [_inventoryEditView.photoTableView reloadData];
    }];
    
    
}

#pragma mark -UICollectionViewDataSource

//指定单元格的个数 ，这个是一个组里面有多少单元格，e.g : 一个单元格就是一张图片
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _attachments.count;
}

//构建单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    Attachment *attachment = _attachments[indexPath.row];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:attachment.path];
    
    cell.image.image = image;
    return cell;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(96, 100);

}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell * cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [Utils showImage:cell.image.image];
    
}

-(void)handleQrCode:(NSString *)qrCode{
    _inventoryEditView.qrText.text = qrCode;
}

//返回按钮监听
- (BOOL)navigationShouldPopOnBackButton {
    if (true) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}
@end
