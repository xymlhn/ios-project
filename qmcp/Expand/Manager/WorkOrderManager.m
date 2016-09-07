//
//  WorkOrderManager.m
//  qmcp
//
//  Created by 谢永明 on 16/3/17.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "QMCPAPI.h"
#import "WorkOrderManager.h"
#import "HttpUtil.h"
#import "WorkOrder.h"
#import "SalesOrderSnapshot.h"
#import "NSObject+LKDBHelper.h"
#import "AFHTTPSessionManager.h"
#import "MJExtension.h"
#import "WorkOrderStep.h"
#import "WorkOrderGroup.h"
#import "AFNetworking.h"
#import "Attachment.h"
#import "MBProgressHUD.h"
#import "Utils.h"
#import "PickupItemSignature.h"
#import "Config.h"
#import "AppManager.h"
#import "User.h"
#import "CommodityBrife.h"
#import "CommodityStep.h"
#import "TMCache.h"

NSString *const WorkOrderUpdateNotification = @"workOrderUpdate";
NSString * const kCommodityStepCache = @"commodityStepCache";
@interface WorkOrderManager()

@property (nonatomic,strong) NSMutableArray<WorkOrder *> *workOrders;
@property (nonatomic,retain) NSMutableDictionary<NSString *,NSMutableArray<CommodityStep *> *> *commodityStepDict;
@end
@implementation WorkOrderManager

+ (WorkOrderManager *)getInstance {
    static WorkOrderManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
        
        shared_manager.commodityStepDict = [[TMCache sharedCache] objectForKey:kCommodityStepCache];
        if(shared_manager.commodityStepDict == nil){
            shared_manager.commodityStepDict = [NSMutableDictionary new];
        }
    });
    return shared_manager;
}


-(void)getCommodityStepByLastUpdateTime:(NSString *)dateStr{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_COMMODITYSTEP,dateStr];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            [Config setCommodityStep:[Utils formatDate:[NSDate new]]];
            NSArray<CommodityBrife *> *commodityBrifeArr = [CommodityBrife mj_objectArrayWithKeyValuesArray:obj];
            if(commodityBrifeArr > 0){
                _commodityStepDict = [NSMutableDictionary new];
                for (CommodityBrife *commodityBrife in commodityBrifeArr) {
                    NSMutableArray<CommodityStep *> *tempArr = [NSMutableArray new];
                    for (NSString *key in commodityBrife.steps) {
                        CommodityStep *commodityStep = [CommodityStep new];
                        commodityStep.stepName = key;
                        commodityStep.stepDescription = commodityBrife.steps[key];
                        [tempArr addObject:commodityStep];
                    }
                    [_commodityStepDict setObject:tempArr forKey:commodityBrife.code];
                }
                [[TMCache sharedCache] setObject:_commodityStepDict forKey:kCommodityStepCache];
                
            }
        }

    }];
}

-(NSMutableArray *)getCommodityByCommodityCode:(NSMutableDictionary<NSString *,NSString *> *)commodityDict{
    NSMutableArray *array = [NSMutableArray new];
    for (NSString *key in commodityDict) {
        NSMutableArray<CommodityStep *> *tempArray = _commodityStepDict[key];
        if(tempArray.count > 0){
            for (CommodityStep *commodityStep in tempArray) {
                commodityStep.commodityName = commodityDict[key];
            }
            [array addObject:tempArray];
        }
    }
    return array;
}

-(void)getWorkOrderByLastUpdateTime:(NSString *)dateStr{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_ALL_WORKORDER,dateStr];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            [Config setWorkOrderTime:[Utils formatDate:[NSDate new]]];
            WorkOrderGroup *workOrderGroup = [WorkOrderGroup mj_objectWithKeyValues:obj];
            if(workOrderGroup.unassign){
                [workOrderGroup.unassign enumerateObjectsUsingBlock:^(NSString *  _Nonnull workOrderCode, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *where = [NSString stringWithFormat:@"code = '%@'",workOrderCode];
                    [WorkOrder deleteWithWhere:where];
                }];
            }
            if(workOrderGroup.assign){
                NSArray *assignArray = [WorkOrder mj_objectArrayWithKeyValuesArray:workOrderGroup.assign];
                [assignArray enumerateObjectsUsingBlock:^(WorkOrder *  _Nonnull order, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(order.type != 20){
                        order.salesOrderSnapshot.addressSnapshot.code = order.code;
                        [order.salesOrderCommoditySnapshots enumerateObjectsUsingBlock:^(CommoditySnapshot * _Nonnull css, NSUInteger idx, BOOL * _Nonnull stop) {
                            css.code = [NSUUID UUID].UUIDString;
                        }];
                        order.userId = [[AppManager getInstance] getUser].userOpenId;
                        [order saveToDB];
                    }
                }];
            }
            
        }
        [[WorkOrderManager getInstance] sortAllWorkOrder];
    }];
    
}

