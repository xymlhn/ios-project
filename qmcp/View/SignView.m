//
//  SignView.m
//  qmcp
//
//  Created by 谢永明 on 16/7/4.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SignView.h"

@implementation SignView

+ (instancetype)signViewInstance{
    SignView *signView = [SignView new];
    return signView;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    _signatureView = [[PJRSignatureView alloc] init];
    [self addSubview:_signatureView];
    
    [_signatureView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self);
    }];
    
    [self initBottomView];
    return self;
}

-(void)initBottomView
{
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UIView *codeBottomLine = [UIView new];
    codeBottomLine.backgroundColor = [UIColor grayColor];
    [bottomView addSubview:codeBottomLine];
    
    _clearBtn = [UILabel new];
    [_clearBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _clearBtn.text = @"";
    _clearBtn.textColor = [UIColor nameColor];
    _clearBtn.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_clearBtn];
    
    UILabel *clearLabel = [UILabel new];
    clearLabel.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    clearLabel.text = @"清除";
    clearLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:clearLabel];
    
    _cancelBtn = [UILabel new];
    [_cancelBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _cancelBtn.text = @"";
    _cancelBtn.textColor = [UIColor nameColor];
    _cancelBtn.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_cancelBtn];
    
    UILabel *cancelLabel = [UILabel new];
    cancelLabel.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    cancelLabel.text = @"返回";
    cancelLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:cancelLabel];
    
    _saveBtn = [UILabel new];
    [_saveBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _saveBtn.text = @"";
    _saveBtn.textAlignment = NSTextAlignmentCenter;
    _saveBtn.textColor = [UIColor nameColor];
    [bottomView addSubview:_saveBtn];
    
    UILabel *saveLabel = [UILabel new];
    saveLabel.font = [UIFont systemFontOfSize:12];//采用系统默认文字设置大小
    saveLabel.text = @"保存";
    saveLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:saveLabel];
    

    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(@50);
    }];
    
    [codeBottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(bottomView.mas_top).with.offset(0);
        make.left.equalTo(bottomView.mas_left).with.offset(0);
        make.right.equalTo(bottomView.mas_right).with.offset(0);
        make.height.mas_equalTo(@1);
    }];
    
    [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(bottomView).with.offset(0);
        make.width.equalTo(_cancelBtn);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    
    [cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cancelBtn.mas_bottom);
        make.centerX.equalTo(_cancelBtn.mas_centerX);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_clearBtn.mas_right);
        make.width.equalTo(_clearBtn);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];
    
    [clearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_clearBtn.mas_bottom);
        make.centerX.equalTo(_clearBtn.mas_centerX);
    }];
    
    
    [saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_saveBtn.mas_bottom);
        make.centerX.equalTo(_saveBtn.mas_centerX);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(_cancelBtn);
        make.left.equalTo(_cancelBtn.mas_right);
        make.right.equalTo(bottomView.mas_right);
        make.top.equalTo(bottomView.mas_top).offset(3);
    }];

}
@end
