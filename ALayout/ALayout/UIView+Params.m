//
//  UIView+Params.m
//  RMLayout
//
//  Created by Splendour Bell on 2017/4/8.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "UIView+Params.h"
#import <objc/runtime.h>

@implementation ViewParams
{
@public
    VisibilityMode mVisibilityMode;
    
    int _privateFlags2;
    
    int _paddingLeft;
    int _paddingRight;
    int _paddingTop;
    int _paddingBottom;
    
    int _baseline;
    
    int _measuredWidth;
    int _measuredHeight;
}

@end

@implementation UIView(Params)

- (ViewParams*)viewParams
{
    static void* KEY_ViewParams = &KEY_ViewParams;
    
    ViewParams* viewParams = objc_getAssociatedObject(self, KEY_ViewParams);
    if(!viewParams)
    {
        viewParams = [[ViewParams alloc] init];
        objc_setAssociatedObject(self, KEY_ViewParams, viewParams, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return viewParams;
}

- (VisibilityMode)visibility
{
    return self.viewParams->mVisibilityMode;
}

- (void)setVisibility:(VisibilityMode)visibilityMode
{
    self.viewParams->mVisibilityMode = visibilityMode;
}

- (int)layoutDirection
{
    int mPrivateFlags2 = self.viewParams->_privateFlags2;
    
    return ((mPrivateFlags2 & VIEW_PFLAG2_LAYOUT_DIRECTION_RESOLVED_RTL) ==
            VIEW_PFLAG2_LAYOUT_DIRECTION_RESOLVED_RTL) ? VIEW_LAYOUT_DIRECTION_RTL : VIEW_LAYOUT_DIRECTION_LTR;
}

- (BOOL)isLayoutRtl
{
    return NO;//TODO:
}

- (int)measuredWidth
{
    return self.viewParams->_measuredWidth;
}

- (int)measuredHeight
{
    return self.viewParams->_measuredHeight;
}

- (void)setMeasuredWidth:(int)measuredWidth
{
    self.viewParams->_measuredWidth = measuredWidth;
}

- (void)setMeasuredHeight:(int)measuredHeight
{
    self.viewParams->_measuredHeight = measuredHeight;
}

- (int)paddingLeft
{
    return self.viewParams->_paddingLeft;
}
- (int)paddingRight
{
    return self.viewParams->_paddingRight;
}
- (int)paddingTop
{
    return self.viewParams->_paddingTop;
}
- (int)paddingBottom
{
    return self.viewParams->_paddingBottom;
}

- (int)baseline
{
    return self.viewParams->_baseline;
}

- (void)measure:(int)widthMeasureSpec heightSpec:(int)heightMeasureSpec
{
    //TODO
}

@end
