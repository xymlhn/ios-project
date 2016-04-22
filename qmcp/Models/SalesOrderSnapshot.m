//
//  SalesOrderSnapshot.m
//  qmcp
//
//  Created by 谢永明 on 16/3/11.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "SalesOrderSnapshot.h"
#import "MJExtension.h"
#import "Utils.h"
@implementation SalesOrderSnapshot

+ (NSString*)getPrimaryKey
{
    return @"code";
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSDate class]) {
        return [Utils stringToDate:oldValue];
    }
    
    return oldValue;
}
MJCodingImplementation;
@end
