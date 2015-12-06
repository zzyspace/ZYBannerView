# ZYBannerView
#### 简单易用, 可定制性强的轮播控件


## Features

- [x] 可配置循环滚动效果
- [x] 可配置是否自动滚动, 以及自动滚动时间间隔
- [x] 显示\隐藏Footer
- [x] 自定义pageControl属性
- [x] 支持在Storyboard中创建并配置属性

## Usage

### Basic Usage

> 只需简单地实现2个数据源方法即可

#### 设置数据源与代理

```Objective-C
self.banner = [[ZYBannerView alloc] init];
self.banner.dataSource = self;
```

#### 实现数据源

```Objective-C
// 总共的item数
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner
{
    return 3;
}

// 第`index`个item要显示什么(可以是完全自定义的view, 且无需设置frame)
- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xxx"]];
    return imageView;
}
```

### Advanced Usage

#### Property

是否需要循环滚动, 默认为`NO`
```Objective-C
@property (nonatomic, assign) IBInspectable BOOL shouldLoop;
```

是否显示footer, 默认为`NO` (此属性为`YES`时, `shouldLoop`属性会被置为`NO`)
```Objective-C
@property (nonatomic, assign) IBInspectable BOOL showFooter;
```

是否自动滑动, 默认为`NO`
```Objective-C
@property (nonatomic, assign) IBInspectable BOOL autoScroll;
```

自动滑动间隔时间(s), 默认为 3.0
```Objective-C
@property (nonatomic, assign) IBInspectable NSTimeInterval scrollInterval;
```

pageControl, 可自由配置其属性, 例如`frame`, `pageIndicatorTintColor`, `currentPageIndicatorTintColor`
```Objective-C
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
```

#### Method

```Objective-C
- (void)reloadData;
```

```Objective-C
- (void)startTimer;
- (void)stopTimer;
```

#### DataSource

```Objective-C
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner;
```

```Objective-C
- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index;
```

```Objective-C
- (NSString *)banner:(ZYBannerView *)banner titleForFooterWithState:(ZYBannerFooterState)footerState;
```

#### Delegate

```Objective-C
- (void)banner:(ZYBannerView *)banner didSelectItemAtIndex:(NSInteger)index;
```

```Objective-C
- (void)bannerFooterDidTrigger:(ZYBannerView *)banner;
```

## Requirements

- iOS 7.0+
- Xcode 5.0+

## Installation

- 将ZYBannerView文件夹中拖拽到项目中
- 导入头文件：#import "ZYBannerView.h"

## License

ZYBannerView is released under the MIT license. See LICENSE for details.
