//
//  BusinessSalesOrderController.m
//  qmcp
//
//  Created by 谢永明 on 2016/9/22.
//  Copyright © 2016年 inforshare. All rights reserved.
//  商家下单
//

#import "BusinessSalesOrderController.h"
#import "BusinessSalesOrder.h"
#import "BusinessSalesOrderView.h"
#import "SalesOrder.h"
#import "SalesOrderInfoController.h"
#import "SalesOrderManager.h"
@interface BusinessSalesOrderController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>
@property (nonatomic, strong) BusinessSalesOrderView *businessSalesOrderView;
@end

@implementation BusinessSalesOrderController

+(instancetype)doneBlock:(void (^)(NSString *))block{
    BusinessSalesOrderController *vc = [[BusinessSalesOrderController alloc] init];
    vc.doneBlock = block;
    return vc;
    
}

-(void)loadView{
    _businessSalesOrderView = [BusinessSalesOrderView viewInstance];
    self.view = _businessSalesOrderView;
    self.title = @"商家下单";
}

-(void)bindListener{
    
    _businessSalesOrderView.orderButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self p_businessSalesOrder];
        return [RACSignal empty];
    }];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    [_businessSalesOrderView.phoneValue addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_businessSalesOrderView.nameValue addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_businessSalesOrderView.addressValue addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _businessSalesOrderView.remarkValue.delegate = self;
}

-(void)loadData{
    __weak typeof(self) weakSelf = self;
    RACSignal *validPhoneSignal = [_businessSalesOrderView.phoneValue.rac_textSignal
                                   map:^id(NSString *text) {
                                       return @([Utils isMobileNumber:text]);
                                   }];
    RAC(_businessSalesOrderView.phoneValue, textColor) =[validPhoneSignal map:^id(NSNumber *usernameValid){
        return[usernameValid boolValue] ? [UIColor blackColor]:[UIColor redColor];
    }];
    
    //只能输入11位数字
    [_businessSalesOrderView.phoneValue.rac_textSignal subscribeNext:^(NSString *number) {
        if (number.length) {
            if (number.length > 11) {
                weakSelf.businessSalesOrderView.phoneValue.text = [number substringToIndex:11];
            }
        }
    }];
    
    RACSignal *validAddressSignal = [_businessSalesOrderView.addressValue.rac_textSignal
                                     map:^id(NSString *text) {
                                         return @(![Utils isTextNull:text]);
                                     }];
    
    RACSignal *validUserSignal = [_businessSalesOrderView.nameValue.rac_textSignal
                                  map:^id(NSString *text) {
                                      return @(![Utils isTextNull:text]);
                                  }];
    
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validPhoneSignal, validUserSignal,validAddressSignal]
                                                      reduce:^id(NSNumber*phoneValid, NSNumber *userValid,NSNumber* addressValid){
                                                          return @([phoneValid boolValue]&&[userValid boolValue]&&[addressValid boolValue]);
                                                      }];
    [signUpActiveSignal subscribeNext:^(NSNumber*signupActive){
        _businessSalesOrderView.orderButton.backgroundColor = [signupActive boolValue] ? [UIColor appBlueColor] : [UIColor buttonDisableColor];
        _businessSalesOrderView.orderButton.enabled = [signupActive boolValue];
    }];
    
}

//商家下单
-(void)p_businessSalesOrder{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.detailsLabel.text = @"正在下单";
    BusinessSalesOrder *businessSalesOrder = [[BusinessSalesOrder alloc] initWithName:_businessSalesOrderView.nameValue.text
                                                                                phone:_businessSalesOrderView.phoneValue.text
                                                                              address:_businessSalesOrderView.addressValue.text
                                                                               remark:_businessSalesOrderView.remarkValue.text];
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_BUSINESSSALESORDER];
    NSDictionary *dict = [businessSalesOrder mj_keyValues];
    [HttpUtil post:URLString param:dict finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            SalesOrder *salesOrder = [SalesOrder mj_objectWithKeyValues:obj];
            [[SalesOrderManager getInstance] saveOrUpdateSalesOrder:salesOrder];
            hub.detailsLabel.text = [NSString stringWithFormat:@"下单成功"];
            [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            //调用代理对象的协议方法来实现数据传递
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if (weakSelf.doneBlock) {
                self.doneBlock(salesOrder.code);
            }
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
    }];
}

#pragma mark - 键盘操作
- (void)hidenKeyboard{
    [self.view endEditing:YES];
    
}

- (void)returnOnKeyboard:(UITextField *)sender{
    if (sender == _businessSalesOrderView.phoneValue) {
        [_businessSalesOrderView.nameValue becomeFirstResponder];
    } else if (sender == _businessSalesOrderView.nameValue) {
        [_businessSalesOrderView.addressValue becomeFirstResponder];
    }else if(sender == _businessSalesOrderView.addressValue){
        [_businessSalesOrderView.remarkValue becomeFirstResponder];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"] ){
        if (_businessSalesOrderView.orderButton.enabled) {
            [self p_businessSalesOrder];
        }else{
            [self hidenKeyboard];
        }
        return NO;
    }
    return YES;
}
@end
