//
//  WorkOrderStepEditView.h
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface WorkOrderStepEditView : BaseView

@property (nonatomic,strong) UILabel *titleText;
@property (nonatomic,strong) UITextView *editText;
@property (nonatomic,strong) UILabel *alwaysBtn;;
@property (nonatomic,strong) UILabel *photoBtn;
@property (nonatomic,strong) UILabel *saveBtn;
@property (nonatomic,strong) UILabel *delBtn;
@property (nonatomic,strong) UIView *containView;

@property (nonatomic, strong) UICollectionView *collectionView;

+ (instancetype)workOrderStepEditViewInstance:(UIView *)view;
@end
