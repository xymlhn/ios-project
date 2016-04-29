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

@interface WorkOrderManager()

@property(nonatomic,strong)NSMutableArray *workOrders;

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
    NSNotification * notice = [NSNotification notificationWithName:@"workOrderUpdate" object:nil userInfo:dic];
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

- (void)postWorkOrderStep:(WorkOrder *)workOrder andStep:(NSArray *)steps{
    
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在上传工单步骤";
    hub.userInteractionEnabled = NO;
    NSDictionary *stepDict = @{@"steps":[WorkOrderStep mj_keyValuesArrayWithObjectArray:steps]};
    NSDictionary *dict = @{@"code":workOrder.code,@"status":[NSNumber numberWithInteger:workOrder.status],@"processDetail":stepDict};
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@", OSCAPI_ADDRESS,OSCAPI_POSTWORKORDERSTEP,workOrder.code];
    [HttpUtil post:URLString param:dict finish:^(NSDictionary *obj,NSError *error){
        if (!error) {
            NSMutableArray *attachments = [NSMutableArray new];
            for (WorkOrderStep *step in steps) {
                for(Attachment *attachment in step.attachments)
                {
                    if(!attachment.isUpload){
                        [attachments addObject:attachment];
                    }
                }
                
            }
            if(attachments.count > 0){
                int i= 0;
                for(Attachment *attachment in attachments)
                {
                    i++;
                    hub.labelText = [NSString stringWithFormat:@"正在上传附件"];
                   [self postAttachment:attachment finish:^(NSDictionary *obj,NSError *error) {
                       if (!error) {
                           attachment.isUpload = YES;
                           [attachment updateToDB];
                           if(i == attachments.count)
                           {
                               hub.labelText = [NSString stringWithFormat:@"上传工单步骤成功"];
                               [hub hide:YES afterDelay:1];
                           }
                       }else{
                           NSString *message = @"";
                           if(obj == nil){
                               message =@"上传工单附件失败,请重试";
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
            }else
            {
                hub.labelText = [NSString stringWithFormat:@"上传工单步骤成功"];
                [hub hide:YES afterDelay:1];
            }
        }else{
            
            NSString *message = @"";
            if(obj == nil){
                message =@"上传工单步骤失败,请重试";
            }else{
                message = [obj valueForKey:@"message"];
            }
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = message;
            [hub hide:YES afterDelay:1];
            hub.mode = MBProgressHUDModeCustomView;
            hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            hub.labelText = message;
            [hub hide:YES afterDelay:1];
        }
    }];
}

-(void)postAttachment:(Attachment *)attachment finish:(void (^)(NSDictionary *, NSError *))cb
{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
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
    
    [HttpUtil postFile:URLString file:data name:@"data" fileName:attachment.key param:dict finish:cb];
}

- (void)postPickUpItem{
    
    PickupItemSignature *pick = [PickupItemSignature new];
    pick.salesOrderCode = @"10102-739";
    pick.pickupTime = [Utils formatDate:[NSDate new]];
    pick.signatureImageKey = @"b23f49bc-374c-4749-8229-c3c90d47b3de.jpg";
    pick.itemCodes = @[@"sf01"];
    NSString *json = [pick mj_JSONString];
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_PICKUPITEM];
    [HttpUtil post:URLString json:json finish:^(NSDictionary *obj,NSError *error){
        if (!error) {
           
        }else{
            NSLog(@"提交失败");
        }
    }];
}

-(void)updateTimeStamp :(NSString *)workOrderCode timeStamp:(WorkOrderTimeStamp)timeStamp time:(NSString *)time{
    MBProgressHUD *hub = [Utils createHUD];
    hub.labelText = @"正在提交数据";
    hub.userInteractionEnabled = NO;
    NSDictionary *dict = @{@"timestamp":[NSNumber numberWithInt:timeStamp],@"value":time};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_TIMESTAMP];
    [HttpUtil post:URLString param:dict finish:^(NSDictionary *obj, NSError *error) {
        if(!error){
            hub.labelText = [NSString stringWithFormat:@"上传数据成功"];
            [hub hide:YES afterDelay:1];
            NSDictionary *dic = @{@"timeStamp":[NSNumber numberWithInt:timeStamp]};
            NSNotification * notice = [NSNotification notificationWithName:@"timeStamp" object:nil userInfo:dic];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
        }else{
            NSString *message = @"";
            if(obj == nil){
                message =@"上传数据失败,请重试";
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







@end
