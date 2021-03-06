//
//  ScanImageViewController.m
//  二维码扫描
//
//  Created by cartman on 16/03/9.
//  Copyright © 2016年 chris. All rights reserved.
//

#import "QrCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PchHeader.h"

#define SCANVIEW_EdgeTop 70.0
#define SCANVIEW_EdgeLeft 50.0
#define TINTCOLOR_ALPHA 0.2 //浅色透明度
#define DARKCOLOR_ALPHA 0.3 //深色透明度


static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";
@interface QrCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>{
    //设置扫描画面
    UIView *_scanView;
    NSTimer *_timer;
    
    UIView *_QrCodeline;
    UIView *_QrCodeline1;
    UIImageView *_scanCropView;//扫描窗口
    UIButton *_lightButton;//灯光按钮
    AVCaptureSession *_captureSession;
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
    
    
}

@end

@implementation QrCodeViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self stopTimer];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    //初始化扫描界面
    [self setScanView];
    
    [self startReading];
    //启动定时器
    [self createTimer];
    
}

- (BOOL)startReading{
    // 获取 AVCaptureDevice 实例
    NSError * error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    //提高图片质量为1080P，提高识别效果
    _captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
    // 添加输入流
    [_captureSession addInput:input];
    // 初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //设置扫描范围
    captureMetadataOutput.rectOfInterest =CGRectMake((_scanCropView.frame.origin.y-10)/kScreen_Height, (_scanCropView.frame.origin.x-10)/ kScreen_Width, (_scanCropView.frame.size.width+10)/kScreen_Height, (_scanCropView.frame.size.height+10)/kScreen_Width);
    // 添加输出流
    [_captureSession addOutput:captureMetadataOutput];
    
    // 创建dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    captureMetadataOutput.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [_videoPreviewLayer setFrame:_scanView.layer.bounds];
    [_scanView.layer insertSublayer:_videoPreviewLayer atIndex:0];
    // 开始会话
    [_captureSession startRunning];
    
    return YES;
}

- (void)stopReading{
    // 停止会话
    [_captureSession stopRunning];
    _captureSession = nil;
}

#pragma AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        result = metadataObj.stringValue;
        if (result == nil) {
            kTipAlert(@"条码无数据");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用代理对象的协议方法来实现数据传递
            [self.navigationController popViewControllerAnimated:YES];
            if (self.doneBlock) {
                self.doneBlock(result);
            }
        });
        [self stopReading];
    }
    return;
}

+(instancetype)doneBlock:(void (^)(NSString *))block{
    
    QrCodeViewController *vc = [[QrCodeViewController alloc] init];
    vc.doneBlock = block;
    return vc;
    
}

