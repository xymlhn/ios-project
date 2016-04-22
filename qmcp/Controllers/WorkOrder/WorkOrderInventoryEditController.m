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
#import "Utils.h"
#import "WorkOrderInventoryEditView.h"
#import "WorkOrderInventoryView.h"
#import "CommodityCell.h"
#import "Commodity.h"
#import "LewPopupViewController.h"
#import "CommodityTableView.h"
#import "SettingViewCell.h"
#import "Config.h"

@interface WorkOrderInventoryEditController ()<UIImagePickerControllerDelegate,UICollectionViewDataSource,
                                                UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) WorkOrder *workOrder;
@property (nonatomic, strong) ItemSnapshot *itemSnapshot;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) WorkOrderInventoryEditView *inventoryEditView;

@property (nonatomic, strong) NSMutableArray *commodities;
@property (nonatomic, strong) CommodityTableView *pop;

@property(nonatomic,strong)NSArray *switchArr;
@property (nonatomic, copy) NSArray *contentArr;

@end

@implementation WorkOrderInventoryEditController

-(void)initView
{
     _inventoryEditView = [WorkOrderInventoryEditView new];
    [_inventoryEditView initView:self.view];
    _pop = [CommodityTableView defaultPopupView];
    _pop.tableView.delegate = self;
    _pop.tableView.dataSource = self;
}

-(void)bindListener
{
    _inventoryEditView.chooseTableView.delegate = self;
    _inventoryEditView.chooseTableView.dataSource = self;
    
    _inventoryEditView.photoTableView.delegate = self;
    _inventoryEditView.photoTableView.dataSource = self;
    
    _inventoryEditView.carIcon.userInteractionEnabled = YES;
    [_inventoryEditView.carIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(carIconClick:)]];
}

-(void)loadData
{
    NSString *itemWhere = [NSString stringWithFormat:@"code = '%@'",super.workOrderStepCode];
    _itemSnapshot = [ItemSnapshot searchSingleWithWhere:itemWhere orderBy:nil];
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",super.workOrderCode];
   _workOrder = [WorkOrder searchSingleWithWhere:workWhere orderBy:nil];
    if(_itemSnapshot.attachments != nil){
        _attachments = _itemSnapshot.attachments;
    }else{
        _attachments = [NSMutableArray new];
    }
    
    if(_workOrder.commoditySnapshots != nil){
        _commodities = _workOrder.commoditySnapshots;
        
    }else{
        _commodities = [NSMutableArray new];
    }
    
    _switchArr = @[[NSNumber numberWithBool:[Config getSound]],[NSNumber numberWithBool:[Config getVibre]]
                   ,[NSNumber numberWithBool:[Config getQuickScan]]];
    
    _contentArr = @[@"声音",@"震动",@"快速扫描"];
}

- (void)carIconClick:(UITapGestureRecognizer *)recognizer
{
    
    LewPopupViewAnimationSlide *animation = [[LewPopupViewAnimationSlide alloc]init];
    animation.type = LewPopupViewAnimationSlideTypeBottomBottom;
    [self lew_presentPopupView:_pop animation:animation dismissed:^{
        NSLog(@"动画结束");
    }];
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingViewCell *cell = [SettingViewCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    NSInteger row = indexPath.row;
    [cell initSetting:[_switchArr[row] boolValue] andText:_contentArr[row]];
    cell.jsSwitch.tag = row;
    [cell.jsSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    return cell;
}
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    NSUInteger tag = switchButton.tag;
    switch (tag) {
        case 0:
            [Config setSound:switchButton.on];
            break;
        case 1:
            [Config setVibre:switchButton.on];
            break;
        case 2:
            [Config setQuickScan:switchButton.on];
            break;
        default:
            break;
    }
}\

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
    }
    
}


@end
