//
//  ScanViewController.h
//  qmcp
//
//  Created by 谢永明 on 16/4/6.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanImageView<NSObject>

- (void)reportScanResult:(NSString *)result;

@end

@interface ScanViewController : UIViewController

/**
 *  代理方法传递数据
 */
@property (nonatomic,weak)id <ScanImageView>delegate;

@end
