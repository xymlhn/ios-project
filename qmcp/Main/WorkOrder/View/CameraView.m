//
//  CameraView.m
//  qmcp
//
//  Created by 谢永明 on 2016/11/28.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "CameraView.h"

@implementation CameraView

+ (instancetype)viewInstance{
    CameraView *cameraView = [CameraView new];
    
    return cameraView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.rowHeight = 90;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom).with.offset(kBottomHeight);
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
    
    _scanBtn = [UIButton new];
    [_scanBtn.layer setMasksToBounds:YES];
    [_scanBtn.layer setCornerRadius:kBottomButtonCorner];
    [_scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _scanBtn.titleLabel.font = [UIFont systemFontOfSize:kShisipt];
    [_scanBtn setTitle:@"扫一扫开启摄像头" forState:UIControlStateNormal];
    _scanBtn.backgroundColor = [UIColor appBlueColor];
    [bottomView addSubview:_scanBtn];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(kBottomHeight);
    }];
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(bottomView.mas_top).with.offset(0);
        make.left.equalTo(bottomView.mas_left).with.offset(0);
        make.right.equalTo(bottomView.mas_right).with.offset(0);
        make.height.mas_equalTo(kLineHeight);
    }];
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(bottomView);
        make.width.equalTo(@300);
        make.height.equalTo(@40);
    }];
}


@end
