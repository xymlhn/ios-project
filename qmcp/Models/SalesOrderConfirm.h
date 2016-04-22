//
//  SalesOrderConfirm.h
//  qmcp
//
//  Created by 谢永明 on 16/4/17.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SalesOrderConfirm : NSObject

@property (nonatomic,strong) NSArray *unconfirmed;

@property (nonatomic,strong) NSArray *haveConfirmed;
@end
