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
    
    _editText = [UITextView new];
    _editText.font = [UIFont systemFontOfSize:14];
    _editText.textColor = [UIColor blackColor];
    [self addSubview:_editText];
    [_editText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(@150);
    }];
  
    
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
    
    UIView *photoView = [UIView new];
    [self addSubview:photoView];
    
    UIView *photoLine = [UIView new];
    photoLine.backgroundColor = [UIColor grayColor];
    [photoView addSubview:photoLine];
    
    UILabel *photoIcon = [UILabel new];
    [photoIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    photoIcon.text = @"";
    photoIcon.textColor = [UIColor blackColor];
    [photoView addSubview:photoIcon];
    
    UILabel *photoLabel = [UILabel new];
    photoLabel.text = @"相片";
    [photoView addSubview:photoLabel];
    
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

    
    
    //创建布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = (kScreen_Width - 12 * 3) / 3;
    CGFloat itemH = (kScreen_Width - 12 * 3) / 3;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.sectionInset = UIEdgeInsetsMake(20, 12, 20, 12);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 20;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor grayColor];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(photoView.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(@120);
    }];
    [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    
    [self initBottomView];
    
    return self;
    
}

-(void)initBottomView
{
    UIView *bottomView = [UIView new];
    
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
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
    
    
   
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(bottomView.mas_right);
        make.left.equalTo(_delBtn.mas_right);
        make.width.equalTo(_delBtn);
        make.centerY.equalTo(bottomView.mas_centerY);
       
    }];
    
}
@end
