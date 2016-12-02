//
//  CameraView.m
//  qmcp
//
//  Created by 谢永明 on 2016/11/28.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "CameraView.h"

@interface CameraView()
@property (nonatomic,strong) UILabel *midLabel;
@property (nonatomic,strong) UIView *cameraView;
@property (nonatomic,strong) UILabel *topLabel;
@property (nonatomic,strong) UILabel *cameraIcon;
@property (nonatomic,strong) UIView *line;

@end

@implementation CameraView

+ (instancetype)viewInstance{
    CameraView *cameraView = [CameraView new];
    
    return cameraView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    [self setupView];
    
    [self setupBottomView];
    return self;
    
}

-(void)setupView{

    _topLabel = [UILabel new];
    _topLabel.textAlignment = NSTextAlignmentCenter;
    _topLabel.font = [UIFont systemFontOfSize:kShisipt];
    _topLabel.text = @"正在使用的摄像头";
    _topLabel.textColor = [UIColor mainTextColor];
    [self addSubview:_topLabel];
    
    _cameraView= [UIView new];
    _cameraView.userInteractionEnabled = YES;
    _cameraView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_cameraView];
    
    _line = [UIView new];
    _line.backgroundColor = [UIColor lineColor];
    [_cameraView addSubview:_line];
    
    _cameraIcon = [UILabel new];
    [_cameraIcon setFont:[UIFont fontWithName:@"FontAwesome" size:25]];
    _cameraIcon.text = @"";
    _cameraIcon.textColor = [UIColor nameColor];
    [_cameraView addSubview:_cameraIcon];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:kShiwupt];
    _nameLabel.text = @"12305";
    _nameLabel.textColor = [UIColor blackColor];
    [_cameraView addSubview:_nameLabel];
    
    _switchBtn = [UIButton new];
    _switchBtn.backgroundColor = [UIColor appBlueColor];
    [_switchBtn setTitle:@"关闭" forState:UIControlStateNormal];
    _switchBtn.tintColor = [UIColor whiteColor];
    [_switchBtn.layer setMasksToBounds:YES];
    [_switchBtn.layer setCornerRadius:kBottomButtonCorner];
    _switchBtn.titleLabel.font = [UIFont systemFontOfSize:kShisipt];
    [_cameraView addSubview:_switchBtn];
    
    _midLabel = [UILabel new];
    _midLabel.textAlignment = NSTextAlignmentCenter;
    _midLabel.font = [UIFont systemFontOfSize:kShisipt];
    _midLabel.text = @"摄像头列表";
    _midLabel.textColor = [UIColor mainTextColor];
    [self addSubview:_midLabel];
    
    _tableView = [UITableView new];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.rowHeight = 60;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tableView];
    
    
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.height.equalTo(@35);
    }];
    
    [_cameraView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_topLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@90);
    }];
    
    [_cameraIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_cameraView.mas_centerY);
        make.left.equalTo(_cameraView.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_cameraView.mas_centerY);
        make.left.equalTo(_cameraIcon.mas_right).with.offset(25);
    }];
    
    [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel.mas_centerY);
        make.width.equalTo(@73);
        make.height.equalTo(@33);
        make.right.equalTo(_cameraView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_cameraView.mas_bottom).with.offset(0);
        make.left.equalTo(_cameraView.mas_left).with.offset(0);
        make.right.equalTo(_cameraView.mas_right).with.offset(0);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    [_midLabel mas_updateConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
        make.height.equalTo(@35);
    }];
    
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_midLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-kBottomHeight);
    }];
    [_cameraView setHidden:YES];
    [_topLabel setHidden:YES];
    [_cameraIcon setHidden:YES];
    [_nameLabel setHidden:YES];
    [_line setHidden:YES];
    
}

-(void)updateConstraints:(BOOL)show{
    if (show) {
        [_midLabel mas_updateConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.mas_top).with.offset(125);
            make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
            make.height.equalTo(@35);
        }];
        
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(_midLabel.mas_bottom).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(0);
            make.bottom.equalTo(self.mas_bottom).with.offset(-kBottomHeight);
        }];
        [_cameraView setHidden:NO];
        [_topLabel setHidden:NO];
        [_cameraIcon setHidden:NO];
        [_nameLabel setHidden:NO];
        [_line setHidden:NO];
    }else{
        [_midLabel mas_updateConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(kPaddingLeftWidth);
            make.height.equalTo(@35);
        }];
        
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(_midLabel.mas_bottom).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(0);
            make.bottom.equalTo(self.mas_bottom).with.offset(-kBottomHeight);
        }];
        [_cameraView setHidden:YES];
        [_topLabel setHidden:YES];
        [_cameraIcon setHidden:YES];
        [_nameLabel setHidden:YES];
        [_line setHidden:YES];
    }
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
