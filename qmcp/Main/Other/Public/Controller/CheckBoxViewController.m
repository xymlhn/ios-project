//
//  CheckBoxViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/7/16.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "CheckBoxViewController.h"
#import "CheckBoxView.h"
#import "CheckCell.h"
#import "ReactiveCocoa.h"

@interface CheckBoxViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) CheckBoxView *checkBoxView;

@end
@implementation CheckBoxViewController

-(void)loadView{
    _checkBoxView = [CheckBoxView viewInstance];
    self.view = _checkBoxView;
}

-(NSMutableArray<NSNumber *> *)statusList{
    if(_statusList == nil){
        _statusList = [NSMutableArray new];
        for (int i = 0; i < _valueList.count; i++) {
            _statusList[i] = [NSNumber numberWithBool:NO];
        }
    }
    return _statusList;
}

-(void)bindListener{
    _checkBoxView.tableView.delegate = self;
    _checkBoxView.tableView.dataSource = self;
    
    _checkBoxView.baseView.userInteractionEnabled = YES;
    [_checkBoxView.baseView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)]];
    
    _checkBoxView.cancelBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self dissmiss];
        return [RACSignal empty];
    }];
    
    _checkBoxView.confirmBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self dissmiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.doneBlock) {
                self.doneBlock([self p_handleChooseValue]);
            }
        });
        return [RACSignal empty];
    }];
    
}

-(void)loadData{
    
}

-(NSString *)p_handleChooseValue{

    NSMutableString *value = [NSMutableString new];
    for (int i = 0; i < self.statusList.count; i++) {
        if(self.statusList[i] == [NSNumber numberWithBool:YES]){
            [value appendString:[NSString stringWithFormat:@"%@,",_valueList[i]]];
        }
    }
    if(value.length > 0){
        [value deleteCharactersInRange:NSMakeRange(value.length-1, 1)];

    }
    return value;
}

+(instancetype)doneBlock:(void (^)(NSString *))block{
    
    CheckBoxViewController *vc = [[CheckBoxViewController alloc] init];
    vc.doneBlock = block;
    return vc;
    
}


- (void)dissmiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.valueList.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    //1 创建可重用的自定义的cell
    CheckCell *cell = [CheckCell cellWithTableView:tableView];
    //2 设置cell内部的子控件

    cell.jsText.text = self.valueList[row];
    NSNumber *status = self.statusList[row];
    [cell.jsSwitch setOn:[status boolValue]];
    cell.jsSwitch.tag = row;
    [cell.jsSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //3 返回
    return cell;
}
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    NSUInteger tag = switchButton.tag;
    self.statusList[tag] = [NSNumber numberWithBool:switchButton.isOn];
}

@end
