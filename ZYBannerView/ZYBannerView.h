//
//  ZYBannerView.h
//
//  Created by 张志延 on 15/10/17.
//  Copyright (c) 2015年 tongbu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYBannerFooter.h"

@protocol ZYBannerViewDataSource, ZYBannerViewDelegate;

@interface ZYBannerView : UIView

/** 是否需要循环滚动, 默认为 NO */
@property (nonatomic, assign) IBInspectable BOOL shouldLoop;

/** 是否显示footer, 默认为 NO (此属性为YES时, shouldLoop会被置为NO) */
@property (nonatomic, assign) IBInspectable BOOL showFooter;

/** 是否自动滑动, 默认为 NO */
@property (nonatomic, assign) IBInspectable BOOL autoScroll;

/** 自动滑动间隔时间(s), 默认为 3.0 */
@property (nonatomic, assign) IBInspectable CGFloat scrollInterval;

/** pageControl, 可自由配置其属性 */
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
@property (nonatomic, assign, readwrite)  CGRect pageControlFrame;

@property (nonatomic, weak) IBOutlet id<ZYBannerViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<ZYBannerViewDelegate> delegate;

- (void)reloadData;

- (void)startTimer;
- (void)stopTimer;

@end

@protocol ZYBannerViewDataSource <NSObject>
@required

- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner;
- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index;

@optional

- (NSString *)banner:(ZYBannerView *)banner titleForFooterWithState:(ZYBannerFooterState)footerState;

@end

@protocol ZYBannerViewDelegate <NSObject>
@optional

- (void)banner:(ZYBannerView *)banner didSelectItemAtIndex:(NSInteger)index;
- (void)bannerFooterDidTrigger:(ZYBannerView *)banner;

@end
