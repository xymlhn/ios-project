//
//  SalesOrderInfoController.m
//  qmcp
//
//  Created by 谢永明 on 2016/9/23.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderInfoController.h"
#import "SalesOrderInfoView.h"
#import "QrCodeIdentityController.h"
#import "SalesOrderCameraController.h"
#import "SalesOrderStepController.h"
#import "InventoryManager.h"
#import "InventoryController.h"
@interface SalesOrderInfoController ()

@property (nonatomic, retain) SalesOrderInfoView *salesOrderInfoView;
@property (nonatomic, strong) SalesOrder *salesOrder;
@end

@implementation SalesOrderInfoController


+(instancetype)doneBlock:(void (^)(NSString *))block{
    
    SalesOrderInfoController *vc = [[SalesOrderInfoController alloc] init];
    vc.doneBlock = block;
    return vc;
    
}

-(void)loadView{
    
    _salesOrderInfoView = [SalesOrderInfoView new];
    self.view = _salesOrderInfoView;
    self.title = @"订单详细";
}


-(void)bindListener{
    
    _salesOrderInfoView.starBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        switch (_salesOrder.type) {
            case SalesOrderTypeOnsite:
                switch (_salesOrder.onSiteStatus) {
                    case OnSiteStatusWaiting:
                        [self p_updateTimeStampWithCode:_code andTimeStamp:OnSiteTimeStampAcknowledge andDate:[Utils formatDate:[NSDate new]]];
                        break;
                    case OnSiteStatusNotDepart:
                        [self p_updateTimeStampWithCode:_code andTimeStamp:OnSiteTimeStampEnroute andDate:[Utils formatDate:[NSDate new]]];
                        
                        break;
                    case OnSiteStatusOnRoute:
                        [self p_updateTimeStampWithCode:_code andTimeStamp:OnSiteTimeStampOnsite andDate:[Utils formatDate:[NSDate new]]];
                        break;
                        
                    default:
                        [self showOkayCancelAlert];
                        break;
                }
                break;
            case SalesOrderTypeShop:
                [self showOkayCancelAlert];
                break;
            case SalesOrderTypeRemote:
                [self showOkayCancelAlert];
                break;
            default:
                break;
        }
        return [RACSignal empty];
    }];
}

-(void)loadData{
    NSString *salesWhere = [NSString stringWithFormat:@"code = '%@'",_code];
    _salesOrder = [SalesOrder searchSingleWithWhere:salesWhere orderBy:nil];
    _salesOrderInfoView.salesOrder = _salesOrder;
    [self setInfo:_salesOrder];
    _salesOrderInfoView.stepBtn.userInteractionEnabled = YES;
    [_salesOrderInfoView.stepBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stepBtnClick:)]];
    
    _salesOrderInfoView.cameraBtn.userInteractionEnabled = YES;
    [_salesOrderInfoView.cameraBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraBtnClick:)]];
    
    _salesOrderInfoView.formBtn.userInteractionEnabled = YES;
    [_salesOrderInfoView.formBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(formBtnClick:)]];
    
    _salesOrderInfoView.qrCodeBtn.userInteractionEnabled = YES;
    [_salesOrderInfoView.qrCodeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrCodeBtnClick:)]];
    
}

-(void)setInfo:(SalesOrder *)salesOrder
{
    _salesOrderInfoView.remarkText.text = salesOrder.remark;
    _salesOrderInfoView.serviceText.text = salesOrder.organizationName;
    _salesOrderInfoView.appointmentTimeText.text = salesOrder.appointmentTime;
    
    _salesOrderInfoView.locationText.text = salesOrder.addressSnapshot.fullAddress;
    _salesOrderInfoView.passwordText.text = salesOrder.addressSnapshot.mobilePhone;
    _salesOrderInfoView.userNameText.text = salesOrder.addressSnapshot.contacts;
    _salesOrderInfoView.codeContent.text = salesOrder.code;
    NSString *title;
   
    _salesOrderInfoView.typeText.text = [EnumUtil salesOrderTypeString:salesOrder.type];
    switch (salesOrder.type) {
        case SalesOrderTypeOnsite:
            switch (_salesOrder.onSiteStatus) {
                case OnSiteStatusWaiting:
                    title = @"接收";
                    break;
                case OnSiteStatusNotDepart:
                    title = @"出发";
                    break;
                case OnSiteStatusOnRoute:
                    title = @"到达";
                    break;
                default:
                    title = @"完成订单";
                    break;
            }
            
            break;
        case SalesOrderTypeShop:
            title = @"完成订单";
            break;
        case SalesOrderTypeRemote:
            title = @"完成订单";
            break;
        default:
            break;
    }
    [_salesOrderInfoView.starBtn setTitle:title forState:UIControlStateNormal];
    
}

