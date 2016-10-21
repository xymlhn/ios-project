//
//  MeView.h
//  qmcp
//
//  Created by 谢永明 on 2016/10/21.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseView.h"

@interface MeView : BaseView

@property (nonatomic,strong) UIImageView *userIcon;
@property (nonatomic,strong) UILabel *nickName;
@property (nonatomic,strong) UIView *mapBtn;
@property (nonatomic,strong) UIView *helpBtn;
@property (nonatomic,strong) UIView *settingBtn;
@property (nonatomic,strong) UIView *logoutBtn;
@property (nonatomic,strong) UISwitch *workSwitch;
+ (instancetype)viewInstance;
@end
