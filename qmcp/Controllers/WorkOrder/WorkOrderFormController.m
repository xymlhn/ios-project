//
//  WorkOrderFormController.m
//  qmcp
//
//  Created by 谢永明 on 16/6/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderFormController.h"
#import "UIColor+Util.h"
#import "Masonry.h"
#import "FormTemplateField.h"
#import "TextSingleCell.h"
#import "DateCell.h"
#import "FormManager.h"
#import "WorkOrder.h"
#import "NumberCell.h"
#import "LabelCell.h"
#import "TextMultiCell.h"
#import "DateTimeCell.h"
#import "SelectCell.h"
#import "CheckBoxCell.h"
#import "HeaderCell.h"
#import "FooterCell.h"

@interface WorkOrderFormController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray<FormTemplateField* > *workOrderFormList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,copy)WorkOrder *workOrder;
@end

@implementation WorkOrderFormController

#pragma mark - UIViewController

-(void)initView
{
    _tableView = [UITableView new];
    _tableView.separatorStyle = YES;
    _tableView.backgroundColor = [UIColor themeColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    self.title = @"表单编辑";
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
}

- (void)hidenKeyboard
{
    [self.view endEditing:YES];

}

-(void)loadData
{
    NSString *workWhere = [NSString stringWithFormat:@"code = '%@'",super.workOrderCode];
    _workOrder = [WorkOrder searchSingleWithWhere:workWhere orderBy:nil];
    _workOrderFormList = [[FormManager getInstance]formTemplateField:_formTemplateId];
    [[FormManager getInstance] handleFormTable:_workOrderFormList formTemplateId:_formTemplateId];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.workOrderFormList.count;
}

//返回每行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    FormTemplateField *field = _workOrderFormList[row];
    UITableViewCell *cell;
    switch (field.controlType) {
        case FormTemplateControlTypeText:
            cell = [TextSingleCell cellWithTableView:tableView];
            ((TextSingleCell *)cell).field = field;
            break;
        case FormTemplateControlTypeDate:
            cell = [DateCell cellWithTableView:tableView];
            ((DateCell *)cell).field = field;
            break;
        case FormTemplateControlTypeNumber:
            cell = [NumberCell cellWithTableView:tableView];
            ((NumberCell *)cell).field = field;
            break;
        case FormTemplateControlTypePrice:
            cell = [NumberCell cellWithTableView:tableView];
            ((NumberCell *)cell).field = field;
            break;
        case FormTemplateControlTypeLabel:
            cell = [LabelCell cellWithTableView:tableView];
            ((LabelCell *)cell).field = field;
            break;
        case FormTemplateControlTypeTextArea:
            cell = [TextMultiCell cellWithTableView:tableView];
            ((TextMultiCell *)cell).field = field;
            break;
        case FormTemplateControlTypeDateTime:
            cell = [DateTimeCell cellWithTableView:tableView];
            ((DateTimeCell *)cell).field = field;
            break;
        case FormTemplateControlTypeSelect:
            cell = [SelectCell cellWithTableView:tableView];
            ((SelectCell *)cell).field = field;
            break;
        case FormTemplateControlTypeCheckBox:
            cell = [CheckBoxCell cellWithTableView:tableView];
            ((CheckBoxCell *)cell).field = field;
            ((CheckBoxCell *)cell).viewController = self;
            break;
        case FormTemplateControlTypeHeader:
            cell = [HeaderCell cellWithTableView:tableView];
            ((HeaderCell *)cell).field = field;
            break;
            
        case FormTemplateControlTypeFooter:
            cell = [FooterCell cellWithTableView:tableView];
            ((FooterCell *)cell).field = field;
            break;
        default:
            cell = [TextMultiCell cellWithTableView:tableView];
            ((TextMultiCell *)cell).field = field;
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    FormTemplateField *field = _workOrderFormList[row];
    switch (field.controlType) {
        case FormTemplateControlTypeHeader:
            return 40;
            break;
        case FormTemplateControlTypeFooter:
            return 40;
            break;
        case FormTemplateControlTypeText:
            return 60;
            break;
        case FormTemplateControlTypeDate:
            return 60;
            break;
        case FormTemplateControlTypeNumber:
            return 60;
            break;
        case FormTemplateControlTypePrice:
            return 60;
            break;
        case FormTemplateControlTypeSelect:
            return 60;
            break;
        case FormTemplateControlTypeCheckBox:
            return 60;
            break;
        case FormTemplateControlTypeLabel:
            return 100;
            break;
        case FormTemplateControlTypeTextArea:
            return 100;
            break;
        case FormTemplateControlTypeDateTime:
            return 60;
            break;
        default:
            return 150;
            break;
    }

}
@end






















