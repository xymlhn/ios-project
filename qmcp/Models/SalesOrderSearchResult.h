//
//  SalesOrderSearchResult.h
//  qmcp
//
//  Created by 谢永明 on 16/8/15.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SalesOrderSearchResult : NSObject
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *salesOrderCode;
@property (nonatomic,copy) NSString *salesOrderCreationTime;
@end
