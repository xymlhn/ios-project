//
//  WorkOrderInventoryEditView.m
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "InventoryEditView.h"
#import "PhotoCell.h"
#import "CommodityCell.h"

@implementation InventoryEditView

+ (instancetype)viewInstance{
    InventoryEditView *workOrderInventoryEditView = [InventoryEditView new];
    return workOrderInventoryEditView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    UIView *containView = [UIView new];
    [containView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 5, 5, 5));
    }];
    [self setupView];
    [self setupBottomView];
    
    return self;
}

-(void)setupView{
    UIView *qrView = [UIView new];
    [self addSubview:qrView];
    
    UIView *qrLine = [UIView new];
    qrLine.backgroundColor = [UIColor grayColor];
    [qrView addSubview:qrLine];
    
    _qrBtn = [UIButton new];
    [_qrBtn setBackgroundImage:[UIImage imageNamed:@"qr_scan"] forState:UIControlStateNormal];
    [qrView addSubview:_qrBtn];
    
    _qrText = [UITextField new];
    _qrText.layer.borderColor= [UIColor grayColor].CGColor;
    _qrText.layer.borderWidth= 1.0f;
    _qrText.layer.cornerRadius = 5.0f;
    _qrText.font = [UIFont systemFontOfSize:12];
    _qrText.textColor = [UIColor grayColor];
    CGRect frame = _qrText.frame;
    frame.size.width = 5.0f;
    _qrText.leftViewMode = UITextFieldViewModeAlways;
    _qrText.leftView = [[UIView alloc] initWithFrame:frame];
    [qrView addSubview:_qrText];
    
    _lockIcon = [UILabel new];
    [_lockIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    _lockIcon.text = @"";
    _lockIcon.textColor = [UIColor blackColor];
    [qrView addSubview:_lockIcon];
    
    UIView *goodNameView = [UIView new];
    [self addSubview:goodNameView];
    
    UIView *goodNameLine = [UIView new];
    goodNameLine.backgroundColor = [UIColor grayColor];
    [goodNameView addSubview:goodNameLine];
    
    _goodNameLabel = [UILabel new];
    _goodNameLabel.text = @"物品名";
    [goodNameView addSubview:_goodNameLabel];
    
    _goodNameText = [UITextField new];
    _goodNameText.layer.borderColor= [UIColor grayColor].CGColor;
    _goodNameText.layer.borderWidth= 1.0f;
    _goodNameText.layer.cornerRadius = 5.0f;
    _goodNameText.font = [UIFont systemFontOfSize:12];
    _goodNameText.textColor = [UIColor grayColor];
    CGRect goodframe = _goodNameText.frame;
    goodframe.size.width = 5.0f;
    _goodNameText.leftViewMode = UITextFieldViewModeAlways;
    _goodNameText.leftView = [[UIView alloc] initWithFrame:goodframe];
    [goodNameView addSubview:_goodNameText];
    
    UIView *remarkView = [UIView new];
    [self addSubview:remarkView];
    
    UIView *remarkLine = [UIView new];
    remarkLine.backgroundColor = [UIColor grayColor];
    [remarkView addSubview:remarkLine];
    
    _remarkLabel = [UILabel new];
    _remarkLabel.text = @"备    注";
    [remarkView addSubview:_remarkLabel];
    
    _remarkText = [UITextField new];
    _remarkText.layer.borderColor= [UIColor grayColor].CGColor;
    _remarkText.layer.borderWidth= 1.0f;
    _remarkText.layer.cornerRadius = 5.0f;
    _remarkText.font = [UIFont systemFontOfSize:12];
    _remarkText.textColor = [UIColor grayColor];
    CGRect remarkframe = _remarkText.frame;
    remarkframe.size.width = 5.0f;
    _remarkText.leftViewMode = UITextFieldViewModeAlways;
    _remarkText.leftView = [[UIView alloc] initWithFrame:remarkframe];
    [remarkView addSubview:_remarkText];
    
    UIView *photoView = [UIView new];
    [self addSubview:photoView];
    
    UIView *photoLine = [UIView new];
    photoLine.backgroundColor = [UIColor grayColor];
    [photoView addSubview:photoLine];
    
    _photoIcon = [UILabel new];
    [_photoIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    _photoIcon.text = @"";
    _photoIcon.textColor = [UIColor blackColor];
    [photoView addSubview:_photoIcon];
    
    _photoLabel = [UILabel new];
    _photoLabel.text = @"相片";
    [photoView addSubview:_photoLabel];
    
    CGFloat itemWH = (kScreen_Width - 12 * 4) / 3;
    //创建布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.sectionInset = UIEdgeInsetsMake(6, 12, 6, 12);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 20;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _photoCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _photoCollectionView.backgroundColor = [UIColor whiteColor];
    _photoCollectionView.scrollEnabled = NO;
    [self addSubview:_photoCollectionView];
    
    [_photoCollectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    
    
    _commodityView = [UIView new];
    [self addSubview:_commodityView];
    
    UIView *commodityLine = [UIView new];
    commodityLine.backgroundColor = [UIColor grayColor];
    [_commodityView addSubview:commodityLine];
    
    UIView *commodityTopLine = [UIView new];
    commodityTopLine.backgroundColor = [UIColor grayColor];
    [_commodityView addSubview:commodityTopLine];
    
    _commodityLeftIcon = [UILabel new];
    [_commodityLeftIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    _commodityLeftIcon.text = @"";
    _commodityLeftIcon.textColor = [UIColor blackColor];
    [_commodityView addSubview:_commodityLeftIcon];
    
    _commodityLabel = [UILabel new];
    _commodityLabel.text = @"添加服务";
    [_commodityView addSubview:_commodityLabel];
    
    _commodityRightIcon = [UILabel new];
    [_commodityRightIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    _commodityRightIcon.text = @"";
    _commodityRightIcon.textColor = [UIColor blackColor];
    [_commodityView addSubview:_commodityRightIcon];
    
    [qrView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    [_qrBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(qrView.mas_centerY);
        make.left.equalTo(qrView.mas_left).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    [_qrText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(qrView.mas_centerY);
        make.left.equalTo(_qrBtn.mas_right).with.offset(kPaddingLeftWidth);
        make.right.equalTo(_lockIcon.mas_left).with.offset(-kPaddingLeftWidth);
        make.height.equalTo(@25);
    }];
    
    [_lockIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(qrView.mas_centerY);
        make.right.equalTo(qrView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
    
    [qrLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(qrView.mas_bottom).with.offset(0);
        make.left.equalTo(qrView.mas_left).with.offset(0);
        make.right.equalTo(qrView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    [goodNameView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(qrView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    [_goodNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(goodNameView.mas_centerY);
        make.left.equalTo(goodNameView.mas_left).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@60);
    }];
    
    [_goodNameText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(goodNameView.mas_centerY);
        make.right.equalTo(goodNameView.mas_right).with.offset(-kPaddingLeftWidth);
        make.left.equalTo(_goodNameLabel.mas_right).with.offset(5);
        make.height.equalTo(@25);
    }];
    
    [goodNameLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(goodNameView.mas_bottom).with.offset(0);
        make.left.equalTo(goodNameView.mas_left).with.offset(0);
        make.right.equalTo(goodNameView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    [remarkView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(goodNameView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(remarkView.mas_centerY);
        make.left.equalTo(remarkView.mas_left).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@60);
    }];
    
    [_remarkText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(remarkView.mas_centerY);
        make.right.equalTo(remarkView.mas_right).with.offset(-kPaddingLeftWidth);
        make.left.equalTo(_remarkLabel.mas_right).with.offset(5);
        make.height.equalTo(@25);
    }];
    
    [remarkLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(remarkView.mas_bottom).with.offset(0);
        make.left.equalTo(remarkView.mas_left).with.offset(0);
        make.right.equalTo(remarkView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    [photoView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(remarkView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    [_photoIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(photoView.mas_centerY);
        make.left.equalTo(photoView.mas_left).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@30);
    }];
    
    [_photoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(photoView.mas_centerY);
        make.right.equalTo(photoView.mas_right).with.offset(-kPaddingLeftWidth);
        make.left.equalTo(_photoIcon.mas_right).with.offset(5);
    }];
    
    [photoLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(photoView.mas_bottom).with.offset(0);
        make.left.equalTo(photoView.mas_left).with.offset(0);
        make.right.equalTo(photoView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    NSNumber *collectionH = [NSNumber numberWithInteger:itemWH * 2 + 12 *3] ;
    [_photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(photoView.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(5);
        make.right.equalTo(self.mas_right).with.offset(-5);
        make.height.equalTo(collectionH);
    }];
    
    [_commodityView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_photoCollectionView.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    [_commodityLeftIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_commodityView.mas_centerY);
        make.left.equalTo(_commodityView.mas_left).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@30);
    }];
    
    [_commodityLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_commodityView.mas_centerY);
        make.left.equalTo(_commodityLeftIcon.mas_right).with.offset(5);
        make.right.equalTo(_commodityRightIcon.mas_left).with.offset(5);
    }];
    
    [_commodityRightIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_commodityView.mas_centerY);
        make.right.equalTo(_commodityView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
    
    [commodityTopLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_commodityView.mas_top).with.offset(0);
        make.left.equalTo(_commodityView.mas_left).with.offset(0);
        make.right.equalTo(_commodityView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    [commodityLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_commodityView.mas_bottom).with.offset(0);
        make.left.equalTo(_commodityView.mas_left).with.offset(0);
        make.right.equalTo(_commodityView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
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
