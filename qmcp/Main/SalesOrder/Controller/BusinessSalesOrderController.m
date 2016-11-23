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
#import "SalesOrder.h"
#import "SalesOrderInfoController.h"
#import "SalesOrderManager.h"
@interface BusinessSalesOrderController ()

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
        __weak typeof(self) weakSelf = self;
        MBProgressHUD *hub = [Utils createHUD];
        hub.detailsLabelText = @"正在下单";
        hub.userInteractionEnabled = NO;
        
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
                hub.detailsLabelText = [NSString stringWithFormat:@"下单成功"];
                [hub hide:YES afterDelay:kEndSucceedDelayTime];
                //调用代理对象的协议方法来实现数据传递
                [weakSelf.navigationController popViewControllerAnimated:YES];
                if (weakSelf.doneBlock) {
                    self.doneBlock(salesOrder.code);
                }
            }else{
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                hub.detailsLabelText = error;
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
        _businessSalesOrderView.orderButton.backgroundColor = [signupActive boolValue] ? [UIColor nameColor] : [UIColor grayColor];
        _businessSalesOrderView.orderButton.enabled = [signupActive boolValue];
    }];

}


@end
