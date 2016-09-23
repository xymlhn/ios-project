//
//  BusinessSalesOrderController.m
//  qmcp
//
//  Created by 谢永明 on 2016/9/22.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BusinessSalesOrderController.h"
#import "BusinessSalesOrder.h"
#import "BusinessSalesOrderView.h"
@interface BusinessSalesOrderController ()

@property (nonatomic, strong) BusinessSalesOrderView *businessSalesOrderView;

@end

@implementation BusinessSalesOrderController

-(void)loadView{
    
    _businessSalesOrderView = [BusinessSalesOrderView viewInstance];
    self.view = _businessSalesOrderView;
     self.title = @"商家下单";
}

-(void)bindListener{
    _businessSalesOrderView.orderButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        MBProgressHUD *hub = [Utils createHUD];
        hub.labelText = @"正在下单";
        hub.userInteractionEnabled = NO;
        
        BusinessSalesOrder *businessSalesOrder = [[BusinessSalesOrder alloc] initWithName:_businessSalesOrderView.nameValue.text
                                                                                    phone:_businessSalesOrderView.phoneValue.text
                                                                                  address:_businessSalesOrderView.addressValue.text
                                                                                   remark:_businessSalesOrderView.remarkValue.text];
        
        NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_BUSINESSSALESORDER];
        NSDictionary *dict = [businessSalesOrder mj_keyValues];
        [HttpUtil post:URLString param:dict finish:^(NSDictionary *obj, NSString *error) {
            if (!error) {
                
                hub.labelText = [NSString stringWithFormat:@"下单成功"];
                [hub hide:YES afterDelay:kEndSucceedDelayTime];
            }else{
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                hub.labelText = error;
                [hub hide:YES afterDelay:kEndFailedDelayTime];
            }
        }];

        
        return [RACSignal empty];
    }];

}




-(void)loadData{
    RACSignal *validPhoneSignal = [_businessSalesOrderView.phoneValue.rac_textSignal
                                      map:^id(NSString *text) {
                                          return @([Utils isMobileNumber:text]);
                                      }];

    
    RACSignal *validAddressSignal = [_businessSalesOrderView.addressValue.rac_textSignal
                                      map:^id(NSString *text) {
                                          return @(![self isTextNull:text]);
                                      }];
    
    RACSignal *validUserSignal = [_businessSalesOrderView.nameValue.rac_textSignal
                                  map:^id(NSString *text) {
                                      return @(![self isTextNull:text]);
                                  }];
    
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validPhoneSignal, validUserSignal,validAddressSignal]
                                                    reduce:^id(NSNumber*phoneValid, NSNumber *userValid,NSNumber* addressValid){
                                                        return @([phoneValid boolValue]&&[userValid boolValue]&&[addressValid boolValue]);
                                                    }];
    [signUpActiveSignal subscribeNext:^(NSNumber*signupActive){
        _businessSalesOrderView.orderButton.backgroundColor = [signupActive boolValue] ? [UIColor nameColor] : [UIColor grayColor];
        _businessSalesOrderView.orderButton.enabled = [signupActive boolValue];
    }];

}


/**
 文字是否为空

 @param text string

 @return bool
 */
-(BOOL)isTextNull:(NSString *)text{
    return text == nil || [text isEqualToString:@""];
}

@end
