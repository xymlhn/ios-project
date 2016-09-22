//
//  BusinessSalesOrder.h
//  qmcp
//
//  Created by 谢永明 on 2016/9/22.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PchHeader.h"
@interface BusinessSalesOrder : NSObject

@property (nonatomic, copy) NSString *contacts;

@property (nonatomic, copy) NSString *mobilePhone;

@property (nonatomic, copy) NSString *fullAddress;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) SalesOrderType salesOrderType;

-(instancetype)initWithName:(NSString *)name
                      phone:(NSString *)phone
                    address:(NSString *)address
                     remark:(NSString *)remark;
@end
