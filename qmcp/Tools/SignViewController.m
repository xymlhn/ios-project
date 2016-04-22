//
//  SignViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/17.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SignViewController.h"
#import "PJRSignatureView.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"
#import "UIColor+Util.h"
@interface SignViewController ()

@property (nonatomic,strong) PJRSignatureView *signView;
@property (nonatomic,strong) UILabel *saveBtn;
@property (nonatomic,strong) UILabel *clearBtn;
@end

@implementation SignViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"签名";
    _signView = [[PJRSignatureView alloc] init];
    [self.view addSubview:_signView];
    
    [_signView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    [self initBottomView:self.view];
    [self bindListener];
}


-(void)initBottomView:(UIView *)rootView
{
    UIView *bottomView = [UIView new];
    
    [rootView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(rootView.mas_bottom).with.offset(0);
        make.left.equalTo(rootView.mas_left).with.offset(0);
        make.right.equalTo(rootView.mas_right).with.offset(0);
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
    
    
    _clearBtn = [UILabel new];
    [_clearBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _clearBtn.text = @"";
    _clearBtn.textColor = [UIColor nameColor];
    _clearBtn.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:_clearBtn];
    
    _saveBtn = [UILabel new];
    [_saveBtn setFont:[UIFont fontWithName:@"FontAwesome" size:30]];
    _saveBtn.text = @"";
    _saveBtn.textAlignment = NSTextAlignmentCenter;
    _saveBtn.textColor = [UIColor nameColor];
    [bottomView addSubview:_saveBtn];
    
    [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(bottomView.mas_left);
        make.centerY.equalTo(bottomView.mas_centerY);
        
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(bottomView.mas_right);
        make.left.equalTo(_clearBtn.mas_right);
        make.width.equalTo(_clearBtn.mas_width);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    
}

-(void)bindListener
{
    _clearBtn.userInteractionEnabled = YES;
    [_clearBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearBtnClick:)]];
    
    _saveBtn.userInteractionEnabled = YES;
    [_saveBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveBtnClick:)]];
}

- (void)clearBtnClick:(UITapGestureRecognizer *)recognizer
{
    [_signView clearSignature];
}

- (void)saveBtnClick:(UITapGestureRecognizer *)recognizer
{
    //调用代理对象的协议方法来实现数据传递
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(reportSignImage:)]) {
            UIImage *image = [_signView getSignatureImage];
            if(image){
                [self.delegate reportSignImage:image];
            }
        }
    });
    
}


@end
