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
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = NO;
    [self addSubview:_scrollView];
    
    [self setupView];
//    [self setupBottomView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.bottom.mas_equalTo(_commodityView.mas_bottom).offset(kBottomHeight);
    }];
    return self;
}

-(void)setupView{
    UIView *qrView = [UIView new];
    [_scrollView addSubview:qrView];
    
    UIView *qrLine = [UIView new];
    qrLine.backgroundColor = [UIColor lineColor];
    [qrView addSubview:qrLine];
    
    _qrBtn = [UIButton new];
    [_qrBtn setBackgroundImage:[UIImage imageNamed:@"qr_scan"] forState:UIControlStateNormal];
    [qrView addSubview:_qrBtn];
    
    _qrText = [UITextField new];
    _qrText.layer.borderColor= [UIColor lineColor].CGColor;
    _qrText.layer.borderWidth= kLineHeight;
    _qrText.layer.cornerRadius = kEditViewCorner;
    _qrText.font = [UIFont systemFontOfSize:kShisipt];
    _qrText.textColor = [UIColor secondTextColor];
    _qrText.placeholder = @"扫描或输入二维码绑定物品";
    [_qrText setValue:[UIColor arrowColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_qrText setValue:[UIFont systemFontOfSize:kShisipt] forKeyPath:@"_placeholderLabel.font"];
    _qrText.returnKeyType = UIReturnKeyNext;
    _qrText.leftViewMode = UITextFieldViewModeAlways;
     _qrText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    [qrView addSubview:_qrText];
    
    _lockBtn = [UIButton new];
    [_lockBtn setBackgroundImage:[UIImage imageNamed:@"qr_scan"] forState:UIControlStateNormal];
    [qrView addSubview:_lockBtn];
    
    _goodNameLabel = [UILabel new];
    _goodNameLabel.font = [UIFont systemFontOfSize:kShisanpt];
    _goodNameLabel.text = @"物品名称";
    _goodNameLabel.textColor = [UIColor mainTextColor];
    [_scrollView addSubview:_goodNameLabel];
    
    _goodNameText = [UITextField new];
    _goodNameText.returnKeyType = UIReturnKeyNext;
    _goodNameText.layer.borderColor= [UIColor lineColor].CGColor;
    _goodNameText.layer.borderWidth= kLineHeight;
    _goodNameText.layer.cornerRadius = kEditViewCorner;
    _goodNameText.font = [UIFont systemFontOfSize:kShisanpt];
    _goodNameText.textColor = [UIColor mainTextColor];
    _goodNameText.leftViewMode = UITextFieldViewModeAlways;
    _goodNameText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    [_scrollView addSubview:_goodNameText];
    
    _remarkLabel = [UILabel new];
    _remarkLabel.font = [UIFont systemFontOfSize:kShisanpt];
    _remarkLabel.textColor = [UIColor mainTextColor];
    _remarkLabel.text = @"备    注";
    [_scrollView addSubview:_remarkLabel];
    
    _remarkText = [UITextView new];
    _remarkText.returnKeyType = UIReturnKeyDone;
    _remarkText.layer.borderColor= [UIColor lineColor].CGColor;
    _remarkText.layer.borderWidth= kLineHeight;
    _remarkText.layer.cornerRadius = kEditViewCorner;
    _remarkText.font = [UIFont systemFontOfSize:kShisanpt];
    _remarkText.textColor = [UIColor secondTextColor];
    [_scrollView addSubview:_remarkText];
    
    _photoLabel = [UILabel new];
    _photoLabel.text = @"照片";
    _photoLabel.textColor = [UIColor mainTextColor];
    _photoLabel.font = [UIFont systemFontOfSize:kShisanpt];
    [_scrollView addSubview:_photoLabel];
    
    _colView = [UIView new];
    _colView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_colView];
    
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
    [_colView addSubview:_photoCollectionView];
    
    [_photoCollectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    
    
    _commodityView = [UIView new];
    [_scrollView addSubview:_commodityView];
    
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
        make.top.equalTo(_scrollView.mas_top).with.offset(0);
        make.left.equalTo(_scrollView.mas_left).with.offset(0);
        make.right.equalTo(_scrollView.mas_right).with.offset(0);
        make.height.mas_equalTo(@76);
    }];
    
    [_qrBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(qrView.mas_centerY);
        make.left.equalTo(qrView.mas_left).with.offset(20);
        make.width.equalTo(@36);
        make.height.equalTo(@36);
    }];
    
    [_qrText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(qrView.mas_centerY);
        make.left.equalTo(_qrBtn.mas_right).with.offset(20);
        make.right.equalTo(_lockBtn.mas_left).with.offset(-12);
        make.height.equalTo(@36);
    }];
    
    [_lockBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(qrView.mas_centerY);
        make.right.equalTo(qrView.mas_right).with.offset(-kPaddingLeftWidth);
        make.width.equalTo(@36);
        make.height.equalTo(@36);

    }];
    
    [qrLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(qrView.mas_bottom).with.offset(0);
        make.left.equalTo(qrView.mas_left).with.offset(0);
        make.right.equalTo(qrView.mas_right).with.offset(0);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    [_goodNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(qrView.mas_bottom).with.offset(kPaddingTopWidth);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    [_goodNameText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_goodNameLabel.mas_bottom).with.offset(5);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.left.equalTo(_goodNameLabel.mas_left).with.offset(0);
        make.height.equalTo(@36);
    }];
    
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_goodNameText.mas_bottom).with.offset(15);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    [_remarkText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_remarkLabel.mas_bottom).with.offset(5);
        make.right.equalTo(self.mas_right).with.offset(-kPaddingLeftWidth);
        make.left.equalTo(_remarkLabel.mas_left).with.offset(0);
        make.height.equalTo(@84);
    }];
    
    [_photoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_remarkText.mas_bottom).with.offset(kPaddingTopWidth);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
    }];
    

    NSNumber *collectionH = [NSNumber numberWithInteger:itemWH * 2 + 12 *3] ;
    [_colView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_photoLabel.mas_bottom).with.offset(0);
        make.left.equalTo(_scrollView.mas_left).with.offset(0);
        make.right.equalTo(_scrollView.mas_right).with.offset(0);
        make.height.equalTo(collectionH);
    }];
    
    [_photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_colView.mas_left).with.offset(0);
        make.right.equalTo(_colView.mas_right).with.offset(0);
        make.top.equalTo(_colView.mas_top).with.offset(0);
        make.bottom.equalTo(_colView.mas_bottom).with.offset(0);
        make.height.equalTo(collectionH);
    }];
    
    [_commodityView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_colView.mas_bottom).with.offset(5);
        make.left.equalTo(_scrollView.mas_left).with.offset(0);
        make.right.equalTo(_scrollView.mas_right).with.offset(0);
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
