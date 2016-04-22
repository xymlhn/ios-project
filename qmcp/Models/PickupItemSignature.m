//
//  PickupItemSignature.m
//  qmcp
//
//  Created by 谢永明 on 16/4/14.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "PickupItemSignature.h"
#import "MJExtension.h"
@implementation PickupItemSignature

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"pickupTime"]) {
        if (oldValue == nil) return @"";
    } else if (property.type.typeClass == [NSDate class]) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt dateFromString:oldValue];
    }
    return oldValue;
}
@end
