//
//  PickupView.m
//  qmcp
//
//  Created by 谢永明 on 16/7/1.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "PickupView.h"

@implementation PickupView

+ (instancetype)viewInstance{
    PickupView *pickupView = [PickupView new];
    return pickupView;
}


- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *containView = [UIView new];
    [containView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _headView = [UIView new];
    [_headView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_headView];
    [_headView setHidden:YES];
    _codeText = [UILabel new];
    _codeText.text = @"订单编号";
    _codeText.font = [UIFont systemFontOfSize:15];//采用系统默认文字设置大小
    _codeText.textColor = [UIColor blackColor];
    [_headView addSubview:_codeText];
    
    _nameText = [UILabel new];
    _nameText.text = @"客户名称";
    _nameText.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    _nameText.textColor = [UIColor blackColor];
    [_headView addSubview:_nameText];
    
    _phoneText = [UILabel new];
    _phoneText.text = @"联系电话";
    _phoneText.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    _phoneText.textColor = [UIColor blackColor];
    [_headView addSubview:_phoneText];
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [containView addSubview:topView];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [topView addSubview:codeBottomLine];
    
    _searchBar = [UISearchBar new];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [_searchBar setPlaceholder:@"请输入物品编号"];
    [topView addSubview:_searchBar];
    
    _qrButton = [UILabel new];
    [_qrButton setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _qrButton.text = @"";
    _qrButton.textColor = [UIColor nameColor];
    _qrButton.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:_qrButton];
    
    _tableView = [UITableView new];
    _tableView.rowHeight = 80;
    _tableView.backgroundColor = [UIColor whiteColor];
    [containView addSubview:_tableView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containView.mas_top).with.offset(5);
        make.left.equalTo(containView.mas_left);
        make.right.equalTo(containView.mas_right);
        make.height.equalTo(@50);
    }];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(topView.mas_bottom).with.offset(-3);
        make.left.equalTo(topView.mas_left).with.offset(0);
        make.right.equalTo(topView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    [_qrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(topView.mas_left).with.offset(5);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.equalTo(@30);
        make.height.equalTo(@40);
        
    }];
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_qrButton.mas_right).with.offset(0);
        make.right.equalTo(topView.mas_right).with.offset(5);
        make.centerY.equalTo(topView.mas_centerY).with.offset(-2);
        make.height.equalTo(@50);
    }];
    
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_searchBar.mas_bottom).with.offset(0);
        make.left.equalTo(containView.mas_left).with.offset(0);
        make.right.equalTo(containView.mas_right);
        make.height.equalTo(@40);
    }];
    
    [_codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_top).with.offset(5);
        make.centerX.equalTo(_headView.mas_centerX);
    }];
    
    
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeText.mas_bottom).with.offset(0);
        make.left.equalTo(_headView.mas_left).with.offset(15);
    }];
    
    
    [_phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_codeText.mas_bottom).with.offset(0);
        make.left.equalTo(_headView.mas_centerX).with.offset(15);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.equalTo(containView.mas_left).with.offset(0);
        make.right.equalTo(containView.mas_right).with.offset(0);
        make.top.equalTo(_headView.mas_bottom).with.offset(0);
        make.bottom.equalTo(containView.mas_bottom).with.offset(0);
    }];
    
    [self setupBottomView];
    return self;
}

//底部按钮
-(void)setupBottomView{
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor lineColor];
    [bottomView addSubview:codeBottomLine];
    
    _signBtn = [UIButton new];
    [_signBtn.layer setMasksToBounds:YES];
    [_signBtn.layer setCornerRadius:3.0];
    [_signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signBtn.titleLabel.font = [UIFont systemFontOfSize:kShisipt];
    [_signBtn setTitle:@"签名" forState:UIControlStateNormal];
    _signBtn.backgroundColor = [UIColor appBlueColor];
    [bottomView addSubview:_signBtn];
    
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
    [_signBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(bottomView);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
    }];
}


@end
