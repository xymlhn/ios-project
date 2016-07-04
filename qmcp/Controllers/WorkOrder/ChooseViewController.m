//
//  ChooseViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/7/3.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "ChooseViewController.h"
#import "ChooseView.h"
#import "ChooseCommodityCell.h"

@interface ChooseViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)ChooseView *chooseView;
@end
@implementation ChooseViewController

-(void)initView{
    _chooseView = [ChooseView new];
    [_chooseView initView:self.view];
}

-(void)bindListener{
    _chooseView.tableView.delegate = self;
    _chooseView.tableView.dataSource = self;
    
    _chooseView.baseView.userInteractionEnabled = YES;
    [_chooseView.baseView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)]];
    
}

-(void)loadData{
    
}

- (void)dissmiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chooseCommodityArr.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    //1 创建可重用的自定义的cell
    ChooseCommodityCell *cell = [ChooseCommodityCell cellWithTableView:tableView];
    //2 设置cell内部的子控件
    PropertyChoose *propertyChoose = self.chooseCommodityArr[row];
    cell.propertyChoose = propertyChoose;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //3 返回
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
