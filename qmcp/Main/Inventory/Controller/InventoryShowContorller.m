//
//  InventoryShowContorller.m
//  qmcp
//
//  Created by 谢永明 on 2016/11/24.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "InventoryShowContorller.h"
#import "InventoryShowView.h"
#import "InventoryChooseCell.h"
@interface InventoryShowContorller ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) InventoryShowView *showView;

@end

@implementation InventoryShowContorller

+ (instancetype) doneBlock:(void(^)(NSMutableArray<CommoditySnapshot *> *commodies))block{
    InventoryShowContorller *vc = [[InventoryShowContorller alloc] init];
    vc.doneBlock = block;
    return vc;
    
}
-(void)setChooseCommodityList:(NSMutableArray<CommoditySnapshot *> *)chooseCommodityList{
    _chooseCommodityList = chooseCommodityList;
}
#pragma mark - BaseWorkOrderViewController
-(void)loadView{
    _showView = [InventoryShowView viewInstance];
    self.view = _showView;
}

-(void)bindListener{
    _showView.tableView.delegate = self;
    _showView.tableView.dataSource = self;
    _showView.baseView.userInteractionEnabled = YES;
    [_showView.baseView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)]];
    _showView.cancelBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self dissmiss];
        return [RACSignal empty];
    }];

}

-(void)loadData{
    
}

- (void)dissmiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chooseCommodityList.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    InventoryChooseCell *cell = [InventoryChooseCell cellWithTableView:tableView];
    CommoditySnapshot *commoditySnapshot = self.chooseCommodityList[row];
    cell.commoditySnapshot = commoditySnapshot;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
