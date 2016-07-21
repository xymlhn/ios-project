//
//  WorkOrderStepEditView.m
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderStepEditView.h"
#import "PhotoCell.h"

@implementation WorkOrderStepEditView

+ (instancetype)workOrderStepEditViewInstance:(UIView *)view{
    WorkOrderStepEditView *workOrderStepEditView = [WorkOrderStepEditView new];
    [workOrderStepEditView initView:view];
    return workOrderStepEditView;
}

-(void)initView:(UIView *)rootView
{
    rootView.backgroundColor = [UIColor whiteColor];
    
    _containView = [UIView new];
    [_containView setBackgroundColor:[UIColor whiteColor]];
    [rootView addSubview:_containView];
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView).with.insets(UIEdgeInsetsMake(69, 5, 5, 5));
    }];
    _titleText = [UILabel new];
    _titleText.font = [UIFont systemFontOfSize:12];//
    _titleText.text = @"步骤1";
    _titleText.textColor = [UIColor blackColor];
    
    [_containView addSubview:_titleText];
    [_titleText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_containView.mas_top).with.offset(0);
        make.left.equalTo(_containView.mas_left).with.offset(5);
        make.right.equalTo(_containView.mas_right).with.offset(5);
        make.height.equalTo(@30);
    }];
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [_containView addSubview:codeBottomLine];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_titleText.mas_bottom).with.offset(0);
        make.left.equalTo(_containView.mas_left).with.offset(0);
        make.right.equalTo(_containView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    _alwaysBtn = [UILabel new];
    _alwaysBtn.font = [UIFont systemFontOfSize:20];//
    _alwaysBtn.text = @"常用步骤";
    _alwaysBtn.textColor = [UIColor blackColor];
    _alwaysBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _alwaysBtn.layer.borderWidth =1.0;
    _alwaysBtn.layer.cornerRadius =5.0;
    _alwaysBtn.textAlignment = NSTextAlignmentCenter;
    [_containView addSubview:_alwaysBtn];
    [_alwaysBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(_containView.mas_centerX);
        make.top.equalTo(_titleText.mas_bottom).with.offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    _editText = [UITextView new];
    _editText.font = [UIFont systemFontOfSize:14];
    _editText.textColor = [UIColor blackColor];
    _editText.layer.borderColor = [UIColor grayColor].CGColor;
    _editText.layer.borderWidth =1.0;
    _editText.layer.cornerRadius =5.0;
    [_containView addSubview:_editText];
    [_editText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_alwaysBtn.mas_bottom).with.offset(10);
        make.left.equalTo(_containView.mas_left).with.offset(0);
        make.right.equalTo(_containView.mas_right).with.offset(0);
        make.height.equalTo(@150);
    }];
    
    //创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置单元格的尺寸
    flowLayout.itemSize = CGSizeMake(80, 80);
    //flowlaout的属性，横向滑动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 200, 320, 280) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor lightGrayColor];

    [rootView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_editText.mas_bottom).with.offset(10);
        make.left.equalTo(_containView.mas_left).with.offset(0);
        make.right.equalTo(_containView.mas_right).with.offset(0);
        make.height.equalTo(@120);
    }];
    [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"cell"];
    [self initBottomView:rootView];
    
}
-(void)initBottomView:(UIView *)rootView
{
    UIView *bottomView = [UIView new];
    
    [rootView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(rootView.mas_bottom).with.offset(0);
        make.left.equalTo(rootView.mas_left).with.offset(0);
        make.right.equalTo(rootView.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:codeBottomLine];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(bottomView.mas_top).with.offset(0);
        make.left.equalTo(bottomView.mas_left).with.offset(0);
        make.right.equalTo(bottomView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    _delBtn = [UILabel new];
    [_delBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _delBtn.text = @"";
    _delBtn.textAlignment = NSTextAlignmentCenter;
    _delBtn.textColor = [UIColor nameColor];
    [bottomView addSubview:_delBtn];
    
    _photoBtn = [UILabel new];
    [_photoBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _photoBtn.text = @"";
    _photoBtn.textAlignment = NSTextAlignmentCenter;
    _photoBtn.textColor = [UIColor nameColor];
    [bottomView addSubview:_photoBtn];

    _saveBtn = [UILabel new];
    [_saveBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _saveBtn.text = @"";
    _saveBtn.textAlignment = NSTextAlignmentCenter;
    _saveBtn.textColor = [UIColor nameColor];
    [bottomView addSubview:_saveBtn];
    
    [_delBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(bottomView.mas_left);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    
    [_photoBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_delBtn.mas_right);
        make.width.equalTo(_delBtn);
        make.centerY.equalTo(bottomView.mas_centerY);
        
    }];
    
   
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(bottomView.mas_right);
        make.left.equalTo(_photoBtn.mas_right);
        make.width.equalTo(_photoBtn);
        make.centerY.equalTo(bottomView.mas_centerY);
       
    }];
    
}
@end
