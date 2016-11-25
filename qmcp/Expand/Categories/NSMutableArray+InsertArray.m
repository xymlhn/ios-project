//
//  NSMutableArray+InsertArray.m
//  qmcp
//
//  Created by 谢永明 on 16/6/13.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "NSMutableArray+InsertArray.h"

@implementation NSMutableArray (InsertArray)
- (void)insertArray:(NSArray *)newAdditions atIndex:(int)index{
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for(int i = index;i < newAdditions.count+index;i++)
    {
        [indexes addIndex:i];
    }
    [self insertObjects:newAdditions atIndexes:indexes];
}
@end
