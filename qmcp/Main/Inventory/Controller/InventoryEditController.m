
//
//  WorkOrderInventoryEditController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "InventoryEditController.h"
#import "WorkOrder.h"
#import "Attachment.h"
#import "ItemSnapshot.h"
#import "PhotoCell.h"
#import "InventoryEditView.h"
#import "InventoryView.h"
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
#import "InventoryChooseController.h"
#import "Helper.h"
#import "ImageViewerController.h"
@interface InventoryEditController ()<UINavigationControllerDelegate,UICollectionViewDataSource,UITextFieldDelegate,
UICollectionViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) ItemSnapshot *itemSnapshot;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) InventoryEditView *inventoryEditView;
@property (nonatomic, assign) BOOL unLock;

@end

@implementation InventoryEditController

#pragma mark - BaseWorkOrderViewController

+(instancetype)doneBlock:(void(^)(ItemSnapshot *item,SaveType type))block{
    
    InventoryEditController *vc = [[InventoryEditController alloc] init];
    vc.doneBlock = block;
    return vc;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)loadView{
    _inventoryEditView = [InventoryEditView viewInstance];
    self.view = _inventoryEditView;
    self.title = @"新增物品";
}

#pragma mark - BaseViewController
-(void)bindListener{
    _inventoryEditView.photoCollectionView.delegate = self;
    _inventoryEditView.photoCollectionView.dataSource = self;
    
    _inventoryEditView.qrText.delegate = self;
    _inventoryEditView.goodNameText.delegate = self;
    
    [_inventoryEditView.qrText addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_inventoryEditView.goodNameText addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];

    _inventoryEditView.addBtn.userInteractionEnabled = YES;
    [_inventoryEditView.addBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commodityViewClick:)]];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
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
    
    _inventoryEditView.saveBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        if([self p_beforeSaveHandle]){
            _saveType = SaveTypeUpdate;
            [self.navigationController popViewControllerAnimated:YES];
        }
        return [RACSignal empty];
    }];
    
    _inventoryEditView.delBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        _saveType = SaveTypeDelete;
        [self.navigationController popViewControllerAnimated:YES];
        [self p_doneSave];
        for (Attachment *attachment in _attachments) {
            [Utils deleteImage:attachment.key];
        }
        return [RACSignal empty];
    }];
    
    _inventoryEditView.lockBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        _unLock = !_unLock;
        _inventoryEditView.qrText.enabled = _unLock;
        return [RACSignal empty];
    }];
}

-(void)loadData{
    _inventoryEditView.qrText.enabled = _unLock;
    NSString *itemWhere = [NSString stringWithFormat:@"itemSnapshotCode = '%@'",_itemSnapshotCode];
    _itemSnapshot = [ItemSnapshot searchSingleWithWhere:itemWhere orderBy:nil];
    
    _attachments = [NSMutableArray new];
    if(_itemSnapshot.attachments != nil){
        [_attachments addObjectsFromArray:_itemSnapshot.attachments];
    }
    
    _inventoryEditView.qrText.text = _itemSnapshot.code;
    _inventoryEditView.remarkText.text = _itemSnapshot.remark;
    _inventoryEditView.goodNameText.text = _itemSnapshot.name;
    _inventoryEditView.commodityLabel.text = [NSString stringWithFormat:@"已选服务 %lu 项",_itemSnapshot.commodities == nil? 0 : _itemSnapshot.commodities.count];
    [_inventoryEditView.delBtn setTitle:_saveType == SaveTypeAdd?@"取消":@"删除" forState:UIControlStateNormal];
}

#pragma mark - func
/**
 返回上一个界面处理
 */
-(void)p_doneSave{
    if (self.doneBlock) {
        switch (_saveType) {
            case SaveTypeAdd:
            case SaveTypeUpdate:
                _itemSnapshot.code = _inventoryEditView.qrText.text;
                _itemSnapshot.remark = _inventoryEditView.remarkText.text;
                _itemSnapshot.name = _inventoryEditView.goodNameText.text;

                if([_itemSnapshot updateToDB]){
                    self.doneBlock(_itemSnapshot,SaveTypeUpdate);
                }
                break;
            case SaveTypeDelete:
                if ([_itemSnapshot deleteToDB]) {
                    self.doneBlock(_itemSnapshot,SaveTypeDelete);
                }
                
                break;
            default:
                break;
        }
        
    }
}

//保存附件节点
-(void)p_updateStep{
    _itemSnapshot.attachments = _attachments;
    [_itemSnapshot updateToDB];
}


-(void)handleQrCode:(NSString *)qrCode{
    _inventoryEditView.qrText.text = qrCode;
}

