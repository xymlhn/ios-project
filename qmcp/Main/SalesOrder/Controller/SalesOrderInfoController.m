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
#import "WorkOrderCameraController.h"
#import "InventoryManager.h"
#import "InventoryController.h"
#import "WorkOrderStepController.h"
#import "WorkOrderFormsController.h"
#import "SalesOrderManager.h"
#import "YCXMenu.h"
#import "AgreePriceChangeController.h"
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

#pragma mark - BaseViewController
-(void)loadView{
    
    _salesOrderInfoView = [SalesOrderInfoView new];
    self.view = _salesOrderInfoView;
    self.title = @"订单详细";
}

-(void)setupView{
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                            target:self
                                                                                            action:@selector(rightBtnClick)];
}

-(void)bindListener{
    _salesOrderInfoView.starBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        switch (_salesOrder.onSiteStatus) {
            case OnSiteStatusNone:
            case OnSiteStatusNotDepart:
            case OnSiteStatusWaiting:
                [self p_updateTimeStampWithCode:_code andTimeStamp:OnSiteTimeStampEnroute andDate:[Utils formatDate:[NSDate new]]];
                break;
            case OnSiteStatusOnRoute:
                [self p_updateTimeStampWithCode:_code andTimeStamp:OnSiteTimeStampOnsite andDate:[Utils formatDate:[NSDate new]]];
                break;
            default:
                break;
        }
        
        return [RACSignal empty];
    }];
    
    _salesOrderInfoView.agreeBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        __weak typeof(self) weakSelf = self;
        AgreePriceChangeController *controller = [AgreePriceChangeController doneBlock:^(NSString *price, NSString *remark) {
            MBProgressHUD *hub = [Utils createHUD];
            hub.detailsLabel.text = @"正在提交数据";
            NSDictionary *dict = [price isEqualToString:@""]?@{@"remark":remark} : @{@"agreementPrice":price,@"remark":remark};
            NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERAGREEPRICE,_code];
            [HttpUtil post:URLString param:dict finish:^(NSDictionary *dict, NSString *error) {
                if(!error){
                    hub.detailsLabel.text = [NSString stringWithFormat:@"提交数据成功"];
                    [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
                    weakSelf.salesOrder.agreementPrice = price;
                    [[SalesOrderManager getInstance] saveOrUpdateSalesOrder:weakSelf.salesOrder];
                    [weakSelf setInfo:weakSelf.salesOrder];
                }else{
                    hub.mode = MBProgressHUDModeCustomView;
                    hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                    hub.detailsLabel.text = error;
                    [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
                }
            }];
            
        }];
        controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
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
    
    _salesOrderInfoView.refreshBtn.userInteractionEnabled = YES;
    [_salesOrderInfoView.refreshBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshBtnClick:)]];
    
    _salesOrderInfoView.inventoryBtn.userInteractionEnabled = YES;
    [_salesOrderInfoView.inventoryBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inventoryBtnClick:)]];
    
}

#pragma mark - func
-(void)setInfo:(SalesOrder *)salesOrder{
    _salesOrderInfoView.remarkText.text = salesOrder.remark;
    _salesOrderInfoView.serviceText.text = salesOrder.organizationName;
    _salesOrderInfoView.appointmentTimeText.text = salesOrder.appointmentTime;
    
    _salesOrderInfoView.locationText.text = salesOrder.addressSnapshot.fullAddress;
    _salesOrderInfoView.passwordText.text = salesOrder.addressSnapshot.mobilePhone;
    _salesOrderInfoView.userNameText.text = salesOrder.addressSnapshot.contacts;
    _salesOrderInfoView.codeContent.text = salesOrder.code;
    _salesOrderInfoView.typeText.text = [EnumUtil salesOrderTypeString:salesOrder.type];
    _salesOrderInfoView.agreePriceText.text = salesOrder.agreementPrice;
    switch (salesOrder.type) {
        case SalesOrderTypeOnsite:
            switch (_salesOrder.onSiteStatus) {
                case OnSiteStatusNone:
                case OnSiteStatusWaiting:
                case OnSiteStatusNotDepart:
                    [_salesOrderInfoView.starBtn setTitle:@"出发" forState:UIControlStateNormal];
                    break;
                case OnSiteStatusOnRoute:
                    [_salesOrderInfoView.starBtn setTitle:@"到达" forState:UIControlStateNormal];
                    break;
                default:
                    [_salesOrderInfoView.starBtn setHidden:YES];
                    break;
            }
            
            break;
        case SalesOrderTypeShop:
            [_salesOrderInfoView.starBtn setHidden:YES];
            break;
        case SalesOrderTypeRemote:
            [_salesOrderInfoView.starBtn setHidden:YES];
            break;
        default:
            break;
    }
    
}