- (void)createTimer{
    _timer=[NSTimer scheduledTimerWithTimeInterval:2.2 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
}

- (void)stopTimer{
    if ([_timer isValid] == YES) {
        [_timer invalidate];
        _timer = nil;
    }
    
}

//二维码的扫描区域
- (void)setScanView{
    _scanView=[[UIView alloc] initWithFrame:CGRectMake(0,0, kScreen_Width,kScreen_Height )];
    _scanView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_scanView];
    
    //最上部view
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreen_Width,SCANVIEW_EdgeTop)];
    upView.alpha =TINTCOLOR_ALPHA;
    upView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft,kScreen_Width - 2 * SCANVIEW_EdgeLeft)];
    leftView.alpha =TINTCOLOR_ALPHA;
    leftView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:leftView];
    
    // 中间扫描区
    _scanCropView=[[UIImageView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, kScreen_Width - 2 * SCANVIEW_EdgeLeft, kScreen_Width - 2 * SCANVIEW_EdgeLeft)];
    //scanCropView.image=[UIImage imageNamed:@""];
    _scanCropView.layer.borderColor=[UIColor greenColor].CGColor;
    _scanCropView.layer.borderWidth=2.0;
    _scanCropView.backgroundColor=[UIColor clearColor];
    [_scanView addSubview:_scanCropView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width - SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft, kScreen_Width - 2 * SCANVIEW_EdgeLeft)];
    rightView.alpha =TINTCOLOR_ALPHA;
    rightView.backgroundColor = [UIColor blackColor];
    [_scanView addSubview:rightView];
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Width - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop, kScreen_Width, kScreen_Height - (kScreen_Width - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop))];
    //downView.alpha = TINTCOLOR_ALPHA;
    downView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:TINTCOLOR_ALPHA];
    [_scanView addSubview:downView];
    
    //用于说明的label
    UILabel *labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(0,5, kScreen_Width,20);
    labIntroudction.numberOfLines=1;
    labIntroudction.font=[UIFont systemFontOfSize:15.0];
    labIntroudction.textAlignment=NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码对准方框，即可自动扫描";
    [downView addSubview:labIntroudction];
    
    //用于开关灯操作的button
    _lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _lightButton.frame =CGRectMake(0, 40, kScreen_Width, 40);
    [_lightButton setTitle:@"开启闪光灯" forState:UIControlStateNormal];
    [_lightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _lightButton.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:DARKCOLOR_ALPHA];
    _lightButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    _lightButton.titleLabel.font=[UIFont systemFontOfSize:15.0];
    [_lightButton addTarget:self action:@selector(openLight) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:_lightButton];
    
    //画中间的基准线
    _QrCodeline = [[UIView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, kScreen_Width- 2 * SCANVIEW_EdgeLeft, 2)];
    _QrCodeline.backgroundColor = [UIColor greenColor];
    [_scanView addSubview:_QrCodeline];
    
    //画中间的基准线
    _QrCodeline1 = [[UIView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, kScreen_Width- 2 * SCANVIEW_EdgeLeft, 2)];
    _QrCodeline1.backgroundColor = [UIColor greenColor];
    [_scanView addSubview:_QrCodeline1];
    
    // 先让第二根线运动一次,避免定时器执行的时差,让用户感到启动App后,横线就开始移动
    [UIView animateWithDuration:2.2 animations:^{
        
        _QrCodeline1.frame = CGRectMake(SCANVIEW_EdgeLeft, kScreen_Width - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop - 2, kScreen_Width - 2 * SCANVIEW_EdgeLeft, 1);
    }];
    
    
}

// 当地一根线到达底部时,第二根线开始下落运动,此时第一根线已经在顶部,当第一根线接着下落时,第二根线到达顶部.依次循环
- (void)moveUpAndDownLine{
    CGFloat Y = _QrCodeline.frame.origin.y;
    if (Y == SCANVIEW_EdgeTop) {
        [UIView animateWithDuration:2.2 animations:^{
            
            _QrCodeline.frame = CGRectMake(SCANVIEW_EdgeLeft, kScreen_Width - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop - 2, kScreen_Width - 2 * SCANVIEW_EdgeLeft, 1);
        }];
        _QrCodeline1.frame = CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, kScreen_Width - 2 * SCANVIEW_EdgeLeft, 1);
    }
    else if (Y == kScreen_Width - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop - 2) {
        _QrCodeline.frame = CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, kScreen_Width - 2 * SCANVIEW_EdgeLeft, 1);
        [UIView animateWithDuration:2.2 animations:^{
            
            _QrCodeline1.frame = CGRectMake(SCANVIEW_EdgeLeft, kScreen_Width - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop - 2, kScreen_Width - 2 * SCANVIEW_EdgeLeft, 1);
        }];
    }
    
}

//照明灯光
-(void)openLight{
    if ([_lightButton.titleLabel.text isEqualToString:@"开启闪光灯"]) {
        [self systemLightSwitch:YES];
    } else {
        [self systemLightSwitch:NO];
    }
}

- (void)systemLightSwitch:(BOOL)open{
    if (open) {
        [_lightButton setTitle:@"关闭闪光灯" forState:UIControlStateNormal];
    } else {
        [_lightButton setTitle:@"开启闪光灯" forState:UIControlStateNormal];
    }
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (open) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
