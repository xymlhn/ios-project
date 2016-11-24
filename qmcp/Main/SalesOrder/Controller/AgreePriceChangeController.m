//
//  AgreePeiceChangeController.m
//  qmcp
//
//  Created by 谢永明 on 2016/11/22.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "AgreePriceChangeController.h"
#import "AgreePriceChangeView.h"
@interface AgreePriceChangeController ()
@property (nonatomic, strong) AgreePriceChangeView *changeView;
@end

@implementation AgreePriceChangeController

-(void)loadView{
    _changeView = [AgreePriceChangeView viewInstance];
    self.view = _changeView;
}

-(void)bindListener{
    
    _changeView.baseView.userInteractionEnabled = YES;
    [_changeView.baseView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)]];
    _changeView.cancelBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self dissmiss];
        return [RACSignal empty];
    }];
    
    _changeView.saveBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self dissmiss];
        if (self.doneBlock) {
            self.doneBlock(_changeView.priceText.text,_changeView.remarkText.text);
        }
        return [RACSignal empty];
    }];
    
    
    RACSignal *validRemarkSignal = [_changeView.remarkText.rac_textSignal
                                    map:^id(NSString *text) {
                                        return @(text.length > 0);
                                    }];
    [validRemarkSignal subscribeNext:^(NSNumber*signupActive){
        _changeView.saveBtn.backgroundColor = [signupActive boolValue] ? [UIColor nameColor] : [UIColor grayColor];
        _changeView.saveBtn.enabled = [signupActive boolValue];
    }];
}


- (void)dissmiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadData{
    
}

+(instancetype)doneBlock:(void (^)(NSString *, NSString *))block{
    AgreePriceChangeController *vc = [AgreePriceChangeController new];
    vc.doneBlock = block;
    return vc;
}

@end
