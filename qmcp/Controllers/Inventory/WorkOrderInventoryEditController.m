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
@interface WorkOrderInventoryEditController ()<UINavigationControllerDelegate,UICollectionViewDataSource,StandardsViewDelegate,
                                                UICollectionViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) WorkOrder *workOrder;
@property (nonatomic, strong) ItemSnapshot *itemSnapshot;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) WorkOrderInventoryEditView *inventoryEditView;
@property (nonatomic, strong) NSMutableArray *commodities;
@property (nonatomic, strong) NSString *chooseCommodityCode;
@property (nonatomic, strong) StandardsView *mystandardsView;
@property (nonatomic, assign) bool isChoose;
@property (nonatomic, strong) PropertyChoose *propertyChoose;
@property (nonatomic, strong) NSMutableArray<PropertyChoose *> *chooseCommodityArr;
@end

@implementation WorkOrderInventoryEditController

#pragma mark - BaseWorkOrderViewController
-(void)loadView
{
     _inventoryEditView = [WorkOrderInventoryEditView viewInstance];
    self.view = _inventoryEditView;
    self.title = @"清点编辑";
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(priceUpdate:) name:@"priceUpdate" object:nil];
}

-(void)bindListener
{
    _inventoryEditView.chooseTableView.delegate = self;
    _inventoryEditView.chooseTableView.dataSource = self;
    
    _inventoryEditView.photoTableView.delegate = self;
    _inventoryEditView.photoTableView.dataSource = self;
    
    _inventoryEditView.carIcon.userInteractionEnabled = YES;
    [_inventoryEditView.carIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(carIconClick:)]];
    
    _inventoryEditView.photoIcon.userInteractionEnabled = YES;
    [_inventoryEditView.photoIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoIconClick:)]];
}

-(void)loadData
{
    NSString *itemWhere = [NSString stringWithFormat:@"code = '%@'",super.workOrderStepCode];
    _itemSnapshot = [ItemSnapshot searchSingleWithWhere:itemWhere orderBy:nil];
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",super.workOrderCode];
   _workOrder = [WorkOrder searchSingleWithWhere:workWhere orderBy:nil];
    
    _attachments = [NSMutableArray new];
    if(_itemSnapshot.attachments != nil){
        [_attachments addObjectsFromArray:_itemSnapshot.attachments];
    }
    
    _commodities = [NSMutableArray new];
    if(_workOrder.commoditySnapshots != nil){
        [_commodities addObjectsFromArray:_workOrder.commoditySnapshots ];
        
    }
    
    _chooseCommodityArr = [NSMutableArray new];
    if(_itemSnapshot.commodities != nil){
        [_chooseCommodityArr addObjectsFromArray: _itemSnapshot.commodities];
    }
    _inventoryEditView.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_chooseCommodityArr.count];
}

-(void)saveData{
    _itemSnapshot.commodities = _chooseCommodityArr;
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

- (void)carIconClick:(UITapGestureRecognizer *)recognizer
{
    ChooseViewController *controller = [ChooseViewController new];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.chooseCommodityArr = _chooseCommodityArr;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        controller.providesPresentationContextTransitionStyle = YES;
        controller.definesPresentationContext = YES;
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.tabBarController presentViewController:controller animated:YES completion:nil];
        
    } else {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:controller animated:YES completion:nil];
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
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
        _itemSnapshot.attachments = _attachments;
        [_itemSnapshot saveToDB];
        [_inventoryEditView.photoTableView reloadData];
    }];
    
    
}

#pragma mark -UICollectionViewDataSource

//指定单元格的个数 ，这个是一个组里面有多少单元格，e.g : 一个单元格就是一张图片
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == _inventoryEditView.photoTableView){
        return _attachments.count;
    }else{
        return _commodities.count;
    }
}

//构建单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(collectionView == _inventoryEditView.photoTableView){
         static NSString *identify = @"cell";
        PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        Attachment *attachment = _attachments[indexPath.row];
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:attachment.path];
        
        cell.image.image = image;
        return cell;
    }else{
         static NSString *flag = @"commodityCell";
        CommodityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:flag forIndexPath:indexPath];
        CommoditySnapshot *commodity = _commodities[indexPath.row];
        cell.textView.text = commodity.commodityName;
        return cell;
    }
    
    
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView == _inventoryEditView.photoTableView){
        return CGSizeMake(96, 100);
    }else{
        return CGSizeMake(90, 90);
    }
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _inventoryEditView.photoTableView){
        PhotoCell * cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [Utils showImage:cell.image.image];
    }else{
        CommoditySnapshot *commodity = _commodities[indexPath.row];
        if([[PropertyManager getInstance] isExistProperty:commodity.commodityCode]){
            _chooseCommodityCode = commodity.commodityCode;
            _mystandardsView = [self buildStandardView:commodity.commodityCode];
            _mystandardsView.showAnimationType = StandsViewShowAnimationShowFrombelow;
            _mystandardsView.dismissAnimationType = StandsViewDismissAnimationDisFrombelow;
            [_mystandardsView show];
        }else{
            PropertyChoose *pc = [PropertyChoose new];
            pc.name = commodity.commodityName;
            pc.code = [[NSUUID UUID] UUIDString];
            pc.price = commodity.price;
            [_chooseCommodityArr addObject:pc];
            _inventoryEditView.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_chooseCommodityArr.count];
        }
    }
    
}

