//
//  SettingViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/10.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingViewCell.h"
#import "CacheCell.h"
#import "SDImageCache.h"
#import "Utils.h"
#if DEBUG
#import "FLEXManager.h"
#endif
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation SettingViewController


-(void)setupView
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
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 2;
            break;
        case 1:
            row = 2;
        case 2:
            row = 1;
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
    if (indexPath.section == 2) {
        CacheCell *cell = [CacheCell cellWithTableView:tableView];
        
        switch (indexPath.row) {
            case 0:
                [cell setCacheSize:[self p_diskCacheSizeStr]];
                break;
                
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        SettingViewCell *cell = [SettingViewCell cellWithTableView:tableView];
        cell.backgroundColor = [UIColor clearColor];
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        [cell initSetting:[Config getSound] contentText:@"声音" icon:@""];
                        
                        break;
                    case 1:
                        [cell initSetting:[Config getVibre] contentText:@"震动" icon:@""];
                        break;
                }
                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
                        [cell initSetting:[Config getQuickScan] contentText:@"快速扫描" icon:@""];
                        
                        break;
                    case 1:
                        [cell initSetting:[Config getSearch] contentText:@"搜索包含历史工单" icon:@""];
                        break;
                }
        }

        cell.jsSwitch.tag = indexPath.section * 10 + indexPath.row;
        [cell.jsSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
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
-(NSString *) p_diskCacheSizeStr{
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    size += [Utils getResponseCacheSize];
    return [NSString stringWithFormat:@"%.2f M", size/ 1024.0/ 1024.0];
}
@end
