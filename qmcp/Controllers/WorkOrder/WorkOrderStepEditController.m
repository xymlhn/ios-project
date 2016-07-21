//
//  WorkOrderStepEditController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/2.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderStepEditController.h"
#import "QuartzCore/QuartzCore.h"
#import "UIColor+Util.h"
#import "NSObject+LKDBHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Attachment.h"
#import "Utils.h"
#import "WorkOrderManager.h"
#import "AppManager.h"
#import "WorkOrderStepEditView.h"
#import "PhotoCell.h"
@interface WorkOrderStepEditController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,
                                            UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) WorkOrderStep *step;
@property (nonatomic, strong) WorkOrder *workOrder;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) WorkOrderStepEditView *editView;

@end

@implementation WorkOrderStepEditController

#pragma mark - BaseWorkOrderViewController
-(void)initView
{
    _editView =[WorkOrderStepEditView workOrderStepEditViewInstance:self.view];
    self.title = @"步骤编辑";
}

-(void)loadData
{
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",super.workOrderCode];
    _workOrder = [WorkOrder searchSingleWithWhere:workWhere orderBy:nil];
    NSString *stepWhere = [NSString stringWithFormat:@"id = '%@'",super.workOrderStepCode];
    _step = [WorkOrderStep searchSingleWithWhere:stepWhere orderBy:nil];

    _attachments = [NSMutableArray new];
    if(_step.attachments.count > 0)
    {
        [_attachments addObjectsFromArray:_step.attachments];
    }
    _editView.titleText.text = _step.stepName;
    _editView.editText.text = _step.content;
    
}

-(void)bindListener
{
    _editView.photoBtn.userInteractionEnabled = YES;
    [_editView.photoBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoBtnClick:)]];
    _editView.delBtn.userInteractionEnabled = YES;
    [_editView.delBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delBtnClick:)]];
    _editView.collectionView.delegate = self;
    _editView.collectionView.dataSource = self;
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
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
                                [hub hide:YES afterDelay:1];
                            }
                        }else{
                            NSString *message = @"";
                            if(obj == nil){
                                message =@"上传工单附件失败,请重试";
                            }else{
                                message = [obj valueForKey:@"message"];
                            }
                            hub.mode = MBProgressHUDModeCustomView;
                            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                            hub.labelText = message;
                            [hub hide:YES afterDelay:1];
                        }
                    }];
                }
            }else
            {
                hub.labelText = [NSString stringWithFormat:@"上传工单步骤成功"];
                [hub hide:YES afterDelay:1];
            }
        }else{
            
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:1];
            
        }

    }];
    
}
- (void)photoBtnClick:(UITapGestureRecognizer *)recognizer
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

- (void)delBtnClick:(UITapGestureRecognizer *)recognizer
{
    if([_step deleteToDB]){
        for (Attachment *attachment in _attachments) {
            [self deleteAttachment:attachment];
        }
        [self.navigationController popViewControllerAnimated:YES];
        super.type = SaveTypeDelete;
    }
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
            UIImage *image = info[UIImagePickerControllerEditedImage];
            attachment.path = [Utils saveImage:image andName:attachment.key];
        }
        
        [_attachments addObject:attachment];
        _step.attachments = _attachments;
        [_step saveToDB];
        [_editView.collectionView reloadData];
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

#pragma mark - 键盘操作
- (void)hidenKeyboard
{
    [_editView.editText resignFirstResponder];
}




@end
