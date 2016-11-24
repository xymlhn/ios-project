//
//  WorkOrderCommodityStepController.m
//  qmcp
//
//  Created by 谢永明 on 16/9/1.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "CommodityStepController.h"
#import "CommodityStepView.h"
#import "CommodityStepCell.h"
#import "CommodityStep.h"
#define kHeader @"header" // 头部标题对应的key
#define kFooter @"footer" // 尾部标题对应的key
#define kCities @"cities" // 城市数组对应的key
@interface CommodityStepController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray<NSNumber *> *isExpland;//是否展开
@property (nonatomic, strong) CommodityStepView *commodityStepView;

@end

@implementation CommodityStepController

-(void)loadView{
    _commodityStepView = [CommodityStepView viewInstance];
    self.view = _commodityStepView;
    
}

-(void)bindListener{
    _commodityStepView.tableView.delegate = self;
    _commodityStepView.tableView.dataSource = self;
    
    _commodityStepView.baseView.userInteractionEnabled = YES;
    [_commodityStepView.baseView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)]];
    
}

-(void)loadData{
    
    if (!self.isExpland) {
        self.isExpland = [NSMutableArray array];
    }
    
    //用0代表收起，非0（不一定是1）代表展开，默认都是收起的
    for (int i = 0; i < self.dataArray.count; i++) {
        [self.isExpland addObject:@1];
    }
}

- (void)dissmiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

+(instancetype)doneBlock:(void (^)(NSString *))block{
    
    CommodityStepController *vc = [[CommodityStepController alloc] init];
    vc.doneBlock = block;
    return vc;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这里是关键，如果选中
    NSArray *array = self.dataArray[section];
    if ([self.isExpland[section] boolValue]) {
        return array.count;
    }
    else {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommodityStepCell *cell = [CommodityStepCell cellWithTableView:tableView];
    CommodityStep *commodityStep = self.dataArray[indexPath.section][indexPath.row];
    cell.contentLabel.text = commodityStep.stepName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommodityStep *commodityStep = self.dataArray[indexPath.section][indexPath.row];
    [self dissmiss];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.doneBlock) {
            self.doneBlock(commodityStep.stepName);
        }
    });
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    headView.backgroundColor = [UIColor themeColor];
    
    UIButton *headerSection = [UIButton new];
    [headerSection setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    headerSection.titleLabel.font = [UIFont systemFontOfSize:12];
    headerSection.titleLabel.textAlignment = NSTextAlignmentLeft;
    headerSection.tag = 666+section;
    [headView addSubview:headerSection];
    
    [headerSection mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(headView.mas_top).with.offset(0);
        make.left.equalTo(headView.mas_left).with.offset(0);
        make.right.equalTo(headView.mas_right).with.offset(0);
        make.bottom.equalTo(headView.mas_bottom).with.offset(0);
    }];
    
    CommodityStep *commodityStep = self.dataArray[section][0];
    //标题
    [headerSection setTitle:commodityStep.commodityName forState:UIControlStateNormal];
    [headerSection addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (void)buttonAction:(UIButton *)button {
    NSInteger section = button.tag - 666;
    self.isExpland[section] = [self.isExpland[section] isEqual:@0]?@1:@0;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    [self.commodityStepView.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}
@end
