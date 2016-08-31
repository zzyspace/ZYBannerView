//
//  ZYBannerView.m
//
//  Created by 张志延 on 15/10/17.
//  Copyright (c) 2015年 tongbu. All rights reserved.
//

#import "ZYBannerView.h"
#import "ZYBannerCell.h"

// 总共的item数
#define ZY_TOTAL_ITEMS (self.itemCount * 20000)

#define ZY_FOOTER_WIDTH 64.0
#define ZY_PAGE_CONTROL_HEIGHT 32.0

@interface ZYBannerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) ZYBannerFooter *footer;
@property (nonatomic, strong, readwrite) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZYBannerView

@synthesize scrollInterval = _scrollInterval;
@synthesize autoScroll = _autoScroll;
@synthesize shouldLoop =_shouldLoop;
@synthesize pageControl = _pageControl;

static NSString *banner_item = @"banner_item";
static NSString *banner_footer = @"banner_footer";

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateSubviewsFrame];
}

- (void)updateSubviewsFrame
{
    // collectionView
    self.flowLayout.itemSize = self.bounds.size;
    self.flowLayout.footerReferenceSize = CGSizeMake(ZY_FOOTER_WIDTH, self.frame.size.height);
    self.collectionView.frame = self.bounds;
    [self.collectionView reloadData];
    
    // pageControl
    if (CGRectEqualToRect(self.pageControlFrame, CGRectZero)) {
        // 若未对pageControl设置过frame, 则使用以下默认frame
        CGFloat w = self.frame.size.width;
        CGFloat h = ZY_PAGE_CONTROL_HEIGHT;
        CGFloat x = 0;
        CGFloat y = self.frame.size.height - h;
        self.pageControl.frame = CGRectMake(x, y, w, h);
    }
}

// 配置默认起始位置
- (void)fixDefaultPosition
{
    if (self.itemCount == 0) {
        return;
    }
    
    if (self.shouldLoop) {
        // 总item数的中间
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(ZY_TOTAL_ITEMS / 2) inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            self.pageControl.currentPage = 0;
        });
    } else {
        // 第0个item
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            self.pageControl.currentPage = 0;
        });
    }
}

#pragma mark - Reload

- (void)reloadData
{
    if (!self.dataSource || self.itemCount == 0) {
        return;
    }
    
    // 设置pageControl总页数
    self.pageControl.numberOfPages = self.itemCount;
    
    // 刷新数据
    [self.collectionView reloadData];
    
    // 开启定时器
    [self startTimer];
}

#pragma mark - NSTimer

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startTimer
{
    if (!self.autoScroll) return;
    
    [self stopTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(autoScrollToNextItem) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 定时器方法
- (void)autoScrollToNextItem
{
    if (self.itemCount == 0 ||
        self.itemCount == 1 ||
        !self.autoScroll)
    {
        return;
    }
    
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    NSUInteger currentItem = currentIndexPath.item;
    NSUInteger nextItem = currentItem + 1;
    
    if(nextItem >= ZY_TOTAL_ITEMS) {
        return;
    }
    
    if (self.shouldLoop)
    {
        // 无限往下翻页
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:YES];
    } else {
        if ((currentItem % self.itemCount) == self.itemCount - 1) {
            // 当前最后一张, 回到第0张
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft
                                                animated:YES];
        } else {
            // 往下翻页
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft
                                                animated:YES];
        }
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.shouldLoop) {
        return ZY_TOTAL_ITEMS;
    } else {
        return self.itemCount;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZYBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:banner_item forIndexPath:indexPath];
 
    if ([self.dataSource respondsToSelector:@selector(banner:viewForItemAtIndex:)]) {
        cell.itemView = [self.dataSource banner:self viewForItemAtIndex:indexPath.item % self.itemCount];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)theCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)theIndexPath
{
    UICollectionReusableView *footer = nil;
    
    if(kind == UICollectionElementKindSectionFooter)
    {
        footer = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:banner_footer forIndexPath:theIndexPath];
        self.footer = (ZYBannerFooter *)footer;
        
        // 配置footer的提示语
        if ([self.dataSource respondsToSelector:@selector(banner:titleForFooterWithState:)]) {
            self.footer.idleTitle = [self.dataSource banner:self titleForFooterWithState:ZYBannerFooterStateIdle];
            self.footer.triggerTitle = [self.dataSource banner:self titleForFooterWithState:ZYBannerFooterStateTrigger];
        }
    }
    
    if (self.showFooter) {
        self.footer.hidden = NO;
    } else {
        self.footer.hidden = YES;
    }
    
    return footer;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(banner:didSelectItemAtIndex:)]) {
        [self.delegate banner:self didSelectItemAtIndex:(indexPath.item % self.itemCount)];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentIndexPath = [[collectionView indexPathsForVisibleItems] firstObject];
    self.pageControl.currentPage = currentIndexPath.item % self.itemCount;
}


