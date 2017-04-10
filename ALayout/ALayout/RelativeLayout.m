//
//  RelativeLayout.m
//  RMLayout
//
//  Created by splendourbell on 2017/4/7.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "RelativeLayout.h"
#import "Gravity.h"
#import "AttrKeyDef.h"
#import "MeasureSpec.h"
#import "UIView+FindView.h"
#import "MarginLayoutParams.h"
#import "UIView+Params.h"

@implementation RelativeLayout
{
    int mGravity;
    NSString* mIgnoreGravity;
    BOOL mDirtyHierarchy;
    
    NSMutableArray<UIView*>* mSortedHorizontalChildren;
    NSMutableArray<UIView*>* mSortedVerticalChildren;
}

- (instancetype)init
{
    if(self = [super init])
    {
        mGravity = Gravity_START | Gravity_TOP;
    }
    return self;
}

- (void)parseAttr:(NSDictionary *)attr
{
    mIgnoreGravity = attr[android_ignoreGravity];
    mGravity = getParamsInt(attr[android_gravity], mGravity);
}

- (void)setNeedsLayout
{
    [super setNeedsLayout];
    mDirtyHierarchy = YES;
}

- (void)onMeasure:(int)widthMeasureSpec heightSpec:(int)heightMeasureSpec
{
    if (mDirtyHierarchy)
    {
        mDirtyHierarchy = NO;
        [self sortChildren];
    }
    
    int myWidth  = -1;
    int myHeight = -1;
    
    int width  = 0;
    int height = 0;
    
    const int widthMode  = [MeasureSpec getMode:  widthMeasureSpec];
    const int heightMode = [MeasureSpec getMode: heightMeasureSpec];
    const int widthSize  = [MeasureSpec getSize:  widthMeasureSpec];
    const int heightSize = [MeasureSpec getSize: heightMeasureSpec];
    
    if (MeasureSpec_UNSPECIFIED != widthMode)
    {
        myWidth = widthSize;
    }
    
    if (MeasureSpec_UNSPECIFIED != heightMode)
    {
        myHeight = heightSize;
    }
    
    if (MeasureSpec_EXACTLY == widthMode)
    {
        width = myWidth;
    }
    
    if (MeasureSpec_EXACTLY == heightMode)
    {
        height = myHeight;
    }
    
    UIView* ignore = nil;
    
    int gravity = mGravity & Gravity_RELATIVE_HORIZONTAL_GRAVITY_MASK;
    const BOOL horizontalGravity = ((gravity != Gravity_START) && (gravity != 0));
    
    gravity = mGravity & Gravity_VERTICAL_GRAVITY_MASK;
    const BOOL verticalGravity = ((gravity != Gravity_TOP) && (gravity != 0));
    
    int left    = INT_MAX;
    int top     = INT_MAX;
    int right   = INT_MIN;
    int bottom  = INT_MIN;
    
    BOOL offsetHorizontalAxis = false;
    BOOL offsetVerticalAxis = false;
    
    if ((horizontalGravity || verticalGravity) && mIgnoreGravity)
    {
        ignore = self[mIgnoreGravity];
    }
    
    const BOOL isWrapContentWidth  = (widthMode  != MeasureSpec_EXACTLY);
    const BOOL isWrapContentHeight = (heightMode != MeasureSpec_EXACTLY);
    
    // We need to know our size for doing the correct computation of children positioning in RTL
    // mode but there is no practical way to get it instead of running the code below.
    // So, instead of running the code twice, we just set the width to a "default display width"
    // before the computation and then, as a last pass, we will update their real position with
    // an offset equals to "DEFAULT_WIDTH - width".
//TODO:
//    const int layoutDirection = getLayoutDirection();
//    if (isLayoutRtl() && myWidth == -1) {
//        myWidth = DEFAULT_WIDTH;
//    }
    
    NSMutableArray<UIView*>* views = mSortedHorizontalChildren;
    int count = views.count;
    
    for (int i = 0; i < count; i++)
    {
        UIView* child = views[i];
        if (Visibility_GONE != [child getVisibility])
        {
            LayoutParams* params = child.layoutParams;
            int rules[] = params.getRules(layoutDirection);
            
            applyHorizontalSizeRules(params, myWidth, rules);
            measureChildHorizontal(child, params, myWidth, myHeight);
            
            if (positionChildHorizontal(child, params, myWidth, isWrapContentWidth)) {
                offsetHorizontalAxis = true;
            }
        }
    }
    
    views = mSortedVerticalChildren;
    count = views.count;
    const int targetSdkVersion = getContext().getApplicationInfo().targetSdkVersion;
    
    for (int i = 0; i < count; i++) {
        UIView* child = views[i];
        if (Visibility_GONE != [child getVisibility])
        {
            const LayoutParams* params = child.layoutParams;
            
            applyVerticalSizeRules(params, myHeight, child.getBaseline());
            measureChild(child, params, myWidth, myHeight);
            if (positionChildVertical(child, params, myHeight, isWrapContentHeight)) {
                offsetVerticalAxis = true;
            }
            
            if (isWrapContentWidth)
            {
//TODO:
//                if (isLayoutRtl())
//                {
//                    width = Math.max(width, myWidth - params.mLeft - params.leftMargin);
//                }
//                else
                {
                    width = Math.max(width, params.mRight + params.rightMargin);
                }
            }
            
            if (isWrapContentHeight) {
                if (targetSdkVersion < Build.VERSION_CODES.KITKAT) {
                    height = Math.max(height, params.mBottom);
                } else {
                    height = Math.max(height, params.mBottom + params.bottomMargin);
                }
            }
            
            if (child != ignore || verticalGravity) {
                left = Math.min(left, params.mLeft - params.leftMargin);
                top = Math.min(top, params.mTop - params.topMargin);
            }
            
            if (child != ignore || horizontalGravity) {
                right = Math.max(right, params.mRight + params.rightMargin);
                bottom = Math.max(bottom, params.mBottom + params.bottomMargin);
            }
        }
    }
    
    //TODO
}

- (void)sortChildren
{
    const int count = self.subviews.count;
    if (mSortedVerticalChildren.count != count)
    {
        mSortedVerticalChildren = [NSMutableArray array];
    }
    
    if (mSortedHorizontalChildren.length != count)
    {
        mSortedHorizontalChildren = [NSMutableArray array];
    }
    
//TODO:
// 计算依赖顺序
//    final DependencyGraph graph = mGraph;
//    graph.clear();
//    
//    for (int i = 0; i < count; i++) {
//        graph.add(getChildAt(i));
//    }
//    
//    graph.getSortedViews(mSortedVerticalChildren, RULES_VERTICAL);
//    graph.getSortedViews(mSortedHorizontalChildren, RULES_HORIZONTAL);
}

@end
