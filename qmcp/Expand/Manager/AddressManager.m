//
//  AddressManager.m
//  qmcp
//
//  Created by 谢永明 on 16/9/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "AddressManager.h"
#import "MJExtension.h"

@interface AddressManager()

@property (nonatomic,strong) NSArray *addressArr; // 解析出来的最外层数组
@property (nonatomic,strong) NSArray *provinceArr; // 省

@end

@implementation AddressManager
+ (AddressManager *)getInstance {
    static AddressManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"json"];
        NSLog(@"%@",path);
        NSString *jsonStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
        shared_manager.addressArr = [jsonStr mj_JSONObject];
        
        NSMutableArray *firstName = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in shared_manager.addressArr)
        {
            NSString *name = dict.allKeys.firstObject;
            [firstName addObject:name];
        }
        // 第一层是省份 分解出整个省份数组
        shared_manager.provinceArr = firstName;
        
    });
    return shared_manager;
}

-(NSArray *)getProvince{
    return self.provinceArr;
}

-(NSArray *)getCity:(NSInteger)index{
    NSMutableArray *cityNameArr = [[NSMutableArray alloc] init];
    for (NSDictionary *cityName in [self.addressArr[index] allValues].firstObject) {
        NSString *name1 = cityName.allKeys.firstObject;
        [cityNameArr addObject:name1];
    }
    return cityNameArr;
}

-(NSArray *)getDistanceByProvinceIndex:(NSInteger)indexProvince andCityIndex:(NSInteger)indexCity{
    NSArray *distanceArr = [[self.addressArr[indexProvince] allValues][0][indexCity] allValues][0];
    return distanceArr;
}

@end