#pragma mark - UIScrollViewDelegate
#pragma mark timer相关

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 用户滑动的时候停止定时器
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 用户停止滑动的时候开启定时器
    [self startTimer];
}

#pragma mark footer相关

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.showFooter) return;
    
    static CGFloat lastOffset;
    CGFloat footerDisplayOffset = (scrollView.contentOffset.x - (self.frame.size.width * (self.itemCount - 1)));
    
    // footer的动画
    if (footerDisplayOffset > 0)
    {
        // 开始出现footer
        if (footerDisplayOffset > ZY_FOOTER_WIDTH) {
            if (lastOffset > 0) return;
            self.footer.state = ZYBannerFooterStateTrigger;
        } else {
            if (lastOffset < 0) return;
            self.footer.state = ZYBannerFooterStateIdle;
        }
        lastOffset = footerDisplayOffset - ZY_FOOTER_WIDTH;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!self.showFooter) return;

    CGFloat footerDisplayOffset = (scrollView.contentOffset.x - (self.frame.size.width * (self.itemCount - 1)));
    
    // 通知footer代理
    if (footerDisplayOffset > ZY_FOOTER_WIDTH) {
        if ([self.delegate respondsToSelector:@selector(bannerFooterDidTrigger:)]) {
            [self.delegate bannerFooterDidTrigger:self];
        }
    }
}

#pragma mark - setters & getters
#pragma mark 属性

/**
 *  数据源
 */
- (void)setDataSource:(id<ZYBannerViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    // 刷新数据
    [self reloadData];
    
    // 配置默认起始位置
    [self fixDefaultPosition];
}

- (NSInteger)itemCount
{
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInBanner:)]) {
        return [self.dataSource numberOfItemsInBanner:self];
    }
    return 0;
}

/**
 *  是否需要循环滚动
 */
- (void)setShouldLoop:(BOOL)shouldLoop
{
    _shouldLoop = shouldLoop;
    
    [self reloadData];
    
    // 重置默认起始位置
    [self fixDefaultPosition];
}

- (BOOL)shouldLoop
{
    if (self.showFooter) {
        // 如果footer存在就不应该有循环滚动
        return NO;
    }
    if (self.itemCount == 1) {
        // 只有一个item也不应该有循环滚动
        return NO;
    }
    return _shouldLoop;
}

/**
 *  是否显示footer
 */
- (void)setShowFooter:(BOOL)showFooter
{
    _showFooter = showFooter;
    
    [self reloadData];
}

/**
 *  是否自动滑动
 */
- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    if (autoScroll) {
        [self startTimer];
    } else {
        [self stopTimer];
    }
}

- (BOOL)autoScroll
{
    if (self.itemCount < 2) {
        // itemCount小于2时, 禁用自动滚动
        return NO;
    }
    return _autoScroll;
}

/**
 *  自动滑动间隔时间
 */
- (void)setScrollInterval:(CGFloat)scrollInterval
{
    _scrollInterval = scrollInterval;
    
    [self startTimer];
}

- (CGFloat)scrollInterval
{
    if (!_scrollInterval) {
        _scrollInterval = 3.0; // default
    }
    return _scrollInterval;
}

#pragma mark 控件

/**
 *  collectionView
 */
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.alwaysBounceHorizontal = YES; // 小于等于一页时, 允许bounce
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        // 注册cell
        [_collectionView registerClass:[ZYBannerCell class] forCellWithReuseIdentifier:banner_item];
        
        // 注册 \ 配置footer
        [_collectionView registerClass:[ZYBannerFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:banner_footer];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, -ZY_FOOTER_WIDTH);
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
    }
    return _flowLayout;
}

/**
 *  pageControl
 */
- (void)setPageControl:(UIPageControl *)pageControl
{
    // 移除旧oageControl
    [_pageControl removeFromSuperview];
    
    // 赋值
    _pageControl = pageControl;
    
    // 添加新pageControl
    _pageControl.userInteractionEnabled = NO;
    _pageControl.autoresizingMask = UIViewAutoresizingNone;
    _pageControl.backgroundColor = [UIColor redColor];
    [self addSubview:_pageControl];
    
    [self reloadData];
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.autoresizingMask = UIViewAutoresizingNone;
    }
    return _pageControl;
}

- (void)setPageControlFrame:(CGRect)pageControlFrame
{
    _pageControlFrame = pageControlFrame;
    
    self.pageControl.frame = pageControlFrame;
}

@end
