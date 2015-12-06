# ZYBannerView
简单易用, 可定制性强的轮播控件

## Features

- [x] 可配置循环滚动效果
- [x] 可配置是否自动滚动, 以及自动滚动时间间隔
- [x] 显示\隐藏Footer
- [x] 自定义pageControl属性
- [x] 支持在Storyboard中创建并配置属性

## Requirements

- iOS 7.0+
- Xcode 5.0+

## Installation

- 将ZYBannerView文件夹中拖拽到项目中
- 导入头文件：#import "ZYBannerView.h"

## Usage

### Basic Usage (基本使用)

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

## License

ZYBannerView is released under the MIT license. See LICENSE for details.
