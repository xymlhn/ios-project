//
//  CommodityProperty.h
//  qmcp
//
//  Created by 谢永明 on 16/4/20.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommodityProperty : NSObject
@property (nonatomic,copy) NSString *propertyName;
@property (nonatomic,strong) NSMutableArray *propertyContent;
@end
