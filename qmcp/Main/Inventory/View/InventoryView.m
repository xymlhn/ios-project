//
//  WorkOrderInventoryView.m
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "InventoryView.h"

@implementation InventoryView

+ (instancetype)viewInstance{
    InventoryView *workOrderInventoryView = [InventoryView new];
    return workOrderInventoryView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = [UIColor whiteColor];
    _tableView = [UITableView new];
    _tableView.rowHeight = 80;
    _tableView.separatorColor = [UIColor lineColor];
    _tableView.backgroundColor = [UIColor themeColor];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-kBottomHeight);
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
    
    _signBtn = [UIButton new];
    [_signBtn.layer setMasksToBounds:YES];
    [_signBtn.layer setCornerRadius:3.0];
    [_signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signBtn.titleLabel.font = [UIFont systemFontOfSize:kShisipt];
    [_signBtn setTitle:@"签名" forState:UIControlStateNormal];
    _signBtn.backgroundColor = [UIColor appBlueColor];
    [bottomView addSubview:_signBtn];
    
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
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(bottomView.mas_left).offset(kPaddingLeftWidth);
        make.right.equalTo(bottomView.mas_centerX).offset(-kPaddingLeftWidth/2);
        make.height.equalTo(@30);
    }];
    [_signBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(bottomView.mas_centerX).offset(kPaddingLeftWidth/2);
        make.right.equalTo(bottomView.mas_right).offset(-kPaddingLeftWidth);
        make.height.equalTo(@30);
    }];
}

@end
