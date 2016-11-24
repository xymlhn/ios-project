//
//  WorkOrderStepEditController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/2.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderStepEditController.h"
#import "QuartzCore/QuartzCore.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Attachment.h"
#import "WorkOrderManager.h"
#import "AppManager.h"
#import "WorkOrderStepEditView.h"
#import "PhotoCell.h"
#import "ImageViewerController.h"
#import "CommodityStepController.h"
#import "CommoditySnapshot.h"
#import "Helper.h"
#import "SalesOrder.h"
@interface WorkOrderStepEditController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,
                                            UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) WorkOrderStep *step;
@property (nonatomic, strong) WorkOrder *workOrder;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) WorkOrderStepEditView *editView;
@property (nonatomic, strong) NSMutableArray *dataArray;//数据
@property (nonatomic, strong) Attachment *plusIcon;
@property (nonatomic, strong) SalesOrder *salesOrder;

@end

@implementation WorkOrderStepEditController

#pragma mark - BaseWorkOrderViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
-(void)loadView
{
    _editView =[WorkOrderStepEditView viewInstance];
    self.view = _editView;
    self.title = @"步骤编辑";
}

-(void)loadData
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if(_funcType == FuncTypeWorkOrder){
        NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",_code];
        _workOrder = [WorkOrder searchSingleWithWhere:workWhere orderBy:nil];
        for (CommoditySnapshot *snapshot in _workOrder.salesOrderCommoditySnapshots) {
            [dict setObject:snapshot.commodityName forKey:snapshot.commodityCode];
        }
        
    }else{
        NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",_code];
        _salesOrder = [SalesOrder searchSingleWithWhere:workWhere orderBy:nil];
        for (CommoditySnapshot *snapshot in _salesOrder.salesOrderCommoditySnapshots) {
            [dict setObject:snapshot.commodityName forKey:snapshot.commodityCode];
        }
    }
    _dataArray = [[WorkOrderManager getInstance] getCommodityByCommodityCode:dict];
    NSString *stepWhere = [NSString stringWithFormat:@"id = '%@'",_stepCode];
    _step = [WorkOrderStep searchSingleWithWhere:stepWhere orderBy:nil];

    _attachments = [NSMutableArray new];
    
    [_attachments addObjectsFromArray:_step.attachments];
    if(_attachments.count < 6){
        _plusIcon = [Attachment new];
        _plusIcon.isPlus = true;
        [_attachments insertObject:_plusIcon atIndex:_attachments.count];
    }
    _editView.editText.text = _step.content;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ 
        [self hidenKeyboard];
        return NO;
    }
    return YES;
}

-(void)bindListener
{
    _editView.delBtn.userInteractionEnabled = YES;
    [_editView.delBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delBtnClick:)]];
    
    _editView.saveBtn.userInteractionEnabled = YES;
    [_editView.saveBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveBtnClick:)]];
    
    _editView.collectionView.delegate = self;
    _editView.collectionView.dataSource = self;
    _editView.editText.delegate = self;
    
    _editView.fastView.userInteractionEnabled = YES;
    [_editView.fastView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fastViewClick:)]];
    
}

+(instancetype)doneBlock:(void (^)(WorkOrderStep *,SaveType type))block{
    
    WorkOrderStepEditController *vc = [[WorkOrderStepEditController alloc] init];
    vc.doneBlock = block;
    return vc;
    
}

-(void)p_deleteAttachment:(Attachment *)attachment
{
    [Utils deleteImage:attachment.key];
    [attachment deleteToDB];
    [_attachments removeObject:attachment];
    _step.attachments = _attachments;
    [_step updateToDB];
}


/**
 退出界面处理
 */
-(void)p_doneSave{
    if (self.doneBlock) {
        switch (_type) {
            case SaveTypeAdd:
                _step.content = _editView.editText.text;
                if([_step updateToDB]){
                    self.doneBlock(_step,SaveTypeAdd);
                }
                break;
            case SaveTypeUpdate:
                _step.content = _editView.editText.text;
                if([_step updateToDB]){
                    self.doneBlock(_step,SaveTypeUpdate);
                }
                break;
            case SaveTypeDelete:
                self.doneBlock(_step,SaveTypeDelete);
                break;
            default:
                break;
        }
        
    }
}
-(void)updateStep{
    
    [_attachments removeObject:_plusIcon];
    _step.attachments = _attachments;
    _step.content = _editView.editText.text;
    [_step updateToDB];
    if(_attachments.count < 6){
        [_attachments insertObject:_plusIcon atIndex:_attachments.count];
    }
}

#pragma mark - IBAction
- (void)saveBtnClick:(UITapGestureRecognizer *)recognizer
{
    [self updateStep];
    if(_funcType == FuncTypeWorkOrder){
        NSString *where = [NSString stringWithFormat:@"workOrderCode = '%@'",_code];
        NSArray *steps = [WorkOrderStep searchWithWhere:where];
        [self p_postWorkOrderStepWithWorkOrder:_workOrder andStepsArray:steps];
    }else{
        NSString *where = [NSString stringWithFormat:@"salesOrderCode = '%@'",_code];
        NSArray *steps = [WorkOrderStep searchWithWhere:where];
        [self p_postInfo:steps];
    }
}
- (void)p_postInfo:(NSArray *)steps{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hub.detailsLabel.text = @"正在上传步骤";
    NSMutableArray *arrayM = [WorkOrderStep mj_keyValuesArrayWithObjectArray:steps];
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_POSTSALESORDERSTEP,_code];
    [HttpUtil post:URLString param:arrayM finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            NSMutableArray *attachments = [NSMutableArray new];
            for (WorkOrderStep *step in steps) {
                for(Attachment *attachment in step.attachments)
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
                    hub.detailsLabel.text = [NSString stringWithFormat:@"正在上传附件"];
                    [[WorkOrderManager getInstance] postAttachment:attachment finishBlock:^(NSDictionary *obj,NSString *error) {
                        if (!error) {
                            attachment.isUpload = YES;
                            [attachment saveToDB];
                            if(i == attachments.count){
                                hub.detailsLabel.text = [NSString stringWithFormat:@"上传工单附件成功"];
                                hub.mode = MBProgressHUDModeCustomView;
                                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                                [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                                [weakSelf p_doneSave];
                            }
                        }else{
                            hub.mode = MBProgressHUDModeCustomView;
                            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                            hub.detailsLabel.text = error;
                            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
                        }
                    }];
                }
            }else
            {
                hub.detailsLabel.text = [NSString stringWithFormat:@"上传步骤成功"];
                [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [weakSelf p_doneSave];
            }
        }else{
            
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
            
        }
        
    }];
    
}

