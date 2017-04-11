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

- (void)setViewAttr:(NSDictionary*)attr
{
#define if_match_key(x) if([(x) isEqualToString:key])
#define elif_match_key(x) else if([(x) isEqualToString:key])
    
    
//    for(NSString* key in attr)
//    {
//        if_match_key(View_background)
//        {
//        }
//        elif_match_key(View_padding)
//        {
//            padding = a.getDimensionPixelSize(attr, -1);
//            mUserPaddingLeftInitial = padding;
//            mUserPaddingRightInitial = padding;
//            leftPaddingDefined = true;
//            rightPaddingDefined = true;
//        }
//        elif_match_key(View_paddingLeft)
//        {
//            leftPadding = a.getDimensionPixelSize(attr, -1);
//            mUserPaddingLeftInitial = leftPadding;
//            leftPaddingDefined = true;
//        }
//        elif_match_key(View_paddingTop)
//        {
//            topPadding = a.getDimensionPixelSize(attr, -1);
//        }
//        elif_match_key(View_paddingRight)
//        {
//            rightPadding = a.getDimensionPixelSize(attr, -1);
//            mUserPaddingRightInitial = rightPadding;
//            rightPaddingDefined = true;
//        }
//        elif_match_key(View_paddingBottom)
//        {
//            bottomPadding = a.getDimensionPixelSize(attr, -1);
//        }
//        elif_match_key(View_paddingStart)
//        {
//            startPadding = a.getDimensionPixelSize(attr, UNDEFINED_PADDING);
//            startPaddingDefined = (startPadding != UNDEFINED_PADDING);
//        }
//        elif_match_key(View_paddingEnd)
//        {
//            endPadding = a.getDimensionPixelSize(attr, UNDEFINED_PADDING);
//            endPaddingDefined = (endPadding != UNDEFINED_PADDING);
//        }
//        elif_match_key(View_scrollX)
//        {
//            x = a.getDimensionPixelOffset(attr, 0);
//        }
//        elif_match_key(View_scrollY)
//        {
//            y = a.getDimensionPixelOffset(attr, 0);
//        }
//        elif_match_key(View_alpha)
//        {
//            setAlpha(a.getFloat(attr, 1f));
//        }
//    }
//
//
//
//
//
//case com.android.internal.R.styleable.View_alpha:
//    setAlpha(a.getFloat(attr, 1f));
//    break;
//case com.android.internal.R.styleable.View_transformPivotX:
//    setPivotX(a.getDimension(attr, 0));
//    break;
//case com.android.internal.R.styleable.View_transformPivotY:
//    setPivotY(a.getDimension(attr, 0));
//    break;
//case com.android.internal.R.styleable.View_translationX:
//    tx = a.getDimension(attr, 0);
//    transformSet = true;
//    break;
//case com.android.internal.R.styleable.View_translationY:
//    ty = a.getDimension(attr, 0);
//    transformSet = true;
//    break;
//case com.android.internal.R.styleable.View_translationZ:
//    tz = a.getDimension(attr, 0);
//    transformSet = true;
//    break;
//case com.android.internal.R.styleable.View_elevation:
//    elevation = a.getDimension(attr, 0);
//    transformSet = true;
//    break;
//case com.android.internal.R.styleable.View_rotation:
//    rotation = a.getFloat(attr, 0);
//    transformSet = true;
//    break;
//case com.android.internal.R.styleable.View_rotationX:
//    rotationX = a.getFloat(attr, 0);
//    transformSet = true;
//    break;
//case com.android.internal.R.styleable.View_rotationY:
//    rotationY = a.getFloat(attr, 0);
//    transformSet = true;
//    break;
//case com.android.internal.R.styleable.View_scaleX:
//    sx = a.getFloat(attr, 1f);
//    transformSet = true;
//    break;
//case com.android.internal.R.styleable.View_scaleY:
//    sy = a.getFloat(attr, 1f);
//    transformSet = true;
//    break;
//case com.android.internal.R.styleable.View_id:
//    mID = a.getResourceId(attr, NO_ID);
//    break;
//case com.android.internal.R.styleable.View_tag:
//    mTag = a.getText(attr);
//    break;
//case com.android.internal.R.styleable.View_fitsSystemWindows:
//    if (a.getBoolean(attr, false)) {
//        viewFlagValues |= FITS_SYSTEM_WINDOWS;
//        viewFlagMasks |= FITS_SYSTEM_WINDOWS;
//    }
//    break;
//case com.android.internal.R.styleable.View_focusable:
//    if (a.getBoolean(attr, false)) {
//        viewFlagValues |= FOCUSABLE;
//        viewFlagMasks |= FOCUSABLE_MASK;
//    }
//    break;
//case com.android.internal.R.styleable.View_focusableInTouchMode:
//    if (a.getBoolean(attr, false)) {
//        viewFlagValues |= FOCUSABLE_IN_TOUCH_MODE | FOCUSABLE;
//        viewFlagMasks |= FOCUSABLE_IN_TOUCH_MODE | FOCUSABLE_MASK;
//    }
//    break;
//case com.android.internal.R.styleable.View_clickable:
//    if (a.getBoolean(attr, false)) {
//        viewFlagValues |= CLICKABLE;
//        viewFlagMasks |= CLICKABLE;
//    }
//    break;
//case com.android.internal.R.styleable.View_longClickable:
//    if (a.getBoolean(attr, false)) {
//        viewFlagValues |= LONG_CLICKABLE;
//        viewFlagMasks |= LONG_CLICKABLE;
//    }
//    break;
//case com.android.internal.R.styleable.View_contextClickable:
//    if (a.getBoolean(attr, false)) {
//        viewFlagValues |= CONTEXT_CLICKABLE;
//        viewFlagMasks |= CONTEXT_CLICKABLE;
//    }
//    break;
//case com.android.internal.R.styleable.View_saveEnabled:
//    if (!a.getBoolean(attr, true)) {
//        viewFlagValues |= SAVE_DISABLED;
//        viewFlagMasks |= SAVE_DISABLED_MASK;
//    }
//    break;
//case com.android.internal.R.styleable.View_duplicateParentState:
//    if (a.getBoolean(attr, false)) {
//        viewFlagValues |= DUPLICATE_PARENT_STATE;
//        viewFlagMasks |= DUPLICATE_PARENT_STATE;
//    }
//    break;
//case com.android.internal.R.styleable.View_visibility:
//    final int visibility = a.getInt(attr, 0);
//    if (visibility != 0) {
//        viewFlagValues |= VISIBILITY_FLAGS[visibility];
//        viewFlagMasks |= VISIBILITY_MASK;
//    }
//    break;
//case com.android.internal.R.styleable.View_layoutDirection:
//    // Clear any layout direction flags (included resolved bits) already set
//    mPrivateFlags2 &=
//    ~(PFLAG2_LAYOUT_DIRECTION_MASK | PFLAG2_LAYOUT_DIRECTION_RESOLVED_MASK);
//    // Set the layout direction flags depending on the value of the attribute
//    final int layoutDirection = a.getInt(attr, -1);
//    final int value = (layoutDirection != -1) ?
//    LAYOUT_DIRECTION_FLAGS[layoutDirection] : LAYOUT_DIRECTION_DEFAULT;
//    mPrivateFlags2 |= (value << PFLAG2_LAYOUT_DIRECTION_MASK_SHIFT);
//    break;
//case com.android.internal.R.styleable.View_drawingCacheQuality:
//    final int cacheQuality = a.getInt(attr, 0);
//    if (cacheQuality != 0) {
//        viewFlagValues |= DRAWING_CACHE_QUALITY_FLAGS[cacheQuality];
//        viewFlagMasks |= DRAWING_CACHE_QUALITY_MASK;
//    }
//    break;
//case com.android.internal.R.styleable.View_contentDescription:
//    setContentDescription(a.getString(attr));
//    break;
//case com.android.internal.R.styleable.View_accessibilityTraversalBefore:
//    setAccessibilityTraversalBefore(a.getResourceId(attr, NO_ID));
//    break;
//case com.android.internal.R.styleable.View_accessibilityTraversalAfter:
//    setAccessibilityTraversalAfter(a.getResourceId(attr, NO_ID));
//    break;
//case com.android.internal.R.styleable.View_labelFor:
//    setLabelFor(a.getResourceId(attr, NO_ID));
//    break;
//case com.android.internal.R.styleable.View_soundEffectsEnabled:
//    if (!a.getBoolean(attr, true)) {
//        viewFlagValues &= ~SOUND_EFFECTS_ENABLED;
//        viewFlagMasks |= SOUND_EFFECTS_ENABLED;
//    }
//    break;
//case com.android.internal.R.styleable.View_hapticFeedbackEnabled:
//    if (!a.getBoolean(attr, true)) {
//        viewFlagValues &= ~HAPTIC_FEEDBACK_ENABLED;
//        viewFlagMasks |= HAPTIC_FEEDBACK_ENABLED;
//    }
//    break;
//case R.styleable.View_scrollbars:
//    final int scrollbars = a.getInt(attr, SCROLLBARS_NONE);
//    if (scrollbars != SCROLLBARS_NONE) {
//        viewFlagValues |= scrollbars;
//        viewFlagMasks |= SCROLLBARS_MASK;
//        initializeScrollbars = true;
//    }
//    break;
//    //noinspection deprecation
//case R.styleable.View_fadingEdge:
//    if (targetSdkVersion >= ICE_CREAM_SANDWICH) {
//        // Ignore the attribute starting with ICS
//        break;
//    }
//    // With builds < ICS, fall through and apply fading edges
//case R.styleable.View_requiresFadingEdge:
//    final int fadingEdge = a.getInt(attr, FADING_EDGE_NONE);
//    if (fadingEdge != FADING_EDGE_NONE) {
//        viewFlagValues |= fadingEdge;
//        viewFlagMasks |= FADING_EDGE_MASK;
//        initializeFadingEdgeInternal(a);
//    }
//    break;
//case R.styleable.View_scrollbarStyle:
//    scrollbarStyle = a.getInt(attr, SCROLLBARS_INSIDE_OVERLAY);
//    if (scrollbarStyle != SCROLLBARS_INSIDE_OVERLAY) {
//        viewFlagValues |= scrollbarStyle & SCROLLBARS_STYLE_MASK;
//        viewFlagMasks |= SCROLLBARS_STYLE_MASK;
//    }
//    break;
//case R.styleable.View_isScrollContainer:
//    setScrollContainer = true;
//    if (a.getBoolean(attr, false)) {
//        setScrollContainer(true);
//    }
//    break;
//case com.android.internal.R.styleable.View_keepScreenOn:
//    if (a.getBoolean(attr, false)) {
//        viewFlagValues |= KEEP_SCREEN_ON;
//        viewFlagMasks |= KEEP_SCREEN_ON;
//    }
//    break;
//case R.styleable.View_filterTouchesWhenObscured:
//    if (a.getBoolean(attr, false)) {
//        viewFlagValues |= FILTER_TOUCHES_WHEN_OBSCURED;
//        viewFlagMasks |= FILTER_TOUCHES_WHEN_OBSCURED;
//    }
//    break;
//case R.styleable.View_nextFocusLeft:
//    mNextFocusLeftId = a.getResourceId(attr, View.NO_ID);
//    break;
//case R.styleable.View_nextFocusRight:
//    mNextFocusRightId = a.getResourceId(attr, View.NO_ID);
//    break;
//case R.styleable.View_nextFocusUp:
//    mNextFocusUpId = a.getResourceId(attr, View.NO_ID);
//    break;
//case R.styleable.View_nextFocusDown:
//    mNextFocusDownId = a.getResourceId(attr, View.NO_ID);
//    break;
//case R.styleable.View_nextFocusForward:
//    mNextFocusForwardId = a.getResourceId(attr, View.NO_ID);
//    break;
//case R.styleable.View_minWidth:
//    mMinWidth = a.getDimensionPixelSize(attr, 0);
//    break;
//case R.styleable.View_minHeight:
//    mMinHeight = a.getDimensionPixelSize(attr, 0);
//    break;
//case R.styleable.View_onClick:
//    if (context.isRestricted()) {
//        throw new IllegalStateException("The android:onClick attribute cannot "
//                                        + "be used within a restricted context");
//    }
//    
//    final String handlerName = a.getString(attr);
//    if (handlerName != null) {
//        setOnClickListener(new DeclaredOnClickListener(this, handlerName));
//    }
//    break;
//case R.styleable.View_overScrollMode:
//    overScrollMode = a.getInt(attr, OVER_SCROLL_IF_CONTENT_SCROLLS);
//    break;
//case R.styleable.View_verticalScrollbarPosition:
//    mVerticalScrollbarPosition = a.getInt(attr, SCROLLBAR_POSITION_DEFAULT);
//    break;
//case R.styleable.View_layerType:
//    setLayerType(a.getInt(attr, LAYER_TYPE_NONE), null);
//    break;
//case R.styleable.View_textDirection:
//    // Clear any text direction flag already set
//    mPrivateFlags2 &= ~PFLAG2_TEXT_DIRECTION_MASK;
//    // Set the text direction flags depending on the value of the attribute
//    final int textDirection = a.getInt(attr, -1);
//    if (textDirection != -1) {
//        mPrivateFlags2 |= PFLAG2_TEXT_DIRECTION_FLAGS[textDirection];
//    }
//    break;
//case R.styleable.View_textAlignment:
//    // Clear any text alignment flag already set
//    mPrivateFlags2 &= ~PFLAG2_TEXT_ALIGNMENT_MASK;
//    // Set the text alignment flag depending on the value of the attribute
//    final int textAlignment = a.getInt(attr, TEXT_ALIGNMENT_DEFAULT);
//    mPrivateFlags2 |= PFLAG2_TEXT_ALIGNMENT_FLAGS[textAlignment];
//    break;
//case R.styleable.View_importantForAccessibility:
//    setImportantForAccessibility(a.getInt(attr,
//                                          IMPORTANT_FOR_ACCESSIBILITY_DEFAULT));
//    break;
//case R.styleable.View_accessibilityLiveRegion:
//    setAccessibilityLiveRegion(a.getInt(attr, ACCESSIBILITY_LIVE_REGION_DEFAULT));
//    break;
//case R.styleable.View_transitionName:
//    setTransitionName(a.getString(attr));
//    break;
//case R.styleable.View_nestedScrollingEnabled:
//    setNestedScrollingEnabled(a.getBoolean(attr, false));
//    break;
//case R.styleable.View_stateListAnimator:
//    setStateListAnimator(AnimatorInflater.loadStateListAnimator(context,
//                                                                a.getResourceId(attr, 0)));
//    break;
//case R.styleable.View_backgroundTint:
//    // This will get applied later during setBackground().
//    if (mBackgroundTint == null) {
//        mBackgroundTint = new TintInfo();
//    }
//    mBackgroundTint.mTintList = a.getColorStateList(
//                                                    R.styleable.View_backgroundTint);
//    mBackgroundTint.mHasTintList = true;
//    break;
//case R.styleable.View_backgroundTintMode:
//    // This will get applied later during setBackground().
//    if (mBackgroundTint == null) {
//        mBackgroundTint = new TintInfo();
//    }
//    mBackgroundTint.mTintMode = Drawable.parseTintMode(a.getInt(
//                                                                R.styleable.View_backgroundTintMode, -1), null);
//    mBackgroundTint.mHasTintMode = true;
//    break;
//case R.styleable.View_outlineProvider:
//    setOutlineProviderFromAttribute(a.getInt(R.styleable.View_outlineProvider,
//                                             PROVIDER_BACKGROUND));
//    break;
//case R.styleable.View_foreground:
//    if (targetSdkVersion >= VERSION_CODES.M || this instanceof FrameLayout) {
//        setForeground(a.getDrawable(attr));
//    }
//    break;
//case R.styleable.View_foregroundGravity:
//    if (targetSdkVersion >= VERSION_CODES.M || this instanceof FrameLayout) {
//        setForegroundGravity(a.getInt(attr, Gravity.NO_GRAVITY));
//    }
//    break;
//case R.styleable.View_foregroundTintMode:
//    if (targetSdkVersion >= VERSION_CODES.M || this instanceof FrameLayout) {
//        setForegroundTintMode(Drawable.parseTintMode(a.getInt(attr, -1), null));
//    }
//    break;
//case R.styleable.View_foregroundTint:
//    if (targetSdkVersion >= VERSION_CODES.M || this instanceof FrameLayout) {
//        setForegroundTintList(a.getColorStateList(attr));
//    }
//    break;
//case R.styleable.View_foregroundInsidePadding:
//    if (targetSdkVersion >= VERSION_CODES.M || this instanceof FrameLayout) {
//        if (mForegroundInfo == null) {
//            mForegroundInfo = new ForegroundInfo();
//        }
//        mForegroundInfo.mInsidePadding = a.getBoolean(attr,
//                                                      mForegroundInfo.mInsidePadding);
//    }
//    break;
//case R.styleable.View_scrollIndicators:
//    final int scrollIndicators =
//    (a.getInt(attr, 0) << SCROLL_INDICATORS_TO_PFLAGS3_LSHIFT)
//    & SCROLL_INDICATORS_PFLAG3_MASK;
//    if (scrollIndicators != 0) {
//        mPrivateFlags3 |= scrollIndicators;
//        initializeScrollIndicators = true;
//    }
//    break;
//case R.styleable.View_pointerIcon:
//    final int resourceId = a.getResourceId(attr, 0);
//    if (resourceId != 0) {
//        setPointerIcon(PointerIcon.load(
//                                        context.getResources(), resourceId));
//    } else {
//        final int pointerType = a.getInt(attr, PointerIcon.TYPE_NOT_SPECIFIED);
//        if (pointerType != PointerIcon.TYPE_NOT_SPECIFIED) {
//            setPointerIcon(PointerIcon.getSystemIcon(context, pointerType));
//        }
//    }
//    break;
//case R.styleable.View_forceHasOverlappingRendering:
//    if (a.peekValue(attr) != null) {
//        forceHasOverlappingRendering(a.getBoolean(attr, true));
//    }
//    break;
//    
//}
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
