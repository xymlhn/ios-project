//
//  QrCodeIdentityController.m
//  qmcp
//
//  Created by 谢永明 on 16/7/3.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "QrCodeIdentityController.h"
#import "QrCodeIdentityView.h"

@interface QrCodeIdentityController()
@property (nonatomic,strong)QrCodeIdentityView *qrCodeIdentityView;
@end

@implementation QrCodeIdentityController
-(void)loadView{
    _qrCodeIdentityView = [QrCodeIdentityView viewInstance];
    self.view = _qrCodeIdentityView;
    _qrCodeIdentityView.qrCodeUrl = _qrCodeUrl;
}

-(void)bindListener{
    _qrCodeIdentityView.baseView.userInteractionEnabled = YES;
    [_qrCodeIdentityView.baseView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)]];
    
    _qrCodeIdentityView.confirmBtn.userInteractionEnabled = YES;
    [_qrCodeIdentityView.confirmBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)]];
    
}

-(void)loadData{
    
}

- (void)dissmiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