/**
 *  处理所有的工单并派发到界面
 */
- (void)sortAllWorkOrder{
    User *user = [[AppManager getInstance] getUser];
    NSString *workWhere = [NSString stringWithFormat:@"userId = '%@'",user.userOpenId];
    _workOrders = [WorkOrder searchWithWhere:workWhere];
    
    [_workOrders sortUsingComparator:^NSComparisonResult(WorkOrder *  _Nonnull obj1, WorkOrder *  _Nonnull obj2) {
        int a1 = [[obj1.code componentsSeparatedByString:@"-"][1] intValue];
        int a2 = [[obj2.code componentsSeparatedByString:@"-"][1] intValue];
        return a1 < a2;
    }];

    NSPredicate* undonePredicate = [NSPredicate predicateWithFormat:@"failed == %@",[NSNumber numberWithBool:NO]];
    NSArray* undoneArr = [_workOrders filteredArrayUsingPredicate:undonePredicate];
    
    NSPredicate* failedPredicate = [NSPredicate predicateWithFormat:@"failed == %@",[NSNumber numberWithBool:YES]];
    NSArray* failedArr = [_workOrders filteredArrayUsingPredicate:failedPredicate];
    NSDictionary *dic = @{@"progress":undoneArr,@"failed":failedArr};
    NSNotification * notice = [NSNotification notificationWithName:WorkOrderUpdateNotification object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

-(WorkOrder *)findWorkOrderByCode:(NSString *)code{
    __block WorkOrder *workOrder;
    [_workOrders enumerateObjectsUsingBlock:^(WorkOrder * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.code isEqualToString:code]){
            *stop = YES;
            workOrder = obj;
        }
    }];
    return workOrder;
}

-(void)getWorkOrderByItemCode:(NSString *)itemCode
                  finishBlock:(CompletionHandler)completion{

    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_GETWORKORDERBYITEMCODE,itemCode];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        completion(obj,error);
    }];
    
}

-(void)getWorkOrderByCode:(NSString *)code{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_WORKORDER,code];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        if (!error) {
            WorkOrder *workOrder = [WorkOrder mj_objectWithKeyValues:obj];
            [workOrder saveToDB];
            [self sortAllWorkOrder];
        }
    }];
    
}

-(void)postAttachment:(Attachment *)attachment
          finishBlock:(CompletionHandler)completion{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@", QMCPAPI_ADDRESS,QMCPAPI_ATTACHMENT];
    NSDictionary *dict = @{@"storageType":[NSNumber numberWithInt:attachment.sort]};
    UIImage *image = [Utils loadImage:attachment.key];
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    else
    {
        data = UIImagePNGRepresentation(image);
    }
    
    [HttpUtil postFile:URLString file:data name:@"data" fileName:attachment.key param:dict finish:completion];
    
}

-(void) updateTimeStampWithCode:(NSString *)code
                      andParams:(NSDictionary *)params
                    finishBlock:(CompletionHandler)completion{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_TIMESTAMP,code];
    [HttpUtil postFormData:URLString param:params finish:^(NSDictionary *obj, NSString *error) {
        completion(obj,error);
    }];
    
}


- (void)postWorkOrderStepWithCode:(NSString *)code
                        andParams:(NSDictionary *)params
                      finishBlock:(CompletionHandler)completion{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_POSTWORKORDERSTEP,code];
    [HttpUtil post:URLString param:params finish:^(NSDictionary *obj, NSString *error) {
        completion(obj,error);
    }];
    
}

-(void)postWorkOrderInventoryWithCode:(NSString *)code
                            andParams:(NSDictionary *)params
                          finishBlock:(CompletionHandler)completion{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", QMCPAPI_ADDRESS,QMCPAPI_POSTWORKORDERINVENTORY,code];
    [HttpUtil post:URLString param:params finish:^(NSDictionary *obj, NSString *error) {
        completion(obj,error);
    }];
}

-(void)searchWorkOrderWithString:(NSString *)string
                    andCondition:(BOOL)condition
                     finishBlock:(CompletionHandler)completion{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@?includeHistory=%@&condition=%@", QMCPAPI_ADDRESS,QMCPAPI_SEARCH,[NSNumber numberWithBool:condition],string];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSString *error) {
        completion(obj,error);
    }];
    
}

@end

