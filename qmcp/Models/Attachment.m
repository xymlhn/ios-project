//
//  Attachment.m
//  qmcp
//
//  Created by 谢永明 on 16/4/5.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "Attachment.h"
@implementation Attachment
+ (NSString*)getPrimaryKey
{
    return @"key";
}
+ (NSArray *)mj_allowedPropertyNames
{
    return @[@"type",@"key"];
}
@end