//
//  ZYBannerFooter.h
//  DuoBao
//
//  Created by 张志延 on 15/10/18.
//  Copyright (c) 2015年 tongbu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZYBannerFooterState) {
    ZYBannerFooterStateIdle = 0,
    ZYBannerFooterStateTrigger,
};

@interface ZYBannerFooter : UICollectionReusableView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *arrowView;

@end
