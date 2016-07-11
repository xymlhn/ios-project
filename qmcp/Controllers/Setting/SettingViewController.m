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

@end

@implementation SettingViewController


-(void)initView
{
    self.title = @"设置";
    _tableView = [UITableView new];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
}
-(void)bindListener
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
}
-(void)loadData
{
                                                                                                                       
}
#pragma mark - Table view data source

#pragma mark TableM
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 2;
            break;
        case 1:
            row = 2;
            break;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingViewCell *cell = [SettingViewCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor clearColor];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [cell initSetting:[Config getSound] andText:@"声音"];
                    
                    break;
                case 1:
                    [cell initSetting:[Config getVibre] andText:@"震动"];
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [cell initSetting:[Config getQuickScan] andText:@"快速扫描"];
                    
                    break;
                case 1:
                    [cell initSetting:[Config getSearch] andText:@"搜索包含历史工单"];
                    break;
            }
            break;
    }

    cell.jsSwitch.tag = indexPath.section * 10 + indexPath.row;
    [cell.jsSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        case 10:
            [Config setQuickScan:switchButton.on];
            break;
        case 11:
            [Config setSearch:switchButton.on];
            break;
        default:
            break;
    }
}
@end
