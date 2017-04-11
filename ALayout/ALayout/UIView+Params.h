//
//  UIView+Params.h
//  RMLayout
//
//  Created by Splendour Bell on 2017/4/8.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayoutDirection.h"

@interface ViewParams : NSObject

@end

typedef enum
{
    Visibility_VISIBLE      = 0x00000000,
    Visibility_INVISIBLE    = 0x00000004,
    Visibility_GONE         = 0x00000008
} VisibilityMode;


enum
{
    VIEW_LAYOUT_DIRECTION_UNDEFINED             = LayoutDirection_UNDEFINED,
    VIEW_LAYOUT_DIRECTION_LTR                   = LayoutDirection_LTR,
    VIEW_LAYOUT_DIRECTION_RTL                   = LayoutDirection_RTL,
    VIEW_LAYOUT_DIRECTION_INHERIT               = LayoutDirection_INHERIT,
    VIEW_LAYOUT_DIRECTION_LOCALE                = LayoutDirection_LOCALE,
    VIEW_PFLAG2_LAYOUT_DIRECTION_MASK_SHIFT     = 2,
    VIEW_PFLAG2_LAYOUT_DIRECTION_MASK           = 0x00000003 << VIEW_PFLAG2_LAYOUT_DIRECTION_MASK_SHIFT,
    VIEW_PFLAG2_LAYOUT_DIRECTION_RESOLVED_RTL   = 4          << VIEW_PFLAG2_LAYOUT_DIRECTION_MASK_SHIFT
};

@interface UIView(Params)

@property (nonatomic) int measuredWidth;
@property (nonatomic) int measuredHeight;

- (ViewParams*)viewParams;

- (void)setViewAttr:(NSDictionary*)attr;

- (VisibilityMode)visibility;

- (void)setVisibility:(VisibilityMode)visibilityMode;

- (int)layoutDirection;

- (BOOL)isLayoutRtl;

- (int)paddingLeft;
- (int)paddingRight;
- (int)paddingTop;
- (int)paddingBottom;

- (int)baseline;

//
- (void)measure:(int)widthMeasureSpec heightSpec:(int)heightMeasureSpec;

@end

