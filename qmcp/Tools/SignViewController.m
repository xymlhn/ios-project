//
//  SignViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/17.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SignViewController.h"

#import "ReactiveCocoa.h"
#import "UIColor+Util.h"
#import "SignView.h"
@interface SignViewController ()

@property (nonatomic,strong) SignView *signView;

@end

@implementation SignViewController

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"签名";
    _signView = [SignView new];
    [_signView initView:self.view];
}

-(void)loadData{
    
}


-(void)bindListener
{
    _signView.clearBtn.userInteractionEnabled = YES;
    [_signView.clearBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearBtnClick:)]];
    
    _signView.saveBtn.userInteractionEnabled = YES;
    [_signView.saveBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveBtnClick:)]];
    
    _signView.cancelBtn.userInteractionEnabled = YES;
    [_signView.cancelBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelBtnClick:)]];
}

- (void)cancelBtnClick:(UITapGestureRecognizer *)recognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clearBtnClick:(UITapGestureRecognizer *)recognizer
{
    [_signView.signatureView clearSignature];
}

- (void)saveBtnClick:(UITapGestureRecognizer *)recognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.doneBlock) {
            UIImage *image = [_signView.signatureView getSignatureImage];
            if(image){
                self.doneBlock(image);
            }
        }
    });

}
+(instancetype)doneBlock:(void (^)(UIImage *))block{
    
    SignViewController *vc = [[SignViewController alloc] init];
    vc.doneBlock = block;
    return vc;
    
}

-(BOOL)shouldAutorotate{
    return NO;
}

//当前viewcontroller默认的屏幕方向 - 横屏显示
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}
@end
