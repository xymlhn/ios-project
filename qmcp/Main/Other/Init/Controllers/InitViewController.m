//
//  InitViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/21.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "InitViewController.h"
#import "AppManager.h"
#import "User.h"
@interface InitViewController ()

@end

@implementation InitViewController

-(void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [UIImageView new];
    imageView.image=[UIImage imageNamed:@"start_page"];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(void)loadData{
    NSArray *accountAndPassword = [Config getUserNameAndPassword];
    NSString *name = accountAndPassword? accountAndPassword[0] : @"";
    NSString *password = accountAndPassword? accountAndPassword[1] : @"";
    [[AppManager getInstance] reLoginWithUserName:name andPassword:password finishBlock:^(NSDictionary *data, NSString *error) {
        NSDictionary *dict;
        if(error == nil){
            User *account = [User mj_objectWithKeyValues:data];
            if(account.authenticated){
                dict = @{@"info":@"0"};
            }else{
                dict = @{@"info":@"1"};
            }
        }else{
            dict = @{@"info":@"1"};
        }
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:kReloginNotification object:nil userInfo:dict];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
    }];
}
@end
