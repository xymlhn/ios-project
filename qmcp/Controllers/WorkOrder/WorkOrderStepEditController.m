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
@interface WorkOrderStepEditController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,
                                            UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) WorkOrderStep *step;
@property (nonatomic, strong) WorkOrder *workOrder;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) WorkOrderStepEditView *editView;
@property (nonatomic, strong)NSMutableArray *dataArray;//数据
@property (nonatomic, strong) Attachment *plusIcon;


@end

@implementation WorkOrderStepEditController

#pragma mark - BaseWorkOrderViewController
-(void)loadView
{
    _editView =[WorkOrderStepEditView viewInstance];
    self.view = _editView;
    self.title = @"步骤编辑";
}

-(void)loadData
{
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",super.workOrderCode];
    _workOrder = [WorkOrder searchSingleWithWhere:workWhere orderBy:nil];
    NSString *stepWhere = [NSString stringWithFormat:@"id = '%@'",super.workOrderStepCode];
    _step = [WorkOrderStep searchSingleWithWhere:stepWhere orderBy:nil];

    _attachments = [NSMutableArray new];
    
    [_attachments addObjectsFromArray:_step.attachments];
    if(_attachments.count < 6){
        _plusIcon = [Attachment new];
        _plusIcon.isPlus = true;
        [_attachments insertObject:_plusIcon atIndex:_attachments.count];
    }
    _editView.editText.text = _step.content;

    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (CommoditySnapshot *snapshot in _workOrder.salesOrderCommoditySnapshots) {
        [dict setObject:snapshot.commodityName forKey:snapshot.commodityCode];
    }
    _dataArray = [[WorkOrderManager getInstance] getCommodityByCommodityCode:dict];
    
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

-(void)deleteAttachment:(Attachment *)attachment
{
     NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:attachment.path]){
        NSError *error;
        if ([fileManager removeItemAtPath:attachment.path error: & error] != YES){
            NSLog(@"删除附件失败!");
        }
    }
    [attachment deleteToDB];
}

-(void)saveData
{
    
    if (self.doneBlock) {
    
        switch ([super type]) {
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
    [_step updateToDB];
    if(_attachments.count < 6){
        [_attachments insertObject:_plusIcon atIndex:_attachments.count];
    }
}

#pragma mark - IBAction
- (void)postWorkOrderStep
{
    NSString *where = [NSString stringWithFormat:@"workOrderCode = '%@'",super.workOrderCode];
    NSArray *steps = [WorkOrderStep searchWithWhere:where];
    [self postWorkOrderStepWithWorkOrder:_workOrder andStepsArray:steps];
}
- (void)postWorkOrderStepWithWorkOrder:(WorkOrder *)workOrder andStepsArray:(NSArray *)steps{
    
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在上传工单步骤";
    hub.userInteractionEnabled = NO;
    NSDictionary *stepDict = @{@"steps":[WorkOrderStep mj_keyValuesArrayWithObjectArray:steps]};
    NSDictionary *dict = @{@"code":workOrder.code,@"status":[NSNumber numberWithInteger:workOrder.status],@"processDetail":stepDict};

    [[WorkOrderManager getInstance] postWorkOrderStepWithCode:workOrder.code andParams:dict finishBlock:^(NSDictionary *dict, NSString *error) {
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
- (void)plusBtnClick{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"添加图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet showInView:self.view];
}

- (void)delBtnClick:(UITapGestureRecognizer *)recognizer{

    if([_step deleteToDB]){
        for (Attachment *attachment in _attachments) {
            if(!attachment.isPlus)
                [self deleteAttachment:attachment];
        }
        [self.navigationController popViewControllerAnimated:YES];
        super.type = SaveTypeDelete;
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
        attachment.workOrderStepCode = [super workOrderStepCode];
        attachment.sort = 20;
        attachment.type = 10;
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        //当选择的类型是图片
        if ([type isEqualToString:@"public.image"])
        {
            UIImage *image = [Utils scaleToSize:info[UIImagePickerControllerEditedImage] size:CGSizeMake(320.0f, 480.0f)];
            attachment.path = [Utils saveImage:image andName:attachment.key];
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
    PhotoCell * cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    Attachment *attachment = _attachments[indexPath.row];
    if(attachment.isPlus){
        [self plusBtnClick];
    }else{
        ImageViewerController *imgViewweVC = [[ImageViewerController alloc] initWithImage:cell.image.image];
        [self presentViewController:imgViewweVC animated:YES completion:nil];
    }
    
}

#pragma mark - 键盘操作
- (void)hidenKeyboard
{
    [_editView.editText resignFirstResponder];
}




@end
