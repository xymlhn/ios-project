//
//  MeView.m
//  qmcp
//
//  Created by 谢永明 on kFontAwesomeIcon16/10/21.
//  Copyright © kFontAwesomeIcon16年 inforshare. All rights reserved.
//

#import "MeView.h"
@implementation MeView

+ (instancetype)viewInstance{
    MeView *loginView = [MeView new];
    return loginView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = [UIColor themeColor];
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"me_background"]];
    [self addSubview:topView];
    
    _userIcon = [UIImageView new];
    _userIcon.layer.masksToBounds = YES;
    _userIcon.layer.cornerRadius = 30;
    _userIcon.image = [UIImage imageNamed:@"default－portrait"];
    [self addSubview:_userIcon];
    
    _nickName = [UILabel new];
    _nickName.text = @"fuck";
    _nickName.textAlignment = NSTextAlignmentCenter;
    _nickName.font = [UIFont systemFontOfSize:kShiwupt];
    _nickName.textColor = [UIColor whiteColor];
    [topView addSubview:_nickName];
    
    UIView *editView = [UIView new];
     editView.backgroundColor = [UIColor whiteColor];
    editView.layer.masksToBounds = YES;
    editView.layer.cornerRadius = 10;
    [self addSubview:editView];
    
    UILabel *editLabel = [UILabel new];
    editLabel.font = [UIFont systemFontOfSize:kShierpt];
    editLabel.text = @"编辑信息";
    editLabel.textAlignment = NSTextAlignmentCenter;
    editLabel.textColor = [UIColor appBlueColor];
    [editView addSubview:editLabel];
    
    UILabel *editArrow = [UILabel new];
    [editArrow setFont:[UIFont fontWithName:@"FontAwesome" size:kFontAwesomeArrow]];
    editArrow.text = @"";
    editArrow.textAlignment = NSTextAlignmentCenter;
    editArrow.textColor = [UIColor appBlueColor];
    [editView addSubview:editArrow];
    
    //上班
    UIView *workView = [UIView new];
    workView.backgroundColor = [UIColor whiteColor];
    [self addSubview:workView];
    
    UILabel *workText = [UILabel new];
    workText.font = [UIFont systemFontOfSize:kShisipt];
    workText.text = @"上班";
    workText.textColor = [UIColor mainTextColor];
    [workView addSubview:workText];
    
    UILabel *workIcon = [UILabel new];
    [workIcon setFont:[UIFont fontWithName:@"FontAwesome" size:kFontAwesomeIcon]];
    workIcon.text = @"";
    workIcon.textAlignment = NSTextAlignmentCenter;
    workIcon.textColor = [UIColor appBlueColor];
    [workView addSubview:workIcon];
    
    _workSwitch = [UISwitch new];
    [workView addSubview:_workSwitch];
    
    UIView *workLine = [UIView new];
    workLine.backgroundColor = [UIColor lineColor];
    [workView addSubview:workLine];
    
    //地图
    _mapBtn = [UIView new];
    _mapBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:_mapBtn];
    
    UILabel *mapIcon = [UILabel new];
    [mapIcon setFont:[UIFont fontWithName:@"FontAwesome" size:kFontAwesomeIcon]];
    mapIcon.text = @"";
    mapIcon.textAlignment = NSTextAlignmentCenter;
    mapIcon.textColor = [UIColor appBlueColor];
    [_mapBtn addSubview:mapIcon];
    
    UILabel *mapText = [UILabel new];
    mapText.font = [UIFont systemFontOfSize:kShisipt];
    mapText.text = @"地图";
    mapText.textColor = [UIColor mainTextColor];
    [_mapBtn addSubview:mapText];
    
    UILabel *mapArrow = [UILabel new];
    [mapArrow setFont:[UIFont fontWithName:@"FontAwesome" size:kFontAwesomeArrow]];
    mapArrow.text = @"";
    mapArrow.textAlignment = NSTextAlignmentCenter;
    mapArrow.textColor = [UIColor arrowColor];
    [_mapBtn addSubview:mapArrow];
    
    UIView *mapLine = [UIView new];
    mapLine.backgroundColor = [UIColor lineColor];
    [_mapBtn addSubview:mapLine];
    
    //帮助
    _helpBtn = [UIView new];
    _helpBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:_helpBtn];
    
    UILabel *helpIcon = [UILabel new];
    [helpIcon setFont:[UIFont fontWithName:@"FontAwesome" size:kFontAwesomeIcon]];
    helpIcon.text = @"";
    helpIcon.textAlignment = NSTextAlignmentCenter;
    helpIcon.textColor = [UIColor appBlueColor];
    [_helpBtn addSubview:helpIcon];
    
    UILabel *helpText = [UILabel new];
    helpText.font = [UIFont systemFontOfSize:kShisipt];
    helpText.text = @"帮助";
    helpText.textColor = [UIColor mainTextColor];
    [_helpBtn addSubview:helpText];
    
    UILabel *helpArrow = [UILabel new];
    [helpArrow setFont:[UIFont fontWithName:@"FontAwesome" size:kFontAwesomeArrow]];
    helpArrow.text = @"";
    helpArrow.textAlignment = NSTextAlignmentCenter;
    helpArrow.textColor = [UIColor arrowColor];
    [_helpBtn addSubview:helpArrow];
    
    //设置
    _settingBtn = [UIView new];
    _settingBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:_settingBtn];
    
    UILabel *settingIcon = [UILabel new];
    [settingIcon setFont:[UIFont fontWithName:@"FontAwesome" size:kFontAwesomeIcon]];
    settingIcon.text = @"";
    settingIcon.textAlignment = NSTextAlignmentCenter;
    settingIcon.textColor = [UIColor appBlueColor];
    [_settingBtn addSubview:settingIcon];
    
    UILabel *settingText = [UILabel new];
    settingText.font = [UIFont systemFontOfSize:kShisipt];
    settingText.text = @"设置";
    settingText.textColor = [UIColor mainTextColor];
    [_settingBtn addSubview:settingText];
    
    UILabel *settingArrow = [UILabel new];
    [settingArrow setFont:[UIFont fontWithName:@"FontAwesome" size:kFontAwesomeArrow]];
    settingArrow.text = @"";
    settingArrow.textAlignment = NSTextAlignmentCenter;
    settingArrow.textColor = [UIColor arrowColor];
    [_settingBtn addSubview:settingArrow];
    
    UIView *settingLine = [UIView new];
    settingLine.backgroundColor = [UIColor lineColor];
    [_settingBtn addSubview:settingLine];
    
    //登出
    _logoutBtn = [UIView new];
    _logoutBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:_logoutBtn];
    
    UILabel *logoutIcon = [UILabel new];
    [logoutIcon setFont:[UIFont fontWithName:@"FontAwesome" size:kFontAwesomeIcon]];
    logoutIcon.text = @"";
    logoutIcon.textAlignment = NSTextAlignmentCenter;
    logoutIcon.textColor = [UIColor appBlueColor];
    [_logoutBtn addSubview:logoutIcon];
    
    UILabel *logoutText = [UILabel new];
    logoutText.font = [UIFont systemFontOfSize:kShisipt];
    logoutText.text = @"退出";
    logoutText.textColor = [UIColor mainTextColor];
    [_logoutBtn addSubview:logoutText];
    
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@150);
    }];
    
    [_userIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(topView.mas_top).with.offset(16);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(_userIcon.mas_bottom).with.offset(10);
        make.width.equalTo(@55);
    }];
    
    [editView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_nickName.mas_bottom).with.offset(10);
        make.centerX.equalTo(topView.mas_centerX);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@80);
    }];
    
    [editLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(editView.mas_centerX).with.offset(-3);
        make.centerY.equalTo(editView.mas_centerY);
    }];
    
    [editArrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(editView.mas_centerY);
        make.right.equalTo(editView.mas_right).with.offset(-6);
        make.width.equalTo(@6);
    }];
    
    //上班
    [workView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(topView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    [workIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(workView.mas_centerY);
        make.left.equalTo(workView.mas_left).with.offset(kMePaddingWidth);
        make.width.equalTo(@20);
    }];
    
    [workText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(workView.mas_centerY);
        make.left.equalTo(workIcon.mas_right).with.offset(kPaddingLeftWidth*2);
        make.width.equalTo(@50);
    }];
    
    [_workSwitch mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(workView.mas_centerY);
        make.right.equalTo(workView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
    
    [workLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(workView.mas_bottom).with.offset(0);
        make.left.equalTo(workView.mas_left).with.offset(10);
        make.right.equalTo(workView.mas_right).with.offset(0);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    //地图
    [_mapBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(workView.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    [mapIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_mapBtn.mas_centerY);
        make.left.equalTo(_mapBtn.mas_left).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@20);
    }];
    
    [mapText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_mapBtn.mas_centerY);
        make.left.equalTo(mapIcon.mas_right).with.offset(kPaddingLeftWidth*2);
        make.width.equalTo(@50);
    }];
    
    [mapArrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_mapBtn.mas_centerY);
        make.right.equalTo(_mapBtn.mas_right).with.offset(-26);
    }];
    
    [mapLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_mapBtn.mas_bottom).with.offset(0);
        make.left.equalTo(_mapBtn.mas_left).with.offset(10);
        make.right.equalTo(_mapBtn.mas_right).with.offset(0);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    //帮助
    [_helpBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_mapBtn.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    [helpIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_helpBtn.mas_centerY);
        make.left.equalTo(_helpBtn.mas_left).with.offset(kMePaddingWidth);
        make.width.equalTo(@20);
    }];
    
    [helpText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_helpBtn.mas_centerY);
        make.left.equalTo(helpIcon.mas_right).with.offset(kPaddingLeftWidth*2);
        make.width.equalTo(@50);
    }];
    
    [helpArrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_helpBtn.mas_centerY);
        make.right.equalTo(_helpBtn.mas_right).with.offset(-26);
    }];
    
    //设置
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_helpBtn.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    [settingIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_settingBtn.mas_centerY);
        make.left.equalTo(_settingBtn.mas_left).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@20);
    }];
    
    [settingText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_settingBtn.mas_centerY);
        make.left.equalTo(mapIcon.mas_right).with.offset(kPaddingLeftWidth *2);
        make.width.equalTo(@50);
    }];
    
    [settingArrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_settingBtn.mas_centerY);
        make.right.equalTo(_settingBtn.mas_right).with.offset(-26);
    }];
    
    [settingLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(_settingBtn.mas_bottom).with.offset(0);
        make.left.equalTo(_settingBtn.mas_left).with.offset(10);
        make.right.equalTo(_settingBtn.mas_right).with.offset(0);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    //退出
    [_logoutBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_settingBtn.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    
    [logoutIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_logoutBtn.mas_centerY);
        make.left.equalTo(_logoutBtn.mas_left).with.offset(kMePaddingWidth);
        make.width.equalTo(@20);
    }];
    
    [logoutText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_logoutBtn.mas_centerY);
        make.left.equalTo(logoutIcon.mas_right).with.offset(kPaddingLeftWidth*2);
        make.width.equalTo(@50);
    }];
    return self;
}


@end
