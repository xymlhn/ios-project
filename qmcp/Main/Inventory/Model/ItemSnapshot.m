//
//  ItemSnapshot.m
//  qmcp
//
//  Created by 谢永明 on 16/3/11.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "ItemSnapshot.h"

@implementation ItemSnapshot

+ (NSString*)getPrimaryKey
{
    return @"itemSnapshotCode";
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"commodities":@"CommoditySnapshot",
             @"attachments":@"Attachment"};
}
@end
