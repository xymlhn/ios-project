//
//  QrCodeBindController.m
//  qmcp
//
//  Created by 谢永明 on 16/6/29.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "QrCodeImageController.h"
#import "QrCodeBindView.h"

@interface QrCodeImageController ()

@property (nonatomic,strong)QrCodeBindView *qrCodeBindView;

@end

@implementation QrCodeImageController

+(instancetype)doneBlock:(void (^)(NSString *))block{
    
    QrCodeImageController *vc = [[QrCodeImageController alloc] init];
    vc.doneBlock = block;
    return vc;
    
}

-(void)setupView{
    _qrCodeBindView = [QrCodeBindView viewInstance];
    self.view = _qrCodeBindView;
    _qrCodeBindView.qrCodeUrl = _qrCodeUrl;
}

-(void)bindListener{
    _qrCodeBindView.baseView.userInteractionEnabled = YES;
    [_qrCodeBindView.baseView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)]];
    
    _qrCodeBindView.confirmBtn.userInteractionEnabled = YES;
    [_qrCodeBindView.confirmBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmBtnClick)]];
    
    _qrCodeBindView.cancelBtn.userInteractionEnabled = YES;
    [_qrCodeBindView.cancelBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)]];
}

-(void)loadData{
    
}

- (void)dissmiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)confirmBtnClick{
    [self dissmiss];
    if (self.doneBlock) {
        self.doneBlock(_salesOrderCode);
    }
}

@end
