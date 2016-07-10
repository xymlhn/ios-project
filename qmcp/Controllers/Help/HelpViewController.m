//
//  HelpViewController.m
//  qmcp
//
//  Created by 谢永明 on 16/4/18.
//  Copyright © 2016年 inforshare. All rights reserved.
//

#import "HelpViewController.h"
#import "Masonry.h"
#import "OSCAPI.h"
#import "MBProgressHUD.h"
#import "Utils.h"
@interface HelpViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) MBProgressHUD *hub;
@property (nonatomic ,strong) UIWebView *webView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助";
    _webView = [UIWebView new];
    _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    _hub = [Utils createHUD];
    _hub.labelText = @"正在加载";
    _hub.userInteractionEnabled = NO;    NSString *URLString = [NSString stringWithFormat:@"%@%@", OSCAPI_ADDRESS,OSCAPI_MANUAL];
    NSURL* url = [NSURL URLWithString:URLString];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_webView loadRequest:request];//加载
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[request URL] absoluteString]]]];
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    _hub.mode = MBProgressHUDModeCustomView;
    _hub.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
    _hub.labelText = [NSString stringWithFormat:@"加载成功"];
    [_hub hide:YES afterDelay:0.5];
}

@end
