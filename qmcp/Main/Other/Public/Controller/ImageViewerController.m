//
//  ImageViewerController.m
//  iosapp
//
//  Created by chenhaoxiang on 11/12/14.
//  Copyright (c) 2014 oschina. All rights reserved.
//


// 参考 https://github.com/bogardon/GGFullscreenImageViewController

#import "ImageViewerController.h"
#import "Utils.h"
#import "Masonry.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>

@interface ImageViewerController () <UIScrollViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *delButton;
@property (nonatomic, assign) BOOL zoomOut;
@property (nonatomic, assign) BOOL *showDelete;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation ImageViewerController

#pragma mark - init method

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    
    return self;
}

- (instancetype)initWithImageURL:(NSURL *)imageURL showDelete:(BOOL)show
{
    self = [self init];
    if (self) {
        _imageURL = imageURL;
        _showDelete = &show;
    }
    
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self configureScrollView];
    [self configureImageView];
    
    if (_key) {
         UIImage *image = [Utils loadImage:_key];
        _imageView.image = image;
        _imageView.frame = [self frameForImage:image];
        _scrollView.contentSize = [self contentSizeForImage:image];
    } else {
        if (![[SDWebImageManager sharedManager] cachedImageExistsForURL:_imageURL]) {
            _HUD = [Utils createHUD];
            _HUD.mode = MBProgressHUDModeAnnularDeterminate;
            [_HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)]];
        }
        
        [_imageView sd_setImageWithURL:_imageURL
                      placeholderImage:nil
                               options:SDWebImageProgressiveDownload | SDWebImageContinueInBackground
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                  _HUD.progress = (CGFloat)receivedSize / (CGFloat)expectedSize;
                              }
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 [_HUD hide:YES];
                                 
                                 _imageView.frame = [self frameForImage:image];
                                 _scrollView.contentSize = [self contentSizeForImage:image];
                             }];
    }
    
    _delButton = [UIButton new];
    [_delButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.view addSubview:_delButton];
    [_delButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view.mas_top).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.width.mas_equalTo(@30);
        make.height.mas_equalTo(@30);
    }];
    [_delButton addTarget:self action:@selector(showDelCancelAlert) forControlEvents:UIControlEventTouchUpInside];
    [_delButton setHidden:_showDelete];
    
}

- (void)configureScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = 2;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
}

- (void)configureImageView
{
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_imageView];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:singleTap];
}

- (CGSize)contentSizeForImage:(UIImage *)image
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat contentHeight = screenWidth * image.size.height / image.size.width;
    return CGSizeMake(screenWidth, contentHeight);
}

- (CGRect)frameForImage:(UIImage *)image
{
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat imageHeight = width / image.size.width * image.size.height;
    CGFloat y = imageHeight > screenHeight ? 0 : (screenHeight - imageHeight) / 2;
    
    return CGRectMake(0, y, width, imageHeight);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

// http://stackoverflow.com/questions/1316451/center-content-of-uiscrollview-when-smaller

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.bounds.size.width > scrollView.contentSize.width ?
                      (scrollView.bounds.size.width - scrollView.contentSize.width) / 2 : 0;
    
    CGFloat offsetY = scrollView.bounds.size.height > scrollView.contentSize.height ?
                      (scrollView.bounds.size.height - scrollView.contentSize.height) / 2 : 0;
    
    _imageView.center = CGPointMake(scrollView.contentSize.width / 2 + offsetX,
                                    scrollView.contentSize.height / 2 + offsetY);
}

#pragma mark - handle gesture

- (void)handleSingleTap
{
    [_HUD hide:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)recognizer
{
    CGFloat power = _zoomOut ? 1/_scrollView.maximumZoomScale : _scrollView.maximumZoomScale;
    _zoomOut = !_zoomOut;
    
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    CGFloat newZoomScale = _scrollView.zoomScale * power;
    
    CGSize scrollViewSize = _scrollView.bounds.size;
    
    CGFloat width = scrollViewSize.width / newZoomScale;
    CGFloat height = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (width / 2.0f);
    CGFloat y = pointInView.y - (height / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, width, height);
    
    [_scrollView zoomToRect:rectToZoomTo animated:YES];
}

// from https://github.com/ideaismobile/IDMPhotoBrowser

- (void)panGestureRecognized:(id)sender
{
    CGFloat bottomOffset = _scrollView.contentSize.height - _scrollView.bounds.size.height;
    BOOL isInContentRegion = _scrollView.contentOffset.y > 0 && _scrollView.contentOffset.y < bottomOffset;
    
    if (isInContentRegion || _zoomOut) {
        return;
    }
    
    static float firstX, firstY;
    
    float viewHeight = _scrollView.frame.size.height;
    float viewHalfHeight = viewHeight / 2;
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer *)sender translationInView:self.view];
    
    if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
        firstX = _scrollView.center.x;
        firstY = _scrollView.center.y;
        
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    translatedPoint = CGPointMake(firstX, firstY + translatedPoint.y);
    [_scrollView setCenter:translatedPoint];
    
    float newY = _scrollView.center.y - viewHalfHeight;
    float newAlpha = 1 - fabsf(newY) / viewHeight;
    
    self.view.opaque = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:newAlpha];
    
    // Gesture Ended
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        if (_scrollView.center.y > viewHalfHeight + 100 || _scrollView.center.y < viewHalfHeight - 100) { // Automatic Dismiss View
            
            CGFloat finalX = firstX, finalY;
            
            CGFloat windowsHeigt = self.view.frame.size.height;
            
            if (_scrollView.center.y > viewHalfHeight + 30) { // swipe down
                finalY = windowsHeigt * 2;
            } else { // swipe up
                finalY = -viewHalfHeight;
            }
            
            CGFloat animationDuration = 0.35;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDelegate:self];
            [_scrollView setCenter:CGPointMake(finalX, finalY)];
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            [UIView commitAnimations];
            
            self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self dismissViewControllerAnimated:YES completion:nil];
        } else { // Continue Showing View
            [self setNeedsStatusBarAppearanceUpdate];
            
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
            
            CGFloat velocityY = (0.35 * [(UIPanGestureRecognizer *)sender velocityInView:self.view].y);
            
            CGFloat finalX = firstX;
            CGFloat finalY = viewHalfHeight;
            
            CGFloat animationDuration = (ABS(velocityY) * 0.0002) + 0.2;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationDuration];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDelegate:self];
            [_scrollView setCenter:CGPointMake(finalX, finalY)];
            [UIView commitAnimations];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

//下载保存图片
- (void)deletePicture{
    dispatch_async(dispatch_get_main_queue(), ^{
        //调用代理对象的协议方法来实现数据传递
        [self dismissViewControllerAnimated:YES completion:nil];
        if (self.doneBlock) {
            self.doneBlock(_key);
        }
    });
}
- (void)showDelCancelAlert {
    NSString *title = @"提示";
    NSString *message = @"是否删除图片？";
    NSString *cancelButtonTitle = @"否";
    NSString *otherButtonTitle = @"是";
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf deletePicture];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

+(instancetype)initWithImageKey:(NSString *)key doneBlock:(void (^)(NSString *))block{
    
    ImageViewerController *vc = [[ImageViewerController alloc] init];
    vc.doneBlock = block;
    vc.key = key;
    return vc;
}

+(instancetype)initWithImageKey:(NSString *)key showDelete:(BOOL)show{
    ImageViewerController *vc = [[ImageViewerController alloc] init];
    vc.key = key;
    vc.showDelete = &(show);
    return vc;
}

@end
