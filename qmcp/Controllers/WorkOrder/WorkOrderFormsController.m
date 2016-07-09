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

@interface WorkOrderFormsController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;;
@property (nonatomic, copy) WorkOrder *workOrder;
@property (nonatomic, strong) NSMutableArray<FormTemplateBrife *> * workOrderFormList;
@end

@implementation WorkOrderFormsController

#pragma mark - UIViewController

-(void)initView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.estimatedItemSize = CGSizeMake(80, 50);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.center.y, self.view.frame.size.width, self.view.frame.size.height/15) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor yellowColor];
    [_collectionView registerClass:[FormTemplateCell class] forCellWithReuseIdentifier:@"FormTemplateCell"];
    
    
}

-(void)loadData
{
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",super.workOrderCode];
    _workOrder = [WorkOrder searchSingleWithWhere:workWhere orderBy:nil];
    _workOrderFormList = [NSMutableArray new];
    
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在获取表单数据";
    hub.userInteractionEnabled = NO;
    [[FormManager getInstance] getFormTemplateAndFormData:_workOrder.salesOrderSnapshot.code finishBlock:^(NSMutableArray *arr, NSString *error) {
        if (error == nil) {
            
            _workOrderFormList = arr;
            if(_workOrderFormList.count == 0){
                
            }else{
                [_collectionView reloadData];
            }
            hub.labelText = [NSString stringWithFormat:@"获取表单数据成功"];
            [hub hide:YES afterDelay:0.5];
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:1];
        }
    }];
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
    

    static NSString *identify = @"cell";
    FormTemplateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.formTemplateBrife = _workOrderFormList[indexPath.row];
    return cell;

    
    
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeZero;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FormTemplateBrife *formTemplateBrife = _workOrderFormList[indexPath.row];
    WorkOrderFormController *info =[WorkOrderFormController new];
    info.workOrderCode = [super workOrderCode];
    info.formTemplateId = formTemplateBrife.formTemplateCode;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
    
}



@end
