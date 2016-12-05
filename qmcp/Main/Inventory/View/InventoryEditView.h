//
//  WorkOrderInventoryEditView.h
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface InventoryEditView : BaseView

@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic,strong) UIButton *qrBtn;
@property (nonatomic,strong) UITextField *qrText;
@property (nonatomic,strong) UIButton *lockBtn;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UILabel *goodNameLabel;
@property (nonatomic,strong) UITextField *goodNameText;
@property (nonatomic,strong) UIView *colView;
@property (nonatomic,strong) UILabel *remarkLabel;
@property (nonatomic,strong) UITextView *remarkText;

@property (nonatomic,strong) UILabel *photoLabel;
@property (nonatomic,strong) UIView *addBtn;
@property (nonatomic,strong) UILabel *addLabel;
@property (nonatomic,strong) UILabel *commodityLabel;
@property (nonatomic,strong) UIView *commodityBottomLine;

@property (nonatomic,strong)UIButton *delBtn;
@property (nonatomic,strong)UIButton *saveBtn;
+ (instancetype)viewInstance;
@end