/**
 保存前提示处理
 
 @return bool
 */
-(BOOL)p_beforeSaveHandle{
    if(_unLock){
        [Utils showHudTipStr:@"请将二维码锁上保存"];
        return NO;
    }
    if ([_inventoryEditView.qrText.text isEqualToString:@""] || _attachments.count == 0) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"二维码为空/还未拍照,是否放弃编辑?" preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            _saveType = SaveTypeDelete;
            [self.navigationController popViewControllerAnimated:YES];
            [self p_doneSave];
        }]];
        
        [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
        return NO;
    }else{
        [self p_doneSave];
        return YES;
    }
}

#pragma mark - IBAction
- (void)commodityViewClick:(UITapGestureRecognizer *)recognizer{
    __weak typeof(self) weakSelf = self;
    InventoryChooseController *info = [InventoryChooseController doneBlock:^(NSMutableArray *commodies,float price) {
        weakSelf.itemSnapshot.commodities = commodies;
        weakSelf.itemSnapshot.price = price;
        weakSelf.inventoryEditView.commodityLabel.text = [NSString stringWithFormat:@"已选服务 %lu 项",_itemSnapshot.commodities == nil? 0 : _itemSnapshot.commodities.count];
    }];
    info.itemSnapshotCode = _itemSnapshot.itemSnapshotCode;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
    
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^ {
        Attachment *attachment = [Attachment new];
        attachment.key = [NSString stringWithFormat:@"%@.jpg",[[NSUUID UUID] UUIDString]];
        attachment.itemSnapShotId = _itemSnapshotCode;
        attachment.sort = 20;
        attachment.type = 10;
        UIImage *image = [Utils imageCompressForWidth:info[UIImagePickerControllerOriginalImage] targetWidth:500];
        [Utils saveImage:image andName:attachment.key];
        [_attachments insertObject:attachment atIndex:0];
        [self p_updateStep];
        [_inventoryEditView.photoCollectionView reloadData];
    }];
    
    
}

#pragma mark -UICollectionViewDataSource

//指定单元格的个数 ，这个是一个组里面有多少单元格，e.g : 一个单元格就是一张图片
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _attachments.count == 6 ? _attachments.count : _attachments.count + 1;
}

//构建单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"PhotoCell";
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    if (_attachments.count == kMaxImage || indexPath.row < _attachments.count) {
        Attachment *attachment = _attachments[indexPath.row];
        cell.image.image = [Utils loadImage:attachment.key];
    }else{
        cell.image.image = [UIImage imageNamed:@"plus_photo.png"];
    }
    return cell;
    
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (_attachments.count == kMaxImage || indexPath.row < _attachments.count) {
        Attachment *attachment = _attachments[indexPath.row];
        ImageViewerController *ivc = [ImageViewerController initWithImageKey:attachment.key isHide:NO doneBlock:^(NSString *textValue) {
            [Utils deleteImage:attachment.key];
            [attachment deleteToDB];
            [weakSelf.attachments removeObject:attachment];
            [weakSelf p_updateStep];
            [_inventoryEditView.photoCollectionView reloadData];
        }];
        [self presentViewController:ivc animated:YES completion:nil];
    }else{
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"添加图片"                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            if (![Helper checkCameraAuthorizationStatus]) {
                return;
            }
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }]];
        [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            if (![Helper checkPhotoLibraryAuthorizationStatus]) {
                return;
            }
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:picker animated:YES completion:nil];
        }]];
        [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            [self presentViewController: alertController animated:YES completion: nil];
        } else {
            UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
            popPresenter.sourceView = _inventoryEditView.photoCollectionView;
            popPresenter.sourceRect = _inventoryEditView.photoCollectionView.bounds;
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}


#pragma mark - 键盘操作

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (![_inventoryEditView.qrText isFirstResponder] &&
        ![_inventoryEditView.goodNameText isFirstResponder] &&
        ![_inventoryEditView.remarkText isFirstResponder]) {
        return NO;
    }
    return YES;
}

- (void)hidenKeyboard{
    [_inventoryEditView.qrText resignFirstResponder];
    [_inventoryEditView.goodNameText resignFirstResponder];
    [_inventoryEditView.remarkText resignFirstResponder];
}

- (void)returnOnKeyboard:(UITextField *)sender{
    if (sender == _inventoryEditView.qrText) {
        [_inventoryEditView.goodNameText becomeFirstResponder];
    } else if (sender == _inventoryEditView.goodNameText) {
        [_inventoryEditView.remarkText becomeFirstResponder];
    }
}

//返回按钮监听
- (BOOL)navigationShouldPopOnBackButton {
    return [self p_beforeSaveHandle];
}
@end