-(void)p_updateTimeStampWithCode:(NSString *)_salesOrderCode andTimeStamp:(OnSiteTimeStamp)timeStamp andDate:(NSString *)time{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在提交数据";
    hub.userInteractionEnabled = NO;
    NSDictionary *dict = @{@"timestamp":[NSNumber numberWithInt:timeStamp],@"value":time};
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_TIMESTAMP,_code];
    [HttpUtil postFormData:URLString param:dict finish:^(NSDictionary *obj, NSString *error) {
        if(!error){
            hub.labelText = [NSString stringWithFormat:@"提交数据成功"];
            [hub hide:YES afterDelay:kEndSucceedDelayTime];
            switch (weakSelf.salesOrder.onSiteStatus) {
                case OnSiteStatusWaiting:
                    [weakSelf.salesOrderInfoView.starBtn setTitle:@"出发" forState:UIControlStateNormal];
                    weakSelf.salesOrder.onSiteStatus = OnSiteStatusNotDepart;
                    [weakSelf.salesOrder saveToDB];
                    break;
                case OnSiteStatusNotDepart:
                    [weakSelf.salesOrderInfoView.starBtn setTitle:@"到达" forState:UIControlStateNormal];
                    weakSelf.salesOrder.onSiteStatus = OnSiteStatusOnRoute;
                    [weakSelf.salesOrder saveToDB];
                    break;
                case OnSiteStatusOnRoute:
                    [weakSelf.salesOrderInfoView.starBtn setTitle:@"完结" forState:UIControlStateNormal];
                    weakSelf.salesOrder.onSiteStatus = OnSiteStatusArrived;
                    [weakSelf.salesOrder saveToDB];
                    [self loadData];
                    break;
                default:
                    [weakSelf.salesOrderInfoView.starBtn setTitle:@"完结" forState:UIControlStateNormal];
                    weakSelf.salesOrder.onSiteStatus = OnSiteStatusArrived;
                    [weakSelf.salesOrder saveToDB];
                    break;
            }
        }else{
            [weakSelf.salesOrder saveToDB];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kEndFailedDelayTime];
        }
    }];
    
}

- (void)showOkayCancelAlert {
    NSString *title = @"提示";
    NSString *message = @"是否完结工单？";
    NSString *cancelButtonTitle = @"否";
    NSString *otherButtonTitle = @"是";
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf p_completeSalesOrder];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)p_completeSalesOrder{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在完成订单";
    hub.userInteractionEnabled = NO;
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERCOMPLETE,_code];
    [HttpUtil post:URLString param:nil finish:^(NSDictionary *dict, NSString *error) {
        if(error == nil){
            hub.labelText = [NSString stringWithFormat:@"完成订单成功"];
            [hub hide:YES afterDelay:kEndSucceedDelayTime];
            [weakSelf.salesOrder deleteToDB];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            if (self.doneBlock) {
                self.doneBlock(_code);
            }
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kEndFailedDelayTime];
        }
    }];
}

#pragma mark - IBAction
-(void)stepBtnClick:(UITapGestureRecognizer *)recognizer
{
    
    SalesOrderStepController *info = [SalesOrderStepController new];
    info.code = _code;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)cameraBtnClick:(UITapGestureRecognizer *)recognizer
{
    SalesOrderCameraController *info =[SalesOrderCameraController new];
    info.code = _code;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}
- (void)formBtnClick:(UITapGestureRecognizer *)recognizer
{
//    if(__salesOrder.type == _salesOrderTypeOnsite){
//        if(__salesOrder.onSiteStatus != OnSiteStatusArrived){
//            return;
//        }
//    }
//    _salesOrderFormsController *info =[_salesOrderFormsController new];
//    info._salesOrderCode = [super _salesOrderCode];
//    info.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:info animated:YES];
    
    [InventoryManager getInstance].currentSalesOrderCode = _code;
    SalesOrderSearchResult *ssr = [[InventoryManager getInstance] salesOrderChangeToSearchResult:_salesOrder];
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在获取";
    hub.userInteractionEnabled = NO;
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERITEM,_code];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if(!error){
            NSArray<CommoditySnapshot *> *commoditySnapshots = [CommoditySnapshot mj_objectArrayWithKeyValuesArray:obj];
            ssr.commodityItemList = commoditySnapshots;
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            hub.labelText = @"获取成功";
            [hub hide:YES afterDelay:kEndSucceedDelayTime];
            InventoryController *info = [InventoryController new];
            info.salesOrderCode = _code;
            info.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:info animated:YES];
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = error;
            [hub hide:YES afterDelay:kEndFailedDelayTime];
        }
        
    }];

}


-(void)qrCodeBtnClick:(UITapGestureRecognizer *)recognizer
{
    QrCodeIdentityController *controller = [QrCodeIdentityController new];
    
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.qrCodeUrl = _salesOrder.qrCodeUrl;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        controller.providesPresentationContextTransitionStyle = YES;
        controller.definesPresentationContext = YES;
        controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.tabBarController presentViewController:controller animated:YES completion:nil];
        
    } else {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:controller animated:NO completion:nil];
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}
@end
