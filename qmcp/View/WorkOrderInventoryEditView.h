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

@property (nonatomic, strong) UICollectionView *chooseTableView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UITextField *remarkTextView;;

@property (nonatomic,strong) UILabel *numberLabel;

@property (nonatomic,strong) UILabel *carIcon;
@property (nonatomic,strong) UILabel *photoIcon;
@end
