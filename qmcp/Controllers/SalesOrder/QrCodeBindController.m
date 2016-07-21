//
//  QrCodeBindController.m
//  qmcp
//
//  Created by 谢永明 on 16/6/29.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "QrCodeBindController.h"
#import "QrCodeBindView.h"

@interface QrCodeBindController ()

@property (nonatomic,strong)QrCodeBindView *qrCodeBindView;

@end

@implementation QrCodeBindController


-(void)initView{
    _qrCodeBindView = [QrCodeBindView qrCodeBindViewInstance:self.view];
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

+(instancetype)doneBlock:(void (^)(NSString *))block{
    
    QrCodeBindController *vc = [[QrCodeBindController alloc] init];
    vc.doneBlock = block;
    return vc;
    
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
