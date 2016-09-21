//
//  InventoryChooseController.m
//  qmcp
//
//  Created by 谢永明 on 16/8/29.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "InventoryChooseController.h"
#import "InventoryChooseView.h"
#import "ItemSnapshot.h"
#import "InventoryChooseCell.h"
#import "PropertyManager.h"
#import "StandardsView.h"
#import "CommodityProperty.h"

@interface InventoryChooseController ()<UITableViewDelegate,UITableViewDataSource,StandardsViewDelegate>

@property (nonatomic,strong) InventoryChooseView *inventoryChooseView;
@property (nonatomic,strong) ItemSnapshot *itemSnapshot;
@property (nonatomic, strong) NSArray *commodityList;
@property (nonatomic,strong) NSMutableArray<CommoditySnapshot *> *chooseCommodityList;
@property (nonatomic, strong) CommoditySnapshot *currentCommoditySnapshot;
@property (nonatomic, assign) BOOL isChoose;




@property (nonatomic, strong) StandardsView *standardsView;

@end

@implementation InventoryChooseController

#pragma mark - BaseWorkOrderViewController
-(void)loadView{
    _inventoryChooseView = [InventoryChooseView viewInstance];
    self.view = _inventoryChooseView;
    self.title = @"清点规格";
}

-(void)bindListener{
    _inventoryChooseView.tableView.delegate = self;
    _inventoryChooseView.tableView.dataSource = self;
    
    _inventoryChooseView.bottomView.userInteractionEnabled = YES;
    [_inventoryChooseView.bottomView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewClick:)]];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(priceUpdate:) name:@"priceUpdate" object:nil];
}

-(void)loadData{
    NSString *itemWhere = [NSString stringWithFormat:@"salesOrderItemCode = '%@'",_itemSnapshotCode];
    _itemSnapshot = [ItemSnapshot searchSingleWithWhere:itemWhere orderBy:nil];
    _commodityList = [[PropertyManager getInstance]getAllLocalCommoditySnapshot];
    if(_itemSnapshot.commodities == nil){
        _chooseCommodityList = [NSMutableArray new];
    }else{
        _chooseCommodityList = _itemSnapshot.commodities;
    }
    
    _inventoryChooseView.numberLabel.text = [NSString stringWithFormat:@"%lu",_chooseCommodityList.count];
    _inventoryChooseView.priceLabel.text = [self calculatePrice];
}

-(void)saveData{
    _itemSnapshot.commodities = _chooseCommodityList;
    [_itemSnapshot updateToDB];

}

#pragma mark - IBAction
- (void)bottomViewClick:(UITapGestureRecognizer *)recognizer{
   
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commodityList.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    InventoryChooseCell *cell = [InventoryChooseCell cellWithTableView:tableView];
    CommoditySnapshot *commoditySnapshot = self.commodityList[row];
    cell.commoditySnapshot = commoditySnapshot;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommoditySnapshot *commodity = _commodityList[indexPath.row];
    if([[PropertyManager getInstance] isExistProperty:commodity.commodityCode]){
        _standardsView = [self buildStandardView:commodity.commodityCode];
        _standardsView.showAnimationType = StandsViewShowAnimationShowFrombelow;
        _standardsView.dismissAnimationType = StandsViewDismissAnimationDisFrombelow;
        _currentCommoditySnapshot = commodity;
        [_standardsView show];
    }else{
        commodity.code = [[NSUUID UUID] UUIDString];
        [_chooseCommodityList addObject:commodity];
        _inventoryChooseView.numberLabel.text = [NSString stringWithFormat:@"%lu",_chooseCommodityList.count];
        _inventoryChooseView.priceLabel.text = [self calculatePrice];
    }
}

/**
 *  已选服务总价格
 *
 *  @return 总价格
 */
-(NSString *)calculatePrice{
    float price = 0.0f;
    for (CommoditySnapshot *snapshot in _chooseCommodityList) {
        price += [snapshot.price floatValue];
    }
    return [NSString stringWithFormat:@"总价: %g",price];
}

#pragma mark - Notification
- (void)priceUpdate:(NSNotification *)text{
    _isChoose = [text.userInfo[@"flag"] boolValue];
    if(_isChoose){
        NSString *price = text.userInfo[@"price"];
        NSString *itemProperties = text.userInfo[@"property"];
        _standardsView.priceLab.text = [NSString stringWithFormat:@"价格:%@", price];
        _standardsView.goodNum.text = [NSString stringWithFormat:@"%@", itemProperties];
        _currentCommoditySnapshot = [CommoditySnapshot new];
        _currentCommoditySnapshot.itemProperties = itemProperties;
        _currentCommoditySnapshot.price = price;
        _currentCommoditySnapshot.code = [[NSUUID UUID] UUIDString];
        [_chooseCommodityList addObject:_currentCommoditySnapshot];
        _inventoryChooseView.numberLabel.text = [NSString stringWithFormat:@"%lu",_chooseCommodityList.count];
        _inventoryChooseView.priceLabel.text = [self calculatePrice];
    }else{
        _currentCommoditySnapshot = nil;
        _standardsView.priceLab.text = @"";
        _standardsView.goodNum.text = @"";
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
#pragma mark - standardView  delegate

-(void)StandardsView:(StandardsView *)standardView CustomBtnClickAction:(UIButton *)sender{
    if (sender.tag == 0) {
        [standardView ThrowGoodTo:CGPointMake(200, 100) andDuration:1.6 andHeight:150 andScale:20];
        [_chooseCommodityList addObject:_currentCommoditySnapshot];
    }
    else{
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
@end