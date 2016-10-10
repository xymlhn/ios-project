//
//  ScanViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "ScanViewController.h"
#import "ReactiveCocoa.h"
#import "ScanView.h"
@interface ScanViewController ()

@property(nonatomic,strong) ScanView *scanView;

@end

@implementation ScanViewController


-(void)loadData{
    
}

-(void)loadView{
    self.title = @"快速输入";
    _scanView = [ScanView viewInstance];
    self.view = _scanView;
}
-(void)bindListener{
    _scanView.scanBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input)
                            {
                                [_scanView.scanText resignFirstResponder];
                                [self.navigationController popViewControllerAnimated:YES];
                                if (self.doneBlock) {
                                    self.doneBlock(_scanView.scanText.text);
                                }
                                
                                return [RACSignal empty];
                            }];
    
    RACSignal *validSignal = [_scanView.scanText.rac_textSignal
                              map:^id(NSString *text) {
                                  return @([Utils isTextNull:text]);
                              }];
    
    [validSignal subscribeNext:^(NSNumber*signupActive){
        _scanView.scanBtn.backgroundColor = [signupActive boolValue] ? [UIColor nameColor] : [UIColor grayColor];
        _scanView.scanBtn.enabled =[signupActive boolValue];
    }];
    
    [_scanView.scanText addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)returnOnKeyboard:(UITextField *)sender
{
    [_scanView.scanText resignFirstResponder];
    if(_scanView.scanText.text.length > 0){
        [self.navigationController popViewControllerAnimated:YES];
        if (self.doneBlock) {
            self.doneBlock(_scanView.scanText.text);
        }
    }
    
}


+(instancetype)doneBlock:(void (^)(NSString *))block{
    
    ScanViewController *vc = [[ScanViewController alloc] init];
    vc.doneBlock = block;
    return vc;
    
}
@end
