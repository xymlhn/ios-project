//
//  AgreePeiceChangeController.m
//  qmcp
//
//  Created by 谢永明 on 2016/11/22.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderAgreePriceController.h"
#import "SalesOrderAgreePriceView.h"
@interface SalesOrderAgreePriceController ()
@property (nonatomic, strong) SalesOrderAgreePriceView *changeView;
@end

@implementation SalesOrderAgreePriceController

+(instancetype)doneBlock:(void (^)(NSString *, NSString *))block{
    SalesOrderAgreePriceController *vc = [SalesOrderAgreePriceController new];
    vc.doneBlock = block;
    return vc;
}

-(void)loadView{
    _changeView = [SalesOrderAgreePriceView viewInstance];
    self.view = _changeView;
    self.title = @"协议价修改";
}

-(void)bindListener{
    
    
    _changeView.saveBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self.navigationController popViewControllerAnimated:YES];
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

-(void)loadData{
    
}

@end
