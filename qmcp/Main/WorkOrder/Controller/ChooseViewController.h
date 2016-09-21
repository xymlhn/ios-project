//
//  ChooseViewController.h
//  qmcp
//
//  Created by 谢永明 on 16/7/3.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "BaseViewController.h"
#import "PropertyChoose.h"

@interface ChooseViewController : BaseViewController
@property (nonatomic, strong) NSMutableArray<PropertyChoose *> *chooseCommodityArr;
@end
