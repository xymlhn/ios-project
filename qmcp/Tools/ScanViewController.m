//
//  ScanViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "ScanViewController.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"
#import "UIColor+Util.h"
@interface ScanViewController ()
@property (nonatomic, strong) UITextField *scanText;
@property (nonatomic, strong) UIButton *scanBtn;


@end

@implementation ScanViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *containView = [UIView new];
    [self.view addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_top).with.offset(100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
    }];
    
    _scanText = [UITextField new];
    _scanText.font = [UIFont systemFontOfSize:12];//
    _scanText.textColor = [UIColor blackColor];
    _scanText.placeholder=@"请输入二维码";
    _scanText.borderStyle=UITextBorderStyleRoundedRect;
    
    _scanBtn = [UIButton new];
    [_scanBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _scanBtn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [_scanBtn setBackgroundColor: [UIColor nameColor]];
    [containView addSubview:_scanBtn];
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(containView.mas_centerY);
        make.width.equalTo(@50);
        make.right.equalTo(containView.mas_right).with.offset(-10);
    }];

    [containView addSubview:_scanText];
    [_scanText mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(containView.mas_centerY);
        make.right.equalTo(_scanBtn.mas_left).with.offset(-10);
        make.width.equalTo(@150);
       
    }];
    
    _scanBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input)
    {
        //调用代理对象的协议方法来实现数据传递
        //[self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(reportScanResult:)]) {
                [self.delegate reportScanResult:_scanText.text];
            }
        });
        
        return [RACSignal empty];
    }];
    
    RACSignal *validSignal = [self.scanText.rac_textSignal
                                      map:^id(NSString *text) {
                                          return @([self isValidText:text]);
                                      }];
    
    [validSignal subscribeNext:^(NSNumber*signupActive){
        self.scanBtn.backgroundColor = [signupActive boolValue] ? [UIColor nameColor] : [UIColor grayColor];
        self.scanBtn.enabled =[signupActive boolValue];
    }];

}
-(BOOL)isValidText:(NSString *)text
{
    return text.length > 0;
}

@end
