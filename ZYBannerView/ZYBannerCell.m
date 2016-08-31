//
//  ZYBannerCell.m
//
//  Created by 张志延 on 15/10/17.
//  Copyright (c) 2015年 tongbu. All rights reserved.
//

#import "ZYBannerCell.h"

@implementation ZYBannerCell
@synthesize itemView = _itemView;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.itemView.frame = self.bounds;
}

- (UIView *)itemView
{
    if (!_itemView) {
        _itemView = [[UIView alloc] init];
    }
    return _itemView;
}

- (void)setItemView:(UIView *)itemView
{
    if (_itemView) {
        [_itemView removeFromSuperview];
    }
    
    _itemView = itemView;
    
    [self addSubview:_itemView];
}

@end
