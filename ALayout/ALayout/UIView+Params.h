//
//  UIView+Params.h
//  RMLayout
//
//  Created by Splendour Bell on 2017/4/8.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayoutDirection.h"
#import "LayoutParams.h"


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
    VIEW_LAYOUT_DIRECTION_UNDEFINED             =   LayoutDirection_UNDEFINED,
    VIEW_LAYOUT_DIRECTION_LTR                   =   LayoutDirection_LTR,
    VIEW_LAYOUT_DIRECTION_RTL                   =   LayoutDirection_RTL,
    VIEW_LAYOUT_DIRECTION_INHERIT               =   LayoutDirection_INHERIT,
    VIEW_LAYOUT_DIRECTION_LOCALE                =   LayoutDirection_LOCALE,
    VIEW_PFLAG2_LAYOUT_DIRECTION_MASK_SHIFT     =   2,
    VIEW_PFLAG2_LAYOUT_DIRECTION_MASK           =   0x00000003 << VIEW_PFLAG2_LAYOUT_DIRECTION_MASK_SHIFT,
    VIEW_PFLAG2_LAYOUT_DIRECTION_RESOLVED_RTL   =   4          << VIEW_PFLAG2_LAYOUT_DIRECTION_MASK_SHIFT,
    VIEW_PFLAG2_LAYOUT_DIRECTION_RESOLVED_MASK  =   0x0000000C << VIEW_PFLAG2_LAYOUT_DIRECTION_MASK_SHIFT,
    VIEW_PFLAG2_PADDING_RESOLVED                =   0x20000000
};

enum
{
    VIEW_OVER_SCROLL_ALWAYS = 0,
    VIEW_OVER_SCROLL_IF_CONTENT_SCROLLS = 1,
    VIEW_OVER_SCROLL_NEVER = 2
};

enum
{
    VIEW_SCROLLBARS_INSIDE_OVERLAY = 0
};

@interface UIView(Params)

@property (nonatomic) int measuredWidth;
@property (nonatomic) int measuredHeight;

@property (nonatomic) int minWidth;
@property (nonatomic) int minHeight;

@property (nonatomic) CGRect selfBounds;
@property (nonatomic) CGRect contentBounds;

- (ViewParams*)viewParams;

- (LayoutParams*)generateLayoutParams:(NSDictionary*)attr;

- (NSMutableDictionary<NSNumber*, NSNumber*>*)measureCache;

- (VisibilityMode)visibility;

- (void)setVisibility:(VisibilityMode)visibilityMode;

- (int)layoutDirection;

- (BOOL)isLayoutRtl;

- (int)paddingLeft;
- (int)paddingRight;
- (int)paddingTop;
- (int)paddingBottom;

- (int)baseline;

- (int)suggestedMinimumWidth;

- (int)suggestedMinimumHeight;

- (int)resolveSize:(int)size measureSpec:(int)measureSpec;

- (void)setMeasuredDimension:(int)measuredWidth measuredHeight:(int)measuredHeight;

- (void)layout:(int)l t:(int)t r:(int)r b:(int)b;

//
- (void)measure:(int)widthMeasureSpec heightSpec:(int)heightMeasureSpec;

- (BOOL)measureHierarchy:(LayoutParams*)lp
                   width:(int)desiredWindowWidth
                  height:(int)desiredWindowHeight;

-(void)performLayout:(LayoutParams*)lp
        desiredWidth:(int)desiredWindowWidth
       desiredHeight:(int)desiredWindowHeight;
@end

