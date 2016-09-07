//
//  Commodity.h
//  qmcp
//
//  Created by 谢永明 on 16/4/19.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commodity : NSObject
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *itemProperties;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *name;
@end
