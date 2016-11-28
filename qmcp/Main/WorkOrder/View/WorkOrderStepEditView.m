//
//  WorkOrderStepEditView.m
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderStepEditView.h"
#import "PhotoCell.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>
@implementation WorkOrderStepEditView

+ (instancetype)viewInstance{
    WorkOrderStepEditView *workOrderStepEditView = [WorkOrderStepEditView new];
    return workOrderStepEditView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;

    self.backgroundColor = [UIColor whiteColor];
    
    [self initTopView];
    [self setupBottomView];
    
    return self;
    
}

-(void)initTopView{
    
    _editText = [UITextView new];
     _editText.returnKeyType = UIReturnKeyDone;
    _editText.font = [UIFont systemFontOfSize:kShisipt];
    _editText.textColor = [UIColor mainTextColor];
    _editText.placeholder = @"在此输入文字";
    _editText.placeholderLabel.font =  [UIFont systemFontOfSize:kShisipt];
    _editText.placeholderColor = [UIColor arrowColor];
    [self addSubview:_editText];
    
    _fastView = [UIView new];
    [self addSubview:_fastView];
    
    UIView *commodityLine = [UIView new];
    commodityLine.backgroundColor = [UIColor lineColor];
    [_fastView addSubview:commodityLine];
    
    UIView *commodityTopLine = [UIView new];
    commodityTopLine.backgroundColor = [UIColor lineColor];
    [_fastView addSubview:commodityTopLine];
    
    UILabel *fastLabel = [UILabel new];
    fastLabel.font =  [UIFont systemFontOfSize:kShisanpt];
    fastLabel.textColor = [UIColor mainTextColor];
    fastLabel.text = @"快速描述";
    [_fastView addSubview:fastLabel];
    
    UILabel *rightIcon = [UILabel new];
    [rightIcon setFont:[UIFont fontWithName:@"FontAwesome" size:kFontAwesomeArrow]];
    rightIcon.text = @"";
    rightIcon.textColor = [UIColor arrowColor];
    [_fastView addSubview:rightIcon];
    
    UILabel *photoLabel = [UILabel new];
    photoLabel.text = @"实时拍照";
    photoLabel.font =  [UIFont systemFontOfSize:kShisanpt];
    photoLabel.textColor = [UIColor mainTextColor];
    [self addSubview:photoLabel];
    
    CGFloat itemWH = (kScreen_Width - 12 * 4) / 3;
    //创建布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.sectionInset = UIEdgeInsetsMake(6, 12, 6, 12);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 20;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.scrollEnabled = NO;
    [self addSubview:_collectionView];
    
    [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    
    [_editText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(@95);
    }];
    
    [_fastView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_editText.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];

    
    [fastLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_fastView.mas_centerY);
        make.left.equalTo(_fastView.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_fastView.mas_centerY);
        make.right.equalTo(_fastView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
    
    [commodityTopLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_fastView.mas_top).with.offset(0);
        make.left.equalTo(_fastView.mas_left).with.offset(0);
        make.right.equalTo(_fastView.mas_right).with.offset(0);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    [commodityLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_fastView.mas_bottom).with.offset(0);
        make.left.equalTo(_fastView.mas_left).with.offset(0);
        make.right.equalTo(_fastView.mas_right).with.offset(0);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    
    [photoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(commodityLine.mas_bottom).with.offset(kPaddingLeftWidth);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
    }];

    NSNumber *collectionH = [NSNumber numberWithInteger:itemWH * 2 + 12 *3] ;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(photoLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(collectionH);
    }];
}

//底部按钮
-(void)setupBottomView{
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor lineColor];
    [bottomView addSubview:codeBottomLine];
    
    _delBtn = [UIButton new];
    [_delBtn.layer setMasksToBounds:YES];
    [_delBtn.layer setCornerRadius:kBottomButtonCorner];
    [_delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _delBtn.titleLabel.font = [UIFont systemFontOfSize:kShisipt];
    [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
    _delBtn.backgroundColor = [UIColor appBlueColor];
    [bottomView addSubview:_delBtn];
    
    _saveBtn = [UIButton new];
    [_saveBtn.layer setMasksToBounds:YES];
    [_saveBtn.layer setCornerRadius:kBottomButtonCorner];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:kShisipt];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    _saveBtn.backgroundColor = [UIColor appBlueColor];
    [bottomView addSubview:_saveBtn];
    
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
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(bottomView.mas_left).offset(kPaddingLeftWidth);
        make.right.equalTo(bottomView.mas_centerX).offset(-kPaddingLeftWidth/2);
        make.height.equalTo(@30);
    }];
    [_delBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(bottomView.mas_centerX).offset(kPaddingLeftWidth/2);
        make.right.equalTo(bottomView.mas_right).offset(-kPaddingLeftWidth);
        make.height.equalTo(@30);
    }];
}

@end
