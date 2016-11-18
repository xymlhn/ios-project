//
//  WorkOrderFormController.m
//  qmcp
//
//  Created by 谢永明 on 16/6/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderFormController.h"
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
#import "WorkOrderFormView.h"
@interface WorkOrderFormController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray<FormTemplateField* > *workOrderFormList;
@property (nonatomic, strong) WorkOrderFormView *workOrderFormView;
@property (nonatomic, copy) NSString *currentPlusFormTemplateId;
@property (nonatomic,assign) NSUInteger currentPlusOrder;

@end

@implementation WorkOrderFormController

#pragma mark - UIViewController

-(void)loadView
{
    _workOrderFormView = [WorkOrderFormView viewInstance];
    self.view = _workOrderFormView;
    self.title = @"表单编辑";
    
    
}

-(void)bindListener{
    
    _workOrderFormView.tableView.delegate = self;
    _workOrderFormView.tableView.dataSource = self;
    
    _workOrderFormView.saveBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self saveBtnClick];
        return [RACSignal empty];
    }];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    

}


- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBounds = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _workOrderFormView.tableView.contentInset = UIEdgeInsetsMake(_workOrderFormView.tableView.contentInset.top, 0, keyboardBounds.size.height, 0);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
     _workOrderFormView.tableView.contentInset = UIEdgeInsetsMake(_workOrderFormView.tableView.contentInset.top, 0, 0, 0);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)hidenKeyboard
{
    [self.view endEditing:YES];

}

-(void)loadData
{
    _workOrderFormList = [[FormManager getInstance]formTemplateField:_formTemplateId];
    [[FormManager getInstance] handleFormTable:_workOrderFormList formTemplateId:_formTemplateId];
}

#pragma mark IBAction

-(void)saveBtnClick{
    
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
            ((HeaderCell *)cell).deleteBtn.tag = row;
            ((HeaderCell *)cell).deleteBtn.userInteractionEnabled = YES;
            [((HeaderCell *)cell).deleteBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteBtnClick:)]];
            break;
            
        case FormTemplateControlTypeFooter:
            cell = [FooterCell cellWithTableView:tableView];
            ((FooterCell *)cell).field = field;
            ((FooterCell *)cell).containView.tag = row;
            _currentPlusFormTemplateId = field.tableTemplateId;
            _currentPlusOrder = field.tempMap.count;
            ((FooterCell *)cell).containView.userInteractionEnabled = YES;
            [((FooterCell *)cell).containView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerViewClick:)]];
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
            return 120;
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

#pragma mark - IBAction

-(void)footerViewClick:(UITapGestureRecognizer *)recognizer{
    NSMutableArray<FormTemplateField *> *tableList = [[FormManager getInstance] plusFormTemplate:_currentPlusFormTemplateId withOrder:_currentPlusOrder];
    NSRange range = NSMakeRange(recognizer.view.tag, [tableList count]);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.workOrderFormList insertObjects:tableList atIndexes:indexSet];
    [_workOrderFormView.tableView reloadData];
}

-(void)deleteBtnClick:(UITapGestureRecognizer *)recognizer{
    FormTemplateField *field = _workOrderFormList[recognizer.view.tag];

    [self.workOrderFormList removeObjectsInArray:field.templateFields];
    [_workOrderFormView.tableView reloadData];
}
@end






















