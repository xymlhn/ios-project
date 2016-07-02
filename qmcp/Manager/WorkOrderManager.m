//
//  WorkOrderManager.m
//  qmcp
//
//  Created by 谢永明 on 16/3/17.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "OSCAPI.h"
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

NSString *const kWorkOrderUpdateNotification = @"workOrderUpdate";
@interface WorkOrderManager()

@property(nonatomic,strong)NSMutableArray<WorkOrder *> *workOrders;

@end
@implementation WorkOrderManager

+ (WorkOrderManager *)getInstance {
    static WorkOrderManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

-(void)getWorkOrderByLastUpdateTime:(NSString *)dateStr{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_ALL_WORKORDER,dateStr];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
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
                    order.salesOrderSnapshot.addressSnapshot.code = order.code;
                    [order saveToDB];
                }];
            }
            
        }else{
            [self getWorkOrderByLastUpdateTime:[Config getWorkOrderTime]];
        }
        [[WorkOrderManager getInstance] sortAllWorkOrder];
    }];
    
}

/**
 *  处理所有的工单并派发到界面
 */
- (void)sortAllWorkOrder{
    _workOrders = [WorkOrder searchWithWhere:nil];
    
    [_workOrders sortUsingComparator:^NSComparisonResult(WorkOrder *  _Nonnull obj1, WorkOrder *  _Nonnull obj2) {
        int a1 = [[obj1.code componentsSeparatedByString:@"-"][1] intValue];
        int a2 = [[obj2.code componentsSeparatedByString:@"-"][1] intValue];
        return a1 < a2;
    }];

    NSPredicate* undonePredicate = [NSPredicate predicateWithFormat:@"status < %@",[NSNumber numberWithInt:(int)WorkOrderStatusCompleted]];
    NSArray* undoneArr = [_workOrders filteredArrayUsingPredicate:undonePredicate];
    
    NSPredicate* donePredicate = [NSPredicate predicateWithFormat:@"status >= %@",[NSNumber numberWithInt:(int)WorkOrderStatusCompleted]];
    NSArray* doneArr = [_workOrders filteredArrayUsingPredicate:donePredicate];
    NSDictionary *dic = @{@"default":_workOrders,@"progress":undoneArr,@"complete":doneArr};
    NSNotification * notice = [NSNotification notificationWithName:kWorkOrderUpdateNotification object:nil userInfo:dic];
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

-(void)getWorkOrderByItemCode:(NSString *)itemCode{
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在扫描获取工单";
    hub.userInteractionEnabled = NO;
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_GETWORKORDERBYITEMCODE,itemCode];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            hub.labelText = [NSString stringWithFormat:@"扫描成功"];
            [hub hide:YES afterDelay:1];
        }else{
            NSString *message = @"";
            if(obj == nil){
                message =@"扫描工单失败,请重试";
            }else{
                message = [obj valueForKey:@"message"];
            }
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = message;
            [hub hide:YES afterDelay:1];
        }
    }];
    
}

-(void)postAttachment:(Attachment *)attachment finishBlock:(void (^)(NSDictionary *, NSError *))block
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_ATTACHMENT];
    NSDictionary *dict = @{@"storageType":[NSNumber numberWithInt:attachment.sort]};
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:attachment.path];;
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    else
    {
        data = UIImagePNGRepresentation(image);
    }
    
    [HttpUtil postFile:URLString file:data name:@"data" fileName:attachment.key param:dict finish:block];
}

- (void)postPickUpItem{
    
    PickupItemSignature *pick = [PickupItemSignature new];
    pick.salesOrderCode = @"10102-739";
    pick.pickupTime = [Utils formatDate:[NSDate new]];
    pick.signatureImageKey = @"b23f49bc-374c-4749-8229-c3c90d47b3de.jpg";
    pick.itemCodes = @[@"sf01"];
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_PICKUPITEM];
    [HttpUtil post:URLString param:pick finish:^(NSDictionary *obj,NSError *error){
        if (!error) {
            
        }else{
            NSLog(@"提交失败");
        }
    }];
}

-(void) updateTimeStampWithURL:(NSString *)URLString andParams:(NSDictionary *)params finishBlock:(void (^)(NSDictionary *, NSError *))block{
    [HttpUtil postFormData:URLString param:params finish:^(NSDictionary *obj, NSError *error) {
        block(obj,error);
    }];
}
- (void)postWorkOrderStepWithURL:(NSString *)URLString andParams:(NSDictionary *)params finishBlock:(void (^)(NSDictionary *, NSError *))block{
    [HttpUtil post:URLString param:params finish:^(NSDictionary *obj, NSError *error) {
        block(obj,error);
    }];
}

-(void)completeAllStepsWithURL:(NSString *)URLString andParams:(NSDictionary *)params finishBlock:(void (^)(NSDictionary *, NSError *))block{

    [HttpUtil post:URLString param:params finish:^(NSDictionary *obj, NSError *error) {
        block(obj,error);
    }];
}

@end

