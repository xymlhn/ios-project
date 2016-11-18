//
//  WorkOrderFormsController.m
//  qmcp
//
//  Created by 谢永明 on 16/6/12.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderFormsController.h"
#import "FormTemplateBrife.h"
#import "FormManager.h"
#import "FormTemplateCell.h"
#import "WorkOrderFormController.h"
#import "AbstractActionSheetPicker.h"
#import "ActionSheetPicker.h"

@interface WorkOrderFormsController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<FormTemplateBrife *> * workOrderFormList;
@end

@implementation WorkOrderFormsController

#pragma mark - UIViewController

-(void)setupView
{
    self.title = @"表单";
    self.view.backgroundColor = [UIColor whiteColor];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = (kScreen_Width - 12 * 3) / 2;
    CGFloat itemH = itemW * (175.0/284.0) + 10 +21 +5 +13 +5;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.sectionInset = UIEdgeInsetsMake(20, 12, 20, 12);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 20;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[FormTemplateCell class] forCellWithReuseIdentifier:@"FormTemplateCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.layer.masksToBounds = NO;
    [self.view addSubview:_collectionView];
    
}

-(void)loadData
{

    _workOrderFormList = [NSMutableArray new];
    
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在获取表单数据";
    hub.userInteractionEnabled = NO;
    [[FormManager getInstance] getFormTemplateAndFormData:_code finishBlock:^(NSMutableArray *arr, NSString *error) {
        if (error == nil) {
            
            _workOrderFormList = arr;
            NSString *success;
            if(_workOrderFormList.count == 0){
                success = @"当前工单暂无表单";
            }else{
                success = @"获取表单数据成功";
                [_collectionView reloadData];
            }
            hub.labelText = success;
            [hub hide:YES afterDelay:0.2];
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:1];
        }
    }];
    
}

-(void)bindListener{
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

#pragma mark -UICollectionViewDataSource

//指定单元格的个数 ，这个是一个组里面有多少单元格，e.g : 一个单元格就是一张图片
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _workOrderFormList.count;
}

//构建单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"FormTemplateCell";
    FormTemplateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.formTemplateBrife = _workOrderFormList[indexPath.row];
    return cell;
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FormTemplateBrife *formTemplateBrife = _workOrderFormList[indexPath.row];
    WorkOrderFormController *info =[WorkOrderFormController new];
    info.code = _code;
    info.formTemplateId = formTemplateBrife.formTemplateCode;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}



@end
