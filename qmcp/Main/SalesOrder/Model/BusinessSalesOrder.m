//
//  BusinessSalesOrder.m
//  qmcp
//
//  Created by 谢永明 on 2016/9/22.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BusinessSalesOrder.h"

@implementation BusinessSalesOrder

-(instancetype)initWithName:(NSString *)name
                      phone:(NSString *)phone
                    address:(NSString *)address
                     remark:(NSString *)remark{
    BusinessSalesOrder *businessSalesOrder = [BusinessSalesOrder new];
    businessSalesOrder.contacts = name;
    businessSalesOrder.mobilePhone = phone;
    businessSalesOrder.fullAddress = address;
    businessSalesOrder.remark = remark;
    return businessSalesOrder;
}
@end
