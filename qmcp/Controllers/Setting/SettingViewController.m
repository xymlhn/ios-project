//
//  SettingViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/10.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingViewCell.h"
#import "Config.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray *switchArr;
@property (nonatomic, copy) NSArray *contentArr;
@end

@implementation SettingViewController


-(void)initView
{
    _tableView = [UITableView new];
    _tableView.rowHeight = 100;
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor themeColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-40);
    }];
}
-(void)bindListener
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
}
-(void)loadData
{
    _switchArr = @[[NSNumber numberWithBool:[Config getSound]],[NSNumber numberWithBool:[Config getVibre]]
                   ,[NSNumber numberWithBool:[Config getQuickScan]]];
    
    _contentArr = @[@"声音",@"震动",@"快速扫描"];
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
}
@end