#pragma mark - Notification
- (void)priceUpdate:(NSNotification *)text{
    _isChoose = [text.userInfo[@"flag"] boolValue];
    if(_isChoose){
        NSString *price = text.userInfo[@"price"];
        NSString *itemProperties = text.userInfo[@"property"];
        _mystandardsView.priceLab.text = [NSString stringWithFormat:@"价格:%@", price];
        _mystandardsView.goodNum.text = [NSString stringWithFormat:@"%@", itemProperties];
        _propertyChoose = [PropertyChoose new];
        _propertyChoose.code = [[NSUUID UUID] UUIDString];
        _propertyChoose.itemProperties = itemProperties;
        _propertyChoose.price = [price floatValue];
    }else{
        _propertyChoose = nil;
        _mystandardsView.priceLab.text = @"";
        _mystandardsView.goodNum.text = @"";
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - standardView  delegate
//点击自定义按键
-(void)StandardsView:(StandardsView *)standardView CustomBtnClickAction:(UIButton *)sender
{
    if (sender.tag == 0) {
        if(_isChoose){
        //将商品图片抛到指定点
            [standardView ThrowGoodTo:CGPointMake(200, 100) andDuration:1.6 andHeight:150 andScale:20];
            [_chooseCommodityArr addObject:_propertyChoose];
            _inventoryEditView.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_chooseCommodityArr.count];
        }
    }
    else
    {
        [standardView dismiss];
    }
}

//点击规格代理
-(void)Standards:(StandardsView *)standardView SelectBtnClick:(UIButton *)sender andStandName:(NSString *)standName andStandandClassName:(NSString *)standClassName andIndex:(NSInteger)index
{
    int order = (int)index;
    NSArray *commodityPropertyArr =[[PropertyManager getInstance] appendCommodityChooseWithOrder:order andPropertyName:standName andPropertyContent:standClassName];
    NSMutableArray *titleArr = [NSMutableArray new];
    int i = 100;
    for (CommodityProperty *property in commodityPropertyArr) {
        NSMutableArray *tempClassInfoArr = [NSMutableArray new];
        for (NSString *str in property.propertyContent) {
            standardClassInfo *tempClassInfo1 = [standardClassInfo StandardClassInfoWith:[NSString stringWithFormat:@"%d",i ] andStandClassName:str];
            [tempClassInfoArr addObject:tempClassInfo1];
            i++;
        }
        StandardModel *tempModel = [StandardModel StandardModelWith:tempClassInfoArr andStandName:property.propertyName];
        [titleArr addObject:tempModel];
    }
    
    standardView.standardArr = titleArr;
    [standardView standardsViewReload];
    
}
//设置自定义btn的属性
-(void)StandardsView:(StandardsView *)standardView SetBtn:(UIButton *)btn
{
    if (btn.tag == 0) {
        btn.backgroundColor = [UIColor yellowColor];
    }
    else if (btn.tag == 1)
    {
        btn.backgroundColor = [UIColor orangeColor];
    }
}

-(StandardsView *)buildStandardView:(NSString *)commodityCode
{
    [[PropertyManager getInstance] releaseData];
    StandardsView *standview = [[StandardsView alloc] init];
    standview.delegate = self;
    standview.mainImgView.image = [UIImage imageNamed:@"intro_icon_0"];
    standview.mainImgView.backgroundColor = [UIColor whiteColor];
    standview.tipLab.text = @"请选择规格";
    [PropertyManager getInstance].currentCommodityCode = commodityCode;
    standview.customBtns = @[@"确定",@"取消"];
    NSArray *array = [[PropertyManager getInstance] getCommodityPropertyByCommodityCode:commodityCode];
    NSMutableArray *titleArr = [NSMutableArray new];
    int i = 100;
    for (CommodityProperty *property in array) {
        NSMutableArray *tempClassInfoArr = [NSMutableArray new];
        for (NSString *str in property.propertyContent) {
            standardClassInfo *tempClassInfo1 = [standardClassInfo StandardClassInfoWith:[NSString stringWithFormat:@"%d",i ] andStandClassName:str];
            [tempClassInfoArr addObject:tempClassInfo1];
            i++;
        }
        StandardModel *tempModel = [StandardModel StandardModelWith:tempClassInfoArr andStandName:property.propertyName];
        [titleArr addObject:tempModel];
    }
    
    standview.standardArr = titleArr;
    return standview;
}

@end