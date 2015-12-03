//
//  ViewController.m
//  ZYBannerViewDemo
//
//  Created by ZZY on 15/11/25.
//  Copyright (c) 2015年 mrdream. All rights reserved.
//

#import "ViewController.h"
#import "ZYBannerView.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kNavigationBarHeight  64
#define kBannerHeight 144

@interface ViewController () <ZYBannerViewDataSource, ZYBannerViewDelegate>

@property (nonatomic, strong) ZYBannerView *banner;
@property (weak, nonatomic) IBOutlet ZYBannerView *storyboardBanner;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.banner];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.banner.frame = CGRectMake(0,
                                   kNavigationBarHeight,
                                   kScreenWidth,
                                   kBannerHeight);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - ZYBannerViewDataSource

- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner
{
    return 3;
}

- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad_%ld", index+1]];
    
    return imageView;
}

#pragma mark - ZYBannerViewDelegate

- (void)banner:(ZYBannerView *)banner didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点击了%ld行", index);
}

- (void)bannerFooterDidTrigger:(ZYBannerView *)banner
{
    NSLog(@"拖动了Footer");
}

#pragma mark - getter

- (ZYBannerView *)banner
{
    if (!_banner) {
        _banner = [[ZYBannerView alloc] init];
        _banner.showFooter = YES;
        _banner.disableAutoScroll = YES;
        _banner.dataSource = self;
        _banner.delegate = self;
    }
    return _banner;
}

@end
