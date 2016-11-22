//
//  WorkOrderStepView.m
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderStepView.h"

@implementation WorkOrderStepView

+ (instancetype)viewInstance{
    WorkOrderStepView *workOrderStepView = [WorkOrderStepView new];
    
    return workOrderStepView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom).with.offset(-44);
    }];
    
    [self setupBottomView];
    return self;

}

//底部按钮
-(void)setupBottomView{
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor lineColor];
    [bottomView addSubview:codeBottomLine];

    _addBtn = [UIButton new];
    [_addBtn.layer setMasksToBounds:YES];
    [_addBtn.layer setCornerRadius:3.0];
    [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addBtn.titleLabel.font = [UIFont systemFontOfSize:kShisipt];
    [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
    _addBtn.backgroundColor = [UIColor appBlueColor];
    [bottomView addSubview:_addBtn];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@44);
    }];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(bottomView.mas_top).with.offset(0);
        make.left.equalTo(bottomView.mas_left).with.offset(0);
        make.right.equalTo(bottomView.mas_right).with.offset(0);
        make.height.mas_equalTo(kLineHeight);
    }];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(bottomView);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
    }];
}

@end