-(void)p_updateTimeStampWithCode:(NSString *)_salesOrderCode andTimeStamp:(OnSiteTimeStamp)timeStamp andDate:(NSString *)time{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.detailsLabel.text = @"正在提交数据";
    
    NSDictionary *dict = @{@"timestamp":[NSNumber numberWithInt:timeStamp],@"value":time};
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDER_TIMESTAMP,_code];
    [HttpUtil postFormData:URLString param:dict finish:^(NSDictionary *obj, NSString *error) {
        if(!error){
            hub.detailsLabel.text = [NSString stringWithFormat:@"提交数据成功"];
            [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            switch (weakSelf.salesOrder.onSiteStatus) {
                case OnSiteStatusNone:
                case OnSiteStatusWaiting:
                case OnSiteStatusNotDepart:
                    [weakSelf.salesOrderInfoView.starBtn setTitle:@"到达" forState:UIControlStateNormal];
                    weakSelf.salesOrder.onSiteStatus = OnSiteStatusOnRoute;
                    [weakSelf.salesOrder saveToDB];
                    break;
                case OnSiteStatusOnRoute:
                    [weakSelf.salesOrderInfoView.starBtn setHidden:YES];
                    weakSelf.salesOrder.onSiteStatus = OnSiteStatusArrived;
                    [weakSelf.salesOrder saveToDB];
                    [self loadData];
                    break;
                default:
                    break;
            }
        }else{
            [weakSelf.salesOrder saveToDB];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
    }];
    
}

-(void)p_completeSalesOrder{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.detailsLabel.text = @"正在完成订单";
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERCOMPLETE,_code];
    [HttpUtil post:URLString param:nil finish:^(NSDictionary *dict, NSString *error) {
        if(error == nil){
            hub.detailsLabel.text = [NSString stringWithFormat:@"完成订单成功"];
            [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            [weakSelf.salesOrder deleteToDB];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            if (weakSelf.doneBlock) {
                weakSelf.doneBlock(_code);
            }
            
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
    }];
}

#pragma mark - IBAction
-(void)rightBtnClick{
    [YCXMenu setTintColor:[UIColor blackColor]];
    [YCXMenu setSelectedColor:[UIColor redColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        NSArray *menuItems = @[[YCXMenuItem menuItem:@"完结订单" image:[UIImage imageNamed:@"menu_order_icon"] target:self action:@selector(completeClick)]];
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 0, 50, 0) menuItems:menuItems selected:^(NSInteger index, YCXMenuItem *item) {
            NSLog(@"%@",item);
        }];
    }
}

-(void)completeClick{

    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message: @"是否完结工单？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle: @"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf p_completeSalesOrder];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)refreshBtnClick:(UITapGestureRecognizer *)recognizer{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [Utils createHUD];
    hub.detailsLabel.text = @"正在刷新";
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERDETAIL,_code];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if(!error){
            hub.detailsLabel.text = @"刷新成功";
            [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
            SalesOrder *tempSalesOrder = [SalesOrder mj_objectWithKeyValues:obj];
            weakSelf.salesOrder = tempSalesOrder;
            [[SalesOrderManager getInstance] saveOrUpdateSalesOrder:tempSalesOrder];
            [weakSelf setInfo:tempSalesOrder];
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
        
    }];
    
}

-(void)inventoryBtnClick:(UITapGestureRecognizer *)recognizer{
    if(_salesOrder.signedFlag){
        [Utils showHudTipStr:@"该订单已清点"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [InventoryManager getInstance].currentSalesOrderCode = _code;
    SalesOrderSearchResult *ssr = [[InventoryManager getInstance] salesOrderChangeToSearchResult:_salesOrder];
    [[InventoryManager getInstance] appendSalesOrderSearchResult:ssr];
    MBProgressHUD *hub = [Utils createHUD];
    hub.detailsLabel.text = @"正在获取清点信息";
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERITEM,_code];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if(!error){
            NSArray<CommoditySnapshot *> *commoditySnapshots = [CommoditySnapshot mj_objectArrayWithKeyValuesArray:obj];
            ssr.commodityItemList = commoditySnapshots;
            hub.detailsLabel.text = @"";
            [hub hideAnimated:YES];
            InventoryController *info = [InventoryController doneBlock:^(BOOL signFlag) {
                weakSelf.salesOrder.signedFlag = signFlag;
            }];
            info.salesOrderCode = _code;
            info.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:info animated:YES];
        }else{
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.detailsLabel.text = error;
            [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
        }
        
    }];
}

-(void)stepBtnClick:(UITapGestureRecognizer *)recognizer{
    WorkOrderStepController *info = [WorkOrderStepController new];
    info.code = _code;
    info.funcType = FuncTypeSalesOrder;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)cameraBtnClick:(UITapGestureRecognizer *)recognizer{
    WorkOrderCameraController *info =[WorkOrderCameraController new];
    info.code = _code;
    info.funcType = FuncTypeSalesOrder;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)formBtnClick:(UITapGestureRecognizer *)recognizer{
    if(_salesOrder.type == SalesOrderTypeOnsite){
        if(_salesOrder.onSiteStatus != OnSiteStatusArrived){
            return;
        }
    }
    WorkOrderFormsController *info = [WorkOrderFormsController new];
    info.code = _code;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

-(void)qrCodeBtnClick:(UITapGestureRecognizer *)recognizer{
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
