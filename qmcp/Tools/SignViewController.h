//
//  SignViewController.h
//  qmcp
//
//  Created by 谢永明 on 16/4/17.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignView<NSObject>

- (void)reportSignImage:(UIImage *)image;

@end
@interface SignViewController : UIViewController

/**
 *  代理方法传递数据
 */
@property (nonatomic,weak)id <SignView>delegate;

@end
