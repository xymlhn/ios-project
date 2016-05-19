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

-(void)getAllWorkOrder:(NSString *)dateStr{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_ALL_WORKORDER,dateStr];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            [Config setWorkOrderTime:[Utils formatDate:[NSDate new]]];
            WorkOrderGroup *workOrderGroup = [WorkOrderGroup mj_objectWithKeyValues:obj];
            if(workOrderGroup.unassign){
                NSArray *unassignArray = workOrderGroup.unassign;
                for (NSString *workOrderCode in unassignArray) {
                    NSString *where = [NSString stringWithFormat:@"code = '%@'",workOrderCode];
                    [WorkOrder deleteWithWhere:where];
                }
            }
            if(workOrderGroup.assign){
                NSArray *assignArray = [WorkOrder mj_objectArrayWithKeyValuesArray:workOrderGroup.assign];
                for (WorkOrder *order in assignArray) {
                    order.salesOrderSnapshot.addressSnapshot.code = order.code;
                    [order saveToDB];
                }
            }
            
        }else{
            [self getAllWorkOrder:[Config getWorkOrderTime]];
        }
        [[WorkOrderManager getInstance] sortAllWorkOrder];
    }];
    
}

/**
 *  处理所有的工单并派发到界面
 */
- (void)sortAllWorkOrder{
   _workOrders = [WorkOrder searchWithWhere:nil];

    NSPredicate* undonePredicate = [NSPredicate predicateWithFormat:@"status < %@",[NSNumber numberWithInt:(int)WorkOrderStatusCompleted]];
    NSArray* undoneArr = [_workOrders filteredArrayUsingPredicate:undonePredicate];
    
    NSPredicate* donePredicate = [NSPredicate predicateWithFormat:@"status >= %@",[NSNumber numberWithInt:(int)WorkOrderStatusCompleted]];
    NSArray* doneArr = [_workOrders filteredArrayUsingPredicate:donePredicate];
    NSDictionary *dic = @{@"default":_workOrders,@"progress":undoneArr,@"complete":doneArr};
    NSNotification * notice = [NSNotification notificationWithName:kWorkOrderUpdateNotification object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

-(void)getWorkOrderByItemCode:(NSString *)itemCode{
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在扫描获取工单";
    hub.userInteractionEnabled = NO;
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_GETWORKORDERBYITEMCODE,itemCode];
    [HttpUtil get:URLString param:nil finish:^(NSDictionary *obj, NSError *error) {
        if (!error) {
            hub.labelText = [NSString stringWithFormat:@"上传工单步骤成功"];
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

-(void)postAttachment:(Attachment *)attachment finish:(void (^)(NSDictionary *, NSError *))block
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

-(void) updateTimeStamp:(NSString *)URLString params:(NSDictionary *)params finish:(void (^)(NSDictionary *, NSError *))block{
    [HttpUtil postFormData:URLString param:params finish:^(NSDictionary *obj, NSError *error) {
        block(obj,error);
    }];
}
- (void)postWorkOrderStep:(NSString *)URLString params:(NSDictionary *)params finish:(void (^)(NSDictionary *, NSError *))block{
    [HttpUtil post:URLString param:params finish:^(NSDictionary *obj, NSError *error) {
        block(obj,error);
    }];
}

-(void)completeAllSteps:(NSString *)URLString params:(NSDictionary *)params finish:(void (^)(NSDictionary *, NSError *))block{

    [HttpUtil post:URLString param:params finish:^(NSDictionary *obj, NSError *error) {
        block(obj,error);
    }];
}

@end

