//
//  MeView.m
//  qmcp
//
//  Created by 谢永明 on 2016/10/21.
//  Copyright © 2016年 inforshare. All rights reserved.
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
    self.backgroundColor = [UIColor grayColor];
    
    UIView *topView = [UIView new];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    _userIcon = [UIImageView new];
    _userIcon.image = [UIImage imageNamed:@"default－portrait"];
    [self addSubview:_userIcon];
    
    _nickName = [UILabel new];
    _nickName.text = @"fuck";
    [topView addSubview:_nickName];
    
    UILabel *topArrow = [UILabel new];
    [topArrow setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    topArrow.text = @"";
    topArrow.textAlignment = NSTextAlignmentCenter;
    topArrow.textColor = [UIColor blackColor];
    [topView addSubview:topArrow];
    
    //上班
    UIView *workView = [UIView new];
    workView.backgroundColor = [UIColor whiteColor];
    [self addSubview:workView];
    
    UILabel *workText = [UILabel new];
    workText.font = [UIFont systemFontOfSize:12];
    workText.text = @"上班";
    workText.textColor = [UIColor blackColor];
    [workView addSubview:workText];

    UILabel *workIcon = [UILabel new];
    [workIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    workIcon.text = @"";
    workIcon.textAlignment = NSTextAlignmentCenter;
    workIcon.textColor = [UIColor blueColor];
    [workView addSubview:workIcon];
    
    _workSwitch = [UISwitch new];
    [workView addSubview:_workSwitch];
    
    UIView *workLine = [UIView new];
    workLine.backgroundColor = [UIColor grayColor];
    [workView addSubview:workLine];
    
    //地图
    _mapBtn = [UIView new];
    _mapBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:_mapBtn];
    
    UILabel *mapIcon = [UILabel new];
    [mapIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    mapIcon.text = @"";
    mapIcon.textAlignment = NSTextAlignmentCenter;
    mapIcon.textColor = [UIColor blueColor];
    [_mapBtn addSubview:mapIcon];
    
    UILabel *mapText = [UILabel new];
    mapText.font = [UIFont systemFontOfSize:12];
    mapText.text = @"地图";
    mapText.textColor = [UIColor blackColor];
    [_mapBtn addSubview:mapText];
    
    UILabel *mapArrow = [UILabel new];
    [mapArrow setFont:[UIFont fontWithName:@"FontAwesome" size:15]];
    mapArrow.text = @"";
    mapArrow.textAlignment = NSTextAlignmentCenter;
    mapArrow.textColor = [UIColor blackColor];
    [_mapBtn addSubview:mapArrow];
    
    UIView *mapLine = [UIView new];
    mapLine.backgroundColor = [UIColor grayColor];
    [_mapBtn addSubview:mapLine];
    
    //帮助
    _helpBtn = [UIView new];
    _helpBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:_helpBtn];
    
    UILabel *helpIcon = [UILabel new];
    [helpIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    helpIcon.text = @"";
    helpIcon.textAlignment = NSTextAlignmentCenter;
    helpIcon.textColor = [UIColor blueColor];
    [_helpBtn addSubview:helpIcon];
    
    UILabel *helpText = [UILabel new];
    helpText.font = [UIFont systemFontOfSize:12];
    helpText.text = @"帮助";
    helpText.textColor = [UIColor blackColor];
    [_helpBtn addSubview:helpText];
    
    UILabel *helpArrow = [UILabel new];
    [helpArrow setFont:[UIFont fontWithName:@"FontAwesome" size:15]];
    helpArrow.text = @"";
    helpArrow.textAlignment = NSTextAlignmentCenter;
    helpArrow.textColor = [UIColor blackColor];
    [_helpBtn addSubview:helpArrow];
    
    //设置
    _settingBtn = [UIView new];
    _settingBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:_settingBtn];
    
    UILabel *settingIcon = [UILabel new];
    [settingIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    settingIcon.text = @"";
    settingIcon.textAlignment = NSTextAlignmentCenter;
    settingIcon.textColor = [UIColor blueColor];
    [_settingBtn addSubview:settingIcon];
    
    UILabel *settingText = [UILabel new];
    settingText.font = [UIFont systemFontOfSize:12];
    settingText.text = @"设置";
    settingText.textColor = [UIColor blackColor];
    [_settingBtn addSubview:settingText];
    
    UILabel *settingArrow = [UILabel new];
    [settingArrow setFont:[UIFont fontWithName:@"FontAwesome" size:15]];
    settingArrow.text = @"";
    settingArrow.textAlignment = NSTextAlignmentCenter;
    settingArrow.textColor = [UIColor blackColor];
    [_settingBtn addSubview:settingArrow];
    
    UIView *settingLine = [UIView new];
    settingLine.backgroundColor = [UIColor grayColor];
    [_settingBtn addSubview:settingLine];
    
    //登出
    _logoutBtn = [UIView new];
    _logoutBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:_logoutBtn];
    
    UILabel *logoutIcon = [UILabel new];
    [logoutIcon setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    logoutIcon.text = @"";
    logoutIcon.textAlignment = NSTextAlignmentCenter;
    logoutIcon.textColor = [UIColor blueColor];
    [_logoutBtn addSubview:logoutIcon];
    
    UILabel *logoutText = [UILabel new];
    logoutText.font = [UIFont systemFontOfSize:12];
    logoutText.text = @"退出";
    logoutText.textColor = [UIColor blackColor];
    [_logoutBtn addSubview:logoutText];
    
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@80);
    }];
    
    [_userIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(topView.mas_left).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(_userIcon.mas_right).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@120);
    }];
    
    [topArrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(topView.mas_centerY);
        make.right.equalTo(topView.mas_right).with.offset(-kPaddingLeftWidth);
    }];
    
    //上班
    [workView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(topView.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@45);
    }];
    
    [workIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(workView.mas_centerY);
        make.left.equalTo(workView.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    [workText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(workView.mas_centerY);
        make.left.equalTo(workIcon.mas_right).with.offset(kPaddingLeftWidth);
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
        make.height.mas_equalTo(@45);
    }];
    
    [mapIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_mapBtn.mas_centerY);
        make.left.equalTo(_mapBtn.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    [mapText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_mapBtn.mas_centerY);
        make.left.equalTo(mapIcon.mas_right).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@50);
    }];
    
    [mapArrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_mapBtn.mas_centerY);
        make.right.equalTo(_mapBtn.mas_right).with.offset(-kPaddingLeftWidth);
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
        make.height.mas_equalTo(@45);
    }];
    
    [helpIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_helpBtn.mas_centerY);
        make.left.equalTo(_helpBtn.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    [helpText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_helpBtn.mas_centerY);
        make.left.equalTo(helpIcon.mas_right).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@50);
    }];
    
    [helpArrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_helpBtn.mas_centerY);
        make.right.equalTo(_helpBtn.mas_right).with.offset(-kPaddingLeftWidth);
    }];
    
    //设置
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_helpBtn.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@45);
    }];
    
    [settingIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_settingBtn.mas_centerY);
        make.left.equalTo(_settingBtn.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    [settingText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_settingBtn.mas_centerY);
        make.left.equalTo(mapIcon.mas_right).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@50);
    }];
    
    [settingArrow mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_settingBtn.mas_centerY);
        make.right.equalTo(_settingBtn.mas_right).with.offset(-kPaddingLeftWidth);
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
        make.height.mas_equalTo(@45);
    }];
    
    [logoutIcon mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_logoutBtn.mas_centerY);
        make.left.equalTo(_logoutBtn.mas_left).with.offset(kPaddingLeftWidth);
    }];
    
    [logoutText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(_logoutBtn.mas_centerY);
        make.left.equalTo(logoutIcon.mas_right).with.offset(kPaddingLeftWidth);
        make.width.equalTo(@50);
    }];
    return self;
}


@end
