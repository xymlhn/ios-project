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
#import "SalesOrderAgreePriceController.h"
#import "AppManager.h"
@interface SalesOrderInfoController ()

@property (nonatomic, retain) SalesOrderInfoView *salesOrderInfoView;
@property (nonatomic, strong) SalesOrder *salesOrder;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic,strong) NSMutableArray<NSString *> *tabIcon;
@property (nonatomic,strong) NSMutableArray<NSString *> *tabLabel;

@end

@implementation SalesOrderInfoController


-(NSMutableArray<NSString *> *)tabIcon{
    if (_tabIcon == nil) {
        
        if ([[AppManager getInstance] getUser].cooperationMode == CooperationModeSingle) {
             _tabIcon = [@[@"tab_step",@"tab_inventory",@"tab_form",@"tab_video",@"tab_refresh"] mutableCopy];
        }else{
            _tabIcon = [@[@"tab_inventory",@"tab_form",@"tab_video",@"tab_refresh"] mutableCopy];
        }
    }
    return _tabIcon;
}

-(NSMutableArray<NSString *> *)tabLabel{
    if(_tabLabel == nil){
         if ([[AppManager getInstance] getUser].cooperationMode == CooperationModeSingle) {
             _tabLabel = [@[@"步骤",@"清点",@"表单",@"摄像头",@"刷新"] mutableCopy];
         }else{
             _tabLabel = [@[@"清点",@"表单",@"摄像头",@"刷新"] mutableCopy];
         }
    }
    return _tabLabel;
}
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
    UIImage *issueImage = [UIImage imageNamed:@"icon_complete"];
    
    self.rightButton = [UIButton new];
    self.rightButton.frame = CGRectMake(0, 0, 15, 15);
    [_rightButton setBackgroundImage:issueImage forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    
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
        SalesOrderAgreePriceController *controller = [SalesOrderAgreePriceController doneBlock:^(NSString *price, NSString *remark) {
            MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hub.detailsLabel.text = @"正在提交数据";
            NSDictionary *dict = [price isEqualToString:@""]?@{@"remark":remark} : @{@"agreementPrice":price,@"remark":remark};
            NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERAGREEPRICE,_code];
            [HttpUtil post:URLString param:dict finish:^(NSDictionary *dict, NSString *error) {
                if(!error){
                    hub.detailsLabel.text = [NSString stringWithFormat:@"提交数据成功"];
                    [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
                    weakSelf.salesOrder.agreementPrice = price;
                    [[SalesOrderManager getInstance] saveOrUpdateSalesOrder:weakSelf.salesOrder];
                    [weakSelf loadData];
                }else{
                    hub.mode = MBProgressHUDModeCustomView;
                    hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                    hub.detailsLabel.text = error;
                    [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
                }
            }];
            
        }];
        [self.navigationController pushViewController:controller animated:YES];
        return [RACSignal empty];
    }];
    
}

-(void)loadData{
    NSString *salesWhere = [NSString stringWithFormat:@"code = '%@'",_code];
    _salesOrder = [SalesOrder searchSingleWithWhere:salesWhere orderBy:nil];
    if(_salesOrder.signedFlag){
        [self.tabIcon removeObject:@"tab_inventory"];
        [self.tabLabel removeObject:@"清点"];
    }
    _salesOrderInfoView.tabIcon = self.tabIcon;
    _salesOrderInfoView.tabLabel = self.tabLabel;
    [_salesOrderInfoView setSalesOrder:_salesOrder];
    
    [_salesOrderInfoView.tabView enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog ( @"frame: %@, bounds: %@" , NSStringFromCGRect (obj. frame), NSStringFromCGRect (obj. bounds ));
        obj.userInteractionEnabled = YES;
        [obj addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabBtnClick:)]];
    }];
    
}

-(void)p_updateTimeStampWithCode:(NSString *)_salesOrderCode andTimeStamp:(OnSiteTimeStamp)timeStamp andDate:(NSString *)time{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
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
                    weakSelf.salesOrder.onSiteStatus = OnSiteStatusArrived;
                    [weakSelf.salesOrder saveToDB];
                    [weakSelf loadData];
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
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
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

-(void)tabBtnClick:(UITapGestureRecognizer *)recognizer{
    NSString *tagStr = self.tabLabel[recognizer.view.tag];
    __weak typeof(self) weakSelf = self;
    if ([tagStr isEqualToString:@"步骤"]) {
        WorkOrderStepController *info = [WorkOrderStepController new];
        info.code = _code;
        info.funcType = FuncTypeSalesOrder;
        info.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:info animated:YES];
    }else if ([tagStr isEqualToString:@"表单"]){
        if(_salesOrder.type == SalesOrderTypeOnsite){
            if(_salesOrder.onSiteStatus != OnSiteStatusArrived){
                return;
            }
        }
        WorkOrderFormsController *info = [WorkOrderFormsController new];
        info.code = _code;
        info.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:info animated:YES];
    }else if ([tagStr isEqualToString:@"摄像头"]){
        WorkOrderCameraController *info =[WorkOrderCameraController new];
        info.code = _code;
        info.funcType = FuncTypeSalesOrder;
        info.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:info animated:YES];
    }else if ([tagStr isEqualToString:@"刷新"]){
        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hub.detailsLabel.text = @"正在刷新";
        
        NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_SALESORDERDETAIL,_code];
        [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
            if(!error){
                hub.detailsLabel.text = @"刷新成功";
                [hub hideAnimated:YES afterDelay:kEndSucceedDelayTime];
                SalesOrder *tempSalesOrder = [SalesOrder mj_objectWithKeyValues:obj];
                tempSalesOrder.isRead = YES;
                weakSelf.salesOrder = tempSalesOrder;
                [[SalesOrderManager getInstance] saveOrUpdateSalesOrder:tempSalesOrder];
                [weakSelf loadData];
            }else{
                hub.mode = MBProgressHUDModeCustomView;
                hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                hub.detailsLabel.text = error;
                [hub hideAnimated:YES afterDelay:kEndFailedDelayTime];
            }
            
        }];
    }else if ([tagStr isEqualToString:@"清点"]){
        if(_salesOrder.signedFlag){
            [Utils showHudTipStr:@"该订单已清点"];
            return;
        }
        [InventoryManager getInstance].currentSalesOrderCode = _code;
        SalesOrderSearchResult *ssr = [[InventoryManager getInstance] salesOrderChangeToSearchResult:_salesOrder];
        [[InventoryManager getInstance] appendSalesOrderSearchResult:ssr];
        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
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
                    [weakSelf.salesOrder updateToDB];
                    [weakSelf loadData];
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
}
-(void)rightBtnClick{
    [YCXMenu setTitleFont:[UIFont systemFontOfSize:kShisanpt]];
    [YCXMenu setTintColor:[UIColor blackColor]];
    [YCXMenu setSelectedColor:[UIColor redColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        NSArray *menuItems = @[[YCXMenuItem menuItem:@"完结订单" image:[UIImage imageNamed:@"menu_order_icon"] target:self action:@selector(completeClick)]];
        [YCXMenu showMenuInView:self.navigationController.view fromRect:CGRectMake(self.view.frame.size.width - 50, 55, 50, 0) menuItems:menuItems selected:^(NSInteger index, YCXMenuItem *item) {
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

@end
