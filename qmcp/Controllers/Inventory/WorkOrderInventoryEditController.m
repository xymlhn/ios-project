
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
@interface WorkOrderInventoryEditController ()<UINavigationControllerDelegate,UICollectionViewDataSource,UITextFieldDelegate,
                                                UICollectionViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) ItemSnapshot *itemSnapshot;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) WorkOrderInventoryEditView *inventoryEditView;
@property (nonatomic, assign) BOOL unLock;
@property (nonatomic, assign) BOOL isDelete;




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
    _inventoryEditView.photoCollectionView.delegate = self;
    _inventoryEditView.photoCollectionView.dataSource = self;
    
    _inventoryEditView.qrText.delegate = self;
    _inventoryEditView.goodNameText.delegate = self;
    _inventoryEditView.remarkText.delegate = self;
    
    [_inventoryEditView.qrText addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_inventoryEditView.goodNameText addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_inventoryEditView.remarkText addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
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
    
    _inventoryEditView.qrText.text = _itemSnapshot.code;
    _inventoryEditView.remarkText.text = _itemSnapshot.remark;
    _inventoryEditView.goodNameText.text = _itemSnapshot.name;
    

}

-(void)saveData{
    _itemSnapshot.code = _inventoryEditView.qrText.text;
    _itemSnapshot.remark = _inventoryEditView.remarkText.text;
    _itemSnapshot.name = _inventoryEditView.goodNameText.text;
    
    [_itemSnapshot updateToDB];
    if (self.doneBlock) {
        self.doneBlock(_isDelete,_itemSnapshot);
    }
}

+(instancetype)doneBlock:(void (^)(BOOL ,ItemSnapshot *))block{
    
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
        [_inventoryEditView.photoCollectionView reloadData];
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

#pragma mark - 键盘操作

- (void)hidenKeyboard
{
    [_inventoryEditView.qrText resignFirstResponder];
    [_inventoryEditView.goodNameText resignFirstResponder];
    [_inventoryEditView.remarkText resignFirstResponder];
}

- (void)returnOnKeyboard:(UITextField *)sender
{
    if (sender == _inventoryEditView.qrText) {
        [_inventoryEditView.goodNameText becomeFirstResponder];
    } else if (sender == _inventoryEditView.goodNameText) {
        [_inventoryEditView.remarkText becomeFirstResponder];
    }else if(sender == _inventoryEditView.remarkText){
        [self hidenKeyboard];
    }
}


//返回按钮监听
- (BOOL)navigationShouldPopOnBackButton {
    if (true) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"二维码为空/还未拍照,是否放弃编辑?" preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [_itemSnapshot deleteToDB];
            _isDelete = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        
        [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return NO;
    }
    return YES;
}
@end
