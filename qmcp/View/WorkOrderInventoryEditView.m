//
//  WorkOrderInventoryEditView.m
//  qmcp
//
//  Created by 谢永明 on 16/4/8.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "WorkOrderInventoryEditView.h"
#import "PhotoCell.h"
#import "CommodityCell.h"

@implementation WorkOrderInventoryEditView

+ (instancetype)viewInstance{
    WorkOrderInventoryEditView *workOrderInventoryEditView = [WorkOrderInventoryEditView new];
    return workOrderInventoryEditView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = [UIColor whiteColor];
   
    self.backgroundColor = [UIColor whiteColor];
    UIView *containView = [UIView new];
    [containView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self initTopView];
    [self initTableView];
    [self initBottomView];

    return self;
}



-(void)initTableView
{
    //创建布局对象
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    //flowlaout的属性，横向滑动
    flowLayout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _photoTableView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout1];
    _photoTableView.backgroundColor = [UIColor grayColor];
    [_photoTableView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_photoTableView];
    
    //创建布局对象
    UICollectionViewFlowLayout *flowLayout2 = [[UICollectionViewFlowLayout alloc] init];
    //flowlaout的属性，横向滑动
    flowLayout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _chooseTableView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout2];
    _chooseTableView.backgroundColor = [UIColor lightGrayColor];
    [_chooseTableView registerClass:[CommodityCell class] forCellWithReuseIdentifier:@"commodityCell"];
    [self addSubview:_chooseTableView];
    
    [_photoTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_chooseTableView.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(5);
        make.right.equalTo(self.mas_right).with.offset(-5);
        make.height.equalTo(@120);
    }];
    
    [_chooseTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_remarkTextView.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(5);
        make.right.equalTo(self.mas_right).with.offset(-5);
        make.height.equalTo(@200);
    }];
}

-(void)initTopView
{
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:15];//采用系统默认文字设置大小
    _titleLabel.text = @"12305";
    _titleLabel.textColor = [UIColor blackColor];
    [self addSubview:_titleLabel];
    
    _remarkTextView = [UITextField new];
    _remarkTextView.font = [UIFont systemFontOfSize:15];//
    _remarkTextView.textColor = [UIColor blackColor];
    _remarkTextView.placeholder=@"备注";
    _remarkTextView.borderStyle=UITextBorderStyleBezel;
    [self addSubview:_remarkTextView];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
    
    [_remarkTextView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
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
    
    _numberLabel = [UILabel new];
    _numberLabel.font = [UIFont systemFontOfSize:9];
    _numberLabel.layer.masksToBounds = YES;
    _numberLabel.backgroundColor = [UIColor redColor];
    _numberLabel.layer.cornerRadius = 7.5;
    _numberLabel.text = @"12";
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.textColor = [UIColor whiteColor];
    [self addSubview:_numberLabel];
    _carIcon = [UILabel new];
    [_carIcon setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _carIcon.text = @"";
    _carIcon.textColor = [UIColor nameColor];
    _carIcon.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_carIcon];
    
    _photoIcon = [UILabel new];
    [_photoIcon setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _photoIcon.text = @"";
    _photoIcon.textAlignment = NSTextAlignmentCenter;
    _photoIcon.textColor = [UIColor nameColor];
    [bottomView addSubview:_photoIcon];
    
    
    [_carIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(bottomView.mas_top).offset(3);
        make.left.equalTo(bottomView.mas_left);
        make.right.equalTo(_photoIcon.mas_left);
        make.width.equalTo(_photoIcon);
    }];
    
    [_photoIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(bottomView.mas_top).offset(3);
        make.right.equalTo(bottomView.mas_right);
        make.left.equalTo(_carIcon.mas_right);
        make.width.equalTo(_carIcon.mas_width);
    }];
    
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(@15);
        make.height.equalTo(@15);
        make.top.equalTo(_carIcon.mas_top).with.offset(0);
        make.centerX.equalTo(_carIcon.mas_centerX).with.offset(20);
    }];
    
}
@end
