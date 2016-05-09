//
//  ZYBannerFooter.h
//
//  Created by 张志延 on 15/10/18.
//  Copyright (c) 2015年 tongbu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZYBannerFooterState) {
    ZYBannerFooterStateIdle = 0,    // 正常状态下的footer提示
    ZYBannerFooterStateTrigger,     // 被拖至触发点的footer提示
};

@interface ZYBannerFooter : UICollectionReusableView

@property (nonatomic, assign) ZYBannerFooterState state;

@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, copy) NSString *idleTitle;
@property (nonatomic, copy) NSString *triggerTitle;

@end