- (void)p_postWorkOrderStepWithWorkOrder:(WorkOrder *)workOrder andStepsArray:(NSArray *)steps{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hub.detailsLabel.text = @"正在上传工单步骤";
    NSMutableArray *arrayM = [WorkOrderStep mj_keyValuesArrayWithObjectArray:steps];
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_POSTWORKORDERSTEP,_code];
    [HttpUtil post:URLString param:arrayM finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            NSMutableArray *attachments = [NSMutableArray new];
            for (WorkOrderStep *step in steps) {
                for(Attachment *attachment in step.attachments) {
                    if(!attachment.isUpload){
                        [attachments addObject:attachment];
                    }
                }
            }
            if(attachments.count > 0){
                int i= 0;
                for(Attachment *attachment in attachments){
                    i++;
                    hub.detailsLabel.text = [NSString stringWithFormat:@"正在上传附件"];
                    [[WorkOrderManager getInstance] postAttachment:attachment finishBlock:^(NSDictionary *obj,NSString *error) {
                        if (!error) {
                            attachment.isUpload = YES;
                            [attachment updateToDB];
                            if(i == attachments.count){
                                hub.detailsLabel.text = [NSString stringWithFormat:@"上传工单附件成功"];
                                hub.mode = MBProgressHUDModeCustomView;
                                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                                [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                                [weakSelf p_doneSave];
                            }
                        }else{
                            hub.mode = MBProgressHUDModeCustomView;
                            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                            hub.detailsLabel.text = error;
                            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
                        }
                    }];
                }
            }else{
                hub.detailsLabel.text = [NSString stringWithFormat:@"上传工单步骤成功"];
                [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [weakSelf p_doneSave];
            }
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
        
    }];

}
- (void)plusBtnClick{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)delBtnClick:(UITapGestureRecognizer *)recognizer{

    if([_step deleteToDB]){
        for (Attachment *attachment in _attachments) {
            if(!attachment.isPlus)
                [self p_deleteAttachment:attachment];
        }
        [self.navigationController popViewControllerAnimated:YES];
        _type = SaveTypeDelete;
        [self p_doneSave];
    }
}

- (void)fastViewClick:(UITapGestureRecognizer *)recognizer{
    if(_dataArray.count == 0){
        kTipAlert(@"无快速描述");
        return;
    }
    CommodityStepController *controller = [CommodityStepController doneBlock:^(NSString *textValue) {
        _editView.editText.text = textValue;
    }];
    controller.dataArray = _dataArray;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        controller.providesPresentationContextTransitionStyle = YES;
        controller.definesPresentationContext = YES;
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.tabBarController presentViewController:controller animated:YES completion:nil];
        
    } else {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:controller animated:NO completion:nil];
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}

#pragma mark UIActionSheetDelegate M
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    
    if (buttonIndex == 0) {
        //        拍照
        if (![Helper checkCameraAuthorizationStatus]) {
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (buttonIndex == 1){
        //        相册
        if (![Helper checkPhotoLibraryAuthorizationStatus]) {
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^ {
        Attachment *attachment = [Attachment new];
        attachment.key = [NSString stringWithFormat:@"%@.jpg",[[NSUUID UUID] UUIDString]];
        attachment.workOrderStepCode = _stepCode;
        attachment.sort = 20;
        attachment.type = 10;
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        //当选择的类型是图片
        if ([type isEqualToString:@"public.image"])
        {
            UIImage *image = [Utils scaleToSize:info[UIImagePickerControllerEditedImage] size:CGSizeMake(320.0f, 480.0f)];
            [Utils saveImage:image andName:attachment.key];
        }
        [_attachments insertObject:attachment atIndex:0];
        [self updateStep];
        [_editView.collectionView reloadData];
    }];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    static NSString *identify = @"PhotoCell";
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    Attachment *attachment = _attachments[indexPath.row];
    if(attachment.isPlus){
        UIImage *image = [UIImage imageNamed:@"plus_photo.png"];
        cell.image.image = image;
    }else{
        UIImage *image = [Utils loadImage:attachment.key];
        cell.image.image = image;
    }
    
    return cell;
    
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Attachment *attachment = _attachments[indexPath.row];
    if(attachment.isPlus){
        [self plusBtnClick];
    }else{
        ImageViewerController *ivc = [ImageViewerController initWithImageKey:attachment.key doneBlock:^(NSString *textValue) {
            [self p_deleteAttachment:attachment];
            [_editView.collectionView reloadData];
        }];
        [self presentViewController:ivc animated:YES completion:nil];
    }
    
}

#pragma mark - 键盘操作
- (void)hidenKeyboard
{
    [_editView.editText resignFirstResponder];
}

//返回按钮监听
- (BOOL)navigationShouldPopOnBackButton {
    [self p_doneSave];
    return YES;
}


@end
