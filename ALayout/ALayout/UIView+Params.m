//
//  UIView+Params.m
//  RMLayout
//
//  Created by Splendour Bell on 2017/4/8.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import <objc/runtime.h>
#import "AttrKeyDef.h"
#import "UIView+Params.h"
#import "UIView+FindView.h"
#import "LayoutParams.h"

enum
{
    VIEW_UNDEFINED_PADDING          = INT_MIN,
    
    VIEW_LAYOUT_DIRECTION_DEFAULT   = VIEW_LAYOUT_DIRECTION_INHERIT
};

static int VIEW_LAYOUT_DIRECTION_FLAGS[] = {
    VIEW_LAYOUT_DIRECTION_LTR,
    VIEW_LAYOUT_DIRECTION_RTL,
    VIEW_LAYOUT_DIRECTION_INHERIT,
    VIEW_LAYOUT_DIRECTION_LOCALE
};

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
    
    int _minWidth;
    int _minHeight;
    
    int _overScrollMode;
    
    int _userPaddingLeftInitial;
    int _userPaddingRightInitial;
    
    id  _viewExtension;
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

- (LayoutParams*)generateLayoutParams:(NSDictionary*)attr
{
    return [[LayoutParams alloc] initWithAttr:attr];
}

- (void)setViewAttr:(NSDictionary*)attr
{
#define if_match_key(x) if([(x) isEqualToString:key])
#define elif_match_key(x) else if([(x) isEqualToString:key])
    
    //TODO: Drawable background = null;
    
    int leftPadding = -1;
    int topPadding = -1;
    int rightPadding = -1;
    int bottomPadding = -1;
    int startPadding =  VIEW_UNDEFINED_PADDING;
    int endPadding = VIEW_UNDEFINED_PADDING;
    
    int padding = -1;
    
    int viewFlagValues = 0;
    int viewFlagMasks = 0;
    
    BOOL setScrollContainer = NO;
    
    int x = 0;
    int y = 0;
    
    float tx = 0;
    float ty = 0;
    float tz = 0;
    float elevation = 0;
    float rotation = 0;
    float rotationX = 0;
    float rotationY = 0;
    float sx = 1.f;
    float sy = 1.f;
    BOOL transformSet = NO;
    
    int scrollbarStyle = VIEW_SCROLLBARS_INSIDE_OVERLAY;
    int overScrollMode = self.viewParams->_overScrollMode;
    BOOL initializeScrollbars = NO;
    BOOL initializeScrollIndicators = NO;
    
    BOOL startPaddingDefined = NO;
    BOOL endPaddingDefined = NO;
    BOOL leftPaddingDefined = NO;
    BOOL rightPaddingDefined = NO;
    
    ViewParams* viewParams = self.viewParams;
    for(NSString* key in attr)
    {
        if_match_key(View_background)
        {
            //TODO:background = a.getDrawable(attr);
        }
        elif_match_key(View_padding)
        {
            padding = getDimensionPixelSize(attr[key], -1);
            viewParams->_userPaddingLeftInitial = padding;
            viewParams->_userPaddingRightInitial = padding;
            leftPaddingDefined = YES;
            rightPaddingDefined = YES;
        }
        elif_match_key(View_paddingLeft)
        {
            leftPadding = getDimensionPixelSize(attr[key], -1);
            viewParams->_userPaddingLeftInitial = leftPadding;
            leftPaddingDefined = YES;
        }
        elif_match_key(View_paddingTop)
        {
            topPadding = getDimensionPixelSize(attr[key], -1);
        }
        elif_match_key(View_paddingRight)
        {
            rightPadding = getDimensionPixelSize(attr[key], -1);
            viewParams->_userPaddingRightInitial = rightPadding;
            rightPaddingDefined = YES;
        }
        elif_match_key(View_paddingBottom)
        {
            bottomPadding = getDimensionPixelSize(attr[key], -1);
        }
        elif_match_key(View_paddingStart)
        {
            startPadding = getDimensionPixelSize(attr[key], VIEW_UNDEFINED_PADDING);
            startPaddingDefined = (startPadding != VIEW_UNDEFINED_PADDING);
        }
        elif_match_key(View_paddingEnd)
        {
            endPadding = getDimensionPixelSize(attr[key], VIEW_UNDEFINED_PADDING);
            endPaddingDefined = (endPadding != VIEW_UNDEFINED_PADDING);
        }
        elif_match_key(View_scrollX)
        {
            x = getDimensionPixelOffset(attr[key], 0);
        }
        elif_match_key(View_scrollY)
        {
            y = getDimensionPixelOffset(attr[key], 0);
        }
        elif_match_key(View_alpha)
        {
            self.alpha = getParamsFloat(attr[key], 1.f);
        }
        elif_match_key(View_transformPivotX)
        {
            //setPivotX(a.getDimension(attr, 0));
        }
        elif_match_key(View_transformPivotY)
        {
            //setPivotY(a.getDimension(attr, 0));
        }
        elif_match_key(View_translationX)
        {
//            tx = a.getDimension(attr, 0);
//            transformSet = YES;
        }
        elif_match_key(View_translationY)
        {
//            ty = a.getDimension(attr, 0);
//            transformSet = YES;
        }
        elif_match_key(View_translationZ)
        {
//            tz = a.getDimension(attr, 0);
//            transformSet = YES;
        }
        elif_match_key(View_elevation)
        {
//            elevation = a.getDimension(attr, 0);
//            transformSet = YES;
        }
        elif_match_key(View_rotation)
        {
            rotation = getParamsFloat(attr[key], 0.f);
            transformSet = YES;
        }
        elif_match_key(View_rotationX)
        {
            rotationX = getParamsFloat(attr[key], 0.f);
            transformSet = YES;
        }
        elif_match_key(View_rotationY)
        {
            rotationY = getParamsFloat(attr[key], 0.f);
            transformSet = YES;
        }
        elif_match_key(View_scaleX)
        {
            sx = getParamsFloat(attr[key], 1.f);
            transformSet = YES;
        }
        elif_match_key(View_scaleY)
        {
            sy = getParamsFloat(attr[key], 1.f);
            transformSet = YES;
        }
        elif_match_key(View_id)
        {
            NSString* strTag = getResourceId(attr[key], nil);
            self.strTag = strTag;
        }
        elif_match_key(View_tag)
        {
            viewParams->_viewExtension = [attr[key] copy];
        }
        elif_match_key(View_fitsSystemWindows)
        {
//            if (a.getBOOL(attr, NO)) {
//                viewFlagValues |= FITS_SYSTEM_WINDOWS;
//                viewFlagMasks |= FITS_SYSTEM_WINDOWS;
//            }
        }
        elif_match_key(View_focusable)
        {
            //getBool(attr[key], NO)
//            if (a.getBOOL(attr, NO)) {
//                viewFlagValues |= FOCUSABLE;
//                viewFlagMasks |= FOCUSABLE_MASK;
//            }
        }
        elif_match_key(View_focusableInTouchMode)
        {
//            if (a.getBOOL(attr, NO)) {
//                viewFlagValues |= FOCUSABLE_IN_TOUCH_MODE | FOCUSABLE;
//                viewFlagMasks |= FOCUSABLE_IN_TOUCH_MODE | FOCUSABLE_MASK;
//            }
        }
        elif_match_key(View_clickable)
        {
//            if (a.getBOOL(attr, NO)) {
//                viewFlagValues |= CLICKABLE;
//                viewFlagMasks |= CLICKABLE;
//            }
        }
        elif_match_key(View_longClickable)
        {
//            if (a.getBOOL(attr, NO)) {
//                viewFlagValues |= LONG_CLICKABLE;
//                viewFlagMasks |= LONG_CLICKABLE;
//            }
        }
        elif_match_key(View_contextClickable)
        {
//            if (a.getBOOL(attr, NO)) {
//                viewFlagValues |= CONTEXT_CLICKABLE;
//                viewFlagMasks |= CONTEXT_CLICKABLE;
//            }
        }
        elif_match_key(View_saveEnabled)
        {
//            if (!a.getBOOL(attr, YES)) {
//                viewFlagValues |= SAVE_DISABLED;
//                viewFlagMasks |= SAVE_DISABLED_MASK;
//            }
        }
        elif_match_key(View_duplicateParentState)
        {
//            if (a.getBOOL(attr, NO)) {
//                viewFlagValues |= DUPLICATE_PARENT_STATE;
//                viewFlagMasks |= DUPLICATE_PARENT_STATE;
//            }
        }
        elif_match_key(View_visibility)
        {
            self.visibility = getParamsInt(attr[key], 0);
            
//            final int visibility = a.getInt(attr, 0);
//            if (visibility != 0) {
//                viewFlagValues |= VISIBILITY_FLAGS[visibility];
//                viewFlagMasks |= VISIBILITY_MASK;
//            }
        }
        elif_match_key(View_layoutDirection)
        {
            viewParams->_privateFlags2 &=
                ~(VIEW_PFLAG2_LAYOUT_DIRECTION_MASK | VIEW_PFLAG2_LAYOUT_DIRECTION_RESOLVED_MASK);
            
            const int layoutDirection = getParamsInt(attr[key], -1);
            const int value = (layoutDirection != -1) ?
                VIEW_LAYOUT_DIRECTION_FLAGS[layoutDirection] : VIEW_LAYOUT_DIRECTION_DEFAULT;
            
            viewParams->_privateFlags2 |= (value << VIEW_PFLAG2_LAYOUT_DIRECTION_MASK_SHIFT);
        }
        elif_match_key(View_drawingCacheQuality)
        {
//            final int cacheQuality = a.getInt(attr, 0);
//            if (cacheQuality != 0) {
//                viewFlagValues |= DRAWING_CACHE_QUALITY_FLAGS[cacheQuality];
//                viewFlagMasks |= DRAWING_CACHE_QUALITY_MASK;
//            }
        }
        elif_match_key(View_contentDescription)
        {
            //setContentDescription(a.getString(attr));
        }
        elif_match_key(View_accessibilityTraversalBefore)
        {
            //setAccessibilityTraversalBefore(a.getResourceId(attr, NO_ID));
        }
        elif_match_key(View_accessibilityTraversalAfter)
        {
            //setAccessibilityTraversalAfter(a.getResourceId(attr, NO_ID));
        }
        elif_match_key(View_labelFor)
        {
            //setLabelFor(a.getResourceId(attr, NO_ID));
        }
        elif_match_key(View_soundEffectsEnabled)
        {
//            if (!a.getBOOL(attr, YES)) {
//                viewFlagValues &= ~SOUND_EFFECTS_ENABLED;
//                viewFlagMasks |= SOUND_EFFECTS_ENABLED;
//            }
        }
        elif_match_key(View_hapticFeedbackEnabled)
        {
//            if (!a.getBOOL(attr, YES)) {
//                viewFlagValues &= ~HAPTIC_FEEDBACK_ENABLED;
//                viewFlagMasks |= HAPTIC_FEEDBACK_ENABLED;
//            }
        }
        elif_match_key(View_scrollbars)
        {
//            final int scrollbars = a.getInt(attr, SCROLLBARS_NONE);
//            if (scrollbars != SCROLLBARS_NONE) {
//                viewFlagValues |= scrollbars;
//                viewFlagMasks |= SCROLLBARS_MASK;
//                initializeScrollbars = YES;
//            }
        }
        elif_match_key(View_fadingEdge)
        {
//            final int fadingEdge = a.getInt(attr, FADING_EDGE_NONE);
//            if (fadingEdge != FADING_EDGE_NONE) {
//                viewFlagValues |= fadingEdge;
//                viewFlagMasks |= FADING_EDGE_MASK;
//                initializeFadingEdgeInternal(a);
//            }
        }
        elif_match_key(View_requiresFadingEdge)
        {
//            final int fadingEdge = a.getInt(attr, FADING_EDGE_NONE);
//            if (fadingEdge != FADING_EDGE_NONE) {
//                viewFlagValues |= fadingEdge;
//                viewFlagMasks |= FADING_EDGE_MASK;
//                initializeFadingEdgeInternal(a);
//            }
        }
        elif_match_key(View_scrollbarStyle)
        {
//            scrollbarStyle = a.getInt(attr, SCROLLBARS_INSIDE_OVERLAY);
//            if (scrollbarStyle != SCROLLBARS_INSIDE_OVERLAY) {
//                viewFlagValues |= scrollbarStyle & SCROLLBARS_STYLE_MASK;
//                viewFlagMasks |= SCROLLBARS_STYLE_MASK;
//            }
        }
        elif_match_key(View_isScrollContainer)
        {
//            setScrollContainer = YES;
//            if (a.getBOOL(attr, NO)) {
//                setScrollContainer(YES);
//            }
        }
        elif_match_key(View_keepScreenOn)
        {
//            if (a.getBOOL(attr, NO)) {
//                viewFlagValues |= KEEP_SCREEN_ON;
//                viewFlagMasks |= KEEP_SCREEN_ON;
//            }
        }
        elif_match_key(View_filterTouchesWhenObscured)
        {
//            if (a.getBOOL(attr, NO)) {
//                viewFlagValues |= FILTER_TOUCHES_WHEN_OBSCURED;
//                viewFlagMasks |= FILTER_TOUCHES_WHEN_OBSCURED;
//            }
        }
        elif_match_key(View_nextFocusLeft)
        {
            //mNextFocusLeftId = a.getResourceId(attr, View.NO_ID);
        }
        elif_match_key(View_nextFocusRight)
        {
            //mNextFocusRightId = a.getResourceId(attr, View.NO_ID);
        }
        elif_match_key(View_nextFocusUp)
        {
            //mNextFocusUpId = a.getResourceId(attr, View.NO_ID);
        }
        elif_match_key(View_nextFocusDown)
        {
            //mNextFocusDownId = a.getResourceId(attr, View.NO_ID);
        }
        elif_match_key(View_nextFocusForward)
        {
           // mNextFocusForwardId = a.getResourceId(attr, View.NO_ID);
        }
        elif_match_key(View_minWidth)
        {
            viewParams->_minWidth = getDimensionPixelSize(attr[key], 0);
        }
        elif_match_key(View_minHeight)
        {
            viewParams->_minHeight = getDimensionPixelSize(attr[key], 0);
        }
        elif_match_key(View_onClick)
        {
//            if (context.isRestricted()) {
//                throw new IllegalStateException("The android:onClick attribute cannot "
//                                                + "be used within a restricted context");
//            }
//            
//            final String handlerName = a.getString(attr);
//            if (handlerName != null) {
//                setOnClickListener(new DeclaredOnClickListener(this, handlerName));
//            }
        }
        elif_match_key(View_overScrollMode)
        {
            viewParams->_overScrollMode = getParamsInt(attr[key], VIEW_OVER_SCROLL_IF_CONTENT_SCROLLS);
        }
        elif_match_key(View_verticalScrollbarPosition)
        {
            //mVerticalScrollbarPosition = a.getInt(attr, SCROLLBAR_POSITION_DEFAULT);
        }
        elif_match_key(View_layerType)
        {
            //setLayerType(a.getInt(attr, LAYER_TYPE_NONE), null);
        }
        elif_match_key(View_textDirection)
        {
//            mPrivateFlags2 &= ~PFLAG2_TEXT_DIRECTION_MASK;
//            // Set the text direction flags depending on the value of the attribute
//            final int textDirection = a.getInt(attr, -1);
//            if (textDirection != -1) {
//                mPrivateFlags2 |= PFLAG2_TEXT_DIRECTION_FLAGS[textDirection];
//            }
        }
        elif_match_key(View_textAlignment)
        {
//            mPrivateFlags2 &= ~PFLAG2_TEXT_ALIGNMENT_MASK;
//            // Set the text alignment flag depending on the value of the attribute
//            final int textAlignment = a.getInt(attr, TEXT_ALIGNMENT_DEFAULT);
//            mPrivateFlags2 |= PFLAG2_TEXT_ALIGNMENT_FLAGS[textAlignment];
        }
        elif_match_key(View_importantForAccessibility)
        {
//            setImportantForAccessibility(a.getInt(attr,
//                                                  IMPORTANT_FOR_ACCESSIBILITY_DEFAULT));
        }
        elif_match_key(View_accessibilityLiveRegion)
        {
            //setAccessibilityLiveRegion(a.getInt(attr, ACCESSIBILITY_LIVE_REGION_DEFAULT));
        }
        elif_match_key(View_transitionName)
        {
            //setTransitionName(a.getString(attr));
        }
        elif_match_key(View_nestedScrollingEnabled)
        {
            //setNestedScrollingEnabled(a.getBOOL(attr, NO));
        }
        elif_match_key(View_stateListAnimator)
        {
//            setStateListAnimator(AnimatorInflater.loadStateListAnimator(context,
//                                                                        a.getResourceId(attr, 0)));
        }
        elif_match_key(View_backgroundTint)
        {
//            if (mBackgroundTint == null) {
//                mBackgroundTint = new TintInfo();
//            }
//            mBackgroundTint.mTintList = a.getColorStateList(
//                                                            R.styleable.View_backgroundTint);
//            mBackgroundTint.mHasTintList = YES;
        }
        elif_match_key(View_backgroundTintMode)
        {
//            if (mBackgroundTint == null) {
//                mBackgroundTint = new TintInfo();
//            }
//            mBackgroundTint.mTintMode = Drawable.parseTintMode(a.getInt(
//                                                                        R.styleable.View_backgroundTintMode, -1), null);
//            mBackgroundTint.mHasTintMode = YES;
        }
        elif_match_key(View_outlineProvider)
        {
//            setOutlineProviderFromAttribute(a.getInt(R.styleable.View_outlineProvider,
//                                                     PROVIDER_BACKGROUND));
        }
        elif_match_key(View_foreground)
        {
//            if (targetSdkVersion >= VERSION_CODES.M || this instanceof FrameLayout) {
//                setForeground(a.getDrawable(attr));
//            }
        }
        elif_match_key(View_foregroundGravity)
        {
//            if (targetSdkVersion >= VERSION_CODES.M || this instanceof FrameLayout) {
//                setForegroundGravity(a.getInt(attr, Gravity.NO_GRAVITY));
//            }
        }
        elif_match_key(View_foregroundTintMode)
        {
//            if (targetSdkVersion >= VERSION_CODES.M || this instanceof FrameLayout) {
//                setForegroundTintMode(Drawable.parseTintMode(a.getInt(attr, -1), null));
//            }
        }
        elif_match_key(View_foregroundTint)
        {
//            if (targetSdkVersion >= VERSION_CODES.M || this instanceof FrameLayout) {
//                setForegroundTintList(a.getColorStateList(attr));
//            }
        }
        elif_match_key(View_foregroundInsidePadding)
        {
//            if (targetSdkVersion >= VERSION_CODES.M || this instanceof FrameLayout) {
//                if (mForegroundInfo == null) {
//                    mForegroundInfo = new ForegroundInfo();
//                }
//                mForegroundInfo.mInsidePadding = a.getBOOL(attr,
//                                                              mForegroundInfo.mInsidePadding);
//            }
        }
        elif_match_key(View_scrollIndicators)
        {
//            final int scrollIndicators =
//            (a.getInt(attr, 0) << SCROLL_INDICATORS_TO_PFLAGS3_LSHIFT)
//            & SCROLL_INDICATORS_PFLAG3_MASK;
//            if (scrollIndicators != 0) {
//                mPrivateFlags3 |= scrollIndicators;
//                initializeScrollIndicators = YES;
//            }
        }
        elif_match_key(View_pointerIcon)
        {
//            final int resourceId = a.getResourceId(attr, 0);
//            if (resourceId != 0) {
//                setPointerIcon(PointerIcon.load(
//                                                context.getResources(), resourceId));
//            } else {
//                final int pointerType = a.getInt(attr, PointerIcon.TYPE_NOT_SPECIFIED);
//                if (pointerType != PointerIcon.TYPE_NOT_SPECIFIED) {
//                    setPointerIcon(PointerIcon.getSystemIcon(context, pointerType));
//                }
//            }
        }
        elif_match_key(View_forceHasOverlappingRendering)
        {
//            if (a.peekValue(attr) != null) {
//                forceHasOverlappingRendering(a.getBOOL(attr, YES));
//            }
        }
    }
}


- (VisibilityMode)visibility
{
    return self.viewParams->mVisibilityMode;
}

- (void)setVisibility:(VisibilityMode)visibilityMode
{
    if(self.viewParams->mVisibilityMode != visibilityMode)
    {
        self.viewParams->mVisibilityMode = visibilityMode;
        self.hidden = (Visibility_VISIBLE != visibilityMode);
    }
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
