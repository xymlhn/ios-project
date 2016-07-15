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
#import "Utils.h"

@interface WorkOrderFormsController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;;
@property (nonatomic, copy) WorkOrder *workOrder;
@property (nonatomic, strong) NSMutableArray<FormTemplateBrife *> * workOrderFormList;
@end

@implementation WorkOrderFormsController

#pragma mark - UIViewController

-(void)initView
{
    self.title = @"表单";
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *containView = [UIView new];
    [containView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    //创建布局对象
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    //flowlaout的属性，横向滑动
    flowLayout1.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout1];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[FormTemplateCell class] forCellWithReuseIdentifier:@"FormTemplateCell"];
    [containView addSubview:_collectionView];

    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(containView.mas_top).with.offset(10);
        make.left.equalTo(containView.mas_left).with.offset(5);
        make.right.equalTo(containView.mas_right).with.offset(-5);
        make.bottom.equalTo(containView.mas_bottom);
    }];
    
    
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

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0,0, 0);
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150, 120);
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
