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
    _editText.font = [UIFont systemFontOfSize:14];
    _editText.textColor = [UIColor blackColor];
    [self addSubview:_editText];
    
    _fastView = [UIView new];
    [self addSubview:_fastView];
    
    UIView *commodityLine = [UIView new];
    commodityLine.backgroundColor = [UIColor grayColor];
    [_fastView addSubview:commodityLine];
    
    UIView *commodityTopLine = [UIView new];
    commodityTopLine.backgroundColor = [UIColor grayColor];
    [_fastView addSubview:commodityTopLine];
    
    UILabel *leftIcon = [UILabel new];
    [leftIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    leftIcon.text = @"";
    leftIcon.textAlignment = NSTextAlignmentCenter;
    leftIcon.textColor = [UIColor blackColor];
    [_fastView addSubview:leftIcon];
    
    UILabel *fastLabel = [UILabel new];
    fastLabel.text = @"快速描述";
    [_fastView addSubview:fastLabel];
    
    UILabel *rightIcon = [UILabel new];
    [rightIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    rightIcon.text = @"";
    
    rightIcon.textColor = [UIColor blackColor];
    [_fastView addSubview:rightIcon];
    
    UIView *photoView = [UIView new];
    [self addSubview:photoView];
    
    UIView *photoLine = [UIView new];
    photoLine.backgroundColor = [UIColor grayColor];
    [photoView addSubview:photoLine];
    
    UILabel *photoIcon = [UILabel new];
    [photoIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    photoIcon.text = @"";
    photoIcon.textAlignment = NSTextAlignmentCenter;
    photoIcon.textColor = [UIColor blackColor];
    [photoView addSubview:photoIcon];
    
    UILabel *photoLabel = [UILabel new];
    photoLabel.text = @"相片";
    [photoView addSubview:photoLabel];
    
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
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(@100);
    }];
    
    [_fastView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_editText.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    [leftIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_fastView.mas_centerY);
        make.left.equalTo(_fastView.mas_left).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@30);
    }];
    
    [fastLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_fastView.mas_centerY);
        make.left.equalTo(leftIcon.mas_right).with.offset(5);
        make.right.equalTo(rightIcon.mas_left).with.offset(5);
    }];
    
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_fastView.mas_centerY);
        make.right.equalTo(_fastView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
    
    [commodityTopLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_fastView.mas_top).with.offset(0);
        make.left.equalTo(_fastView.mas_left).with.offset(0);
        make.right.equalTo(_fastView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    [commodityLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_fastView.mas_bottom).with.offset(0);
        make.left.equalTo(_fastView.mas_left).with.offset(0);
        make.right.equalTo(_fastView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    [photoView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_fastView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    [photoIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(photoView.mas_centerY);
        make.left.equalTo(photoView.mas_left).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@30);
    }];
    
    [photoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(photoView.mas_centerY);
        make.right.equalTo(photoView.mas_right).with.offset(-kPaddingLeftWidth);
        make.left.equalTo(photoIcon.mas_right).with.offset(5);
    }];
    
    [photoLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(photoView.mas_bottom).with.offset(0);
        make.left.equalTo(photoView.mas_left).with.offset(0);
        make.right.equalTo(photoView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    NSNumber *collectionH = [NSNumber numberWithInteger:itemWH * 2 + 12 *3] ;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(photoView.mas_bottom).with.offset(10);
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
    [_delBtn.layer setCornerRadius:3.0];
    [_delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _delBtn.titleLabel.font = [UIFont systemFontOfSize:kShisipt];
    [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
    _delBtn.backgroundColor = [UIColor appBlueColor];
    [bottomView addSubview:_delBtn];
    
    _saveBtn = [UIButton new];
    [_saveBtn.layer setMasksToBounds:YES];
    [_saveBtn.layer setCornerRadius:3.0];
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
    [_delBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(bottomView.mas_left).offset(kPaddingLeftWidth);
        make.right.equalTo(bottomView.mas_centerX).offset(-kPaddingLeftWidth/2);
        make.height.equalTo(@30);
    }];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(bottomView.mas_centerX).offset(kPaddingLeftWidth/2);
        make.right.equalTo(bottomView.mas_right).offset(-kPaddingLeftWidth);
        make.height.equalTo(@30);
    }];
}

@end
