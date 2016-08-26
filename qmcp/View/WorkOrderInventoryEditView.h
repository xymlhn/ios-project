//
//  WorkOrderInventoryEditView.h
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface WorkOrderInventoryEditView : BaseView

@property (nonatomic, strong) UICollectionView *photoTableView;
@property (nonatomic,strong) UIButton *qrBtn;
@property (nonatomic,strong) UITextField *qrText;
@property (nonatomic,strong) UILabel *lockIcon;

@property (nonatomic,strong) UILabel *goodNameLabel;
@property (nonatomic,strong) UITextField *goodNameText;

@property (nonatomic,strong) UILabel *remarkLabel;
@property (nonatomic,strong) UITextField *remarkText;

@property (nonatomic,strong) UILabel *photoIcon;
@property (nonatomic,strong) UILabel *photoLabel;

@property (nonatomic,strong) UILabel *commodityLeftIcon;
@property (nonatomic,strong) UILabel *commodityRightIcon;
@property (nonatomic,strong) UILabel *commodityLabel;



+ (instancetype)viewInstance;
@end
