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
#import "UIView+ALayout.h"
#import "UIView+FindView.h"
#import "LayoutParams.h"
#import "MeasureSpec.h"

enum
{
    VIEW_UNDEFINED_PADDING              = INT_MIN,
    VIEW_LAYOUT_DIRECTION_DEFAULT       = VIEW_LAYOUT_DIRECTION_INHERIT
};

enum
{
    VIEW_PFLAG_MEASURED_DIMENSION_SET   = 0x00000800
};

enum
{
    VIEW_PFLAG_HAS_BOUNDS               = 0x00000010,
    VIEW_PFLAG_DRAWN                    = 0x00000020,
    VIEW_PFLAG_FORCE_LAYOUT             = 0x00001000,
    VIEW_PFLAG_LAYOUT_REQUIRED          = 0x00002000
};

enum
{
    VIEW_PFLAG3_IS_LAID_OUT                  = 0x4,
    VIEW_PFLAG3_MEASURE_NEEDED_BEFORE_LAYOUT = 0x8
};

enum
{
    VIEW_MEASURED_SIZE_MASK             = 0x00ffffff,
    VIEW_MEASURED_STATE_MASK            = 0xff000000,
    VIEW_MEASURED_HEIGHT_STATE_SHIFT    = 16,
    VIEW_MEASURED_STATE_TOO_SMALL       = 0x01000000
};

enum
{
    VIEW_SCROLLBARS_HORIZONTAL = 0x00000100,
    VIEW_SCROLLBARS_VERTICAL   = 0x00000200,
    VIEW_SCROLLBARS_MASK       = 0x00000300,
    VIEW_SCROLLBARS_INSET_MASK = 0x01000000
};

enum
{
    VIEW_SCROLLBAR_POSITION_DEFAULT = 0,
    VIEW_SCROLLBAR_POSITION_LEFT    = 1,
    VIEW_SCROLLBAR_POSITION_RIGHT   = 2
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
    
    int _privateFlags;
    int _privateFlags2;
    int _privateFlags3;
    
    int _paddingStart;
    int _paddingEnd;
    int _paddingLeft;
    int _paddingRight;
    int _paddingTop;
    int _paddingBottom;
    
    int _userPaddingLeftInitial;
    int _userPaddingRightInitial;
    
    int _userPaddingLeft;
    int _userPaddingRight;
    int _userPaddingTop;
    int _userPaddingBottom;
    int _userPaddingStart;
    int _userPaddingEnd;
    
    BOOL _leftPaddingDefined;
    BOOL _rightPaddingDefined;
    
    int _baseline;
    
    int _measuredWidth;
    int _measuredHeight;
    
    int _oldWidthMeasureSpec;
    int _oldHeightMeasureSpec;
    
    int _minWidth;
    int _minHeight;

    CGRect _selfBounds;
    CGRect _contentBounds;
    
    int _overScrollMode;
    int _verticalScrollbarPosition;

    id  _viewExtension;
    
    int _left;
    int _right;
    int _top;
    int _bottom;
    
    int _viewFlags;
    
    NSMutableDictionary<NSNumber*, NSNumber*>* _measureCache;
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

- (NSMutableDictionary<NSNumber*, NSNumber*>*)measureCache
{
    NSMutableDictionary<NSNumber*, NSNumber*>* mc = self.viewParams->_measureCache;
    if(!mc)
    {
        mc = [NSMutableDictionary dictionary];
        self.viewParams->_measureCache = mc;
    }
    return mc;
}

- (void)parseAttr:(NSDictionary*)attr
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
    
//    int viewFlagValues = 0;
//    int viewFlagMasks = 0;
//
//    BOOL setScrollContainer = NO;
    
    int x = 0;
    int y = 0;
    
//    float tx = 0;
//    float ty = 0;
//    float tz = 0;
//    float elevation = 0;
    float rotation = 0;
    float rotationX = 0;
    float rotationY = 0;
    float sx = 1.f;
    float sy = 1.f;
    BOOL transformSet = NO;
    
//    int scrollbarStyle = VIEW_SCROLLBARS_INSIDE_OVERLAY;
//    int overScrollMode = self.viewParams->_overScrollMode;
//    BOOL initializeScrollbars = NO;
//    BOOL initializeScrollIndicators = NO;
    
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
            viewParams->_verticalScrollbarPosition = getParamsInt(attr[key], VIEW_SCROLLBAR_POSITION_DEFAULT);
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
    
    viewParams->_userPaddingStart = startPadding;
    viewParams->_userPaddingEnd = endPadding;
    
    viewParams->_leftPaddingDefined  = leftPaddingDefined;
    viewParams->_rightPaddingDefined = rightPaddingDefined;
    
    if (padding >= 0)
    {
        leftPadding = padding;
        topPadding = padding;
        rightPadding = padding;
        bottomPadding = padding;
        viewParams->_userPaddingLeftInitial = padding;
        viewParams->_userPaddingRightInitial = padding;
    }
    
    const BOOL hasRelativePadding = startPaddingDefined || endPaddingDefined;
    
    if (viewParams->_leftPaddingDefined && !hasRelativePadding)
    {
        viewParams->_userPaddingLeftInitial = leftPadding;
    }
    if (viewParams->_rightPaddingDefined && !hasRelativePadding)
    {
        viewParams->_userPaddingRightInitial = rightPadding;
    }
    
    [self internalSetPadding:viewParams->_userPaddingLeftInitial
                         top:(topPadding >= 0 ? topPadding : viewParams->_paddingTop)
                       right:viewParams->_userPaddingRightInitial
                      bottom:(bottomPadding >= 0 ? bottomPadding : viewParams->_paddingBottom)];
    
//    if (viewFlagMasks != 0)
//    {
//        setFlags(viewFlagValues, viewFlagMasks);
//    }
//    
//    if (initializeScrollbars)
//    {
//        initializeScrollbarsInternal(a);
//    }
//    
//    if (initializeScrollIndicators)
//    {
//        initializeScrollIndicatorsInternal();
//    }
//    
//    
//    // Needs to be called after mViewFlags is set
//    if (scrollbarStyle != SCROLLBARS_INSIDE_OVERLAY) {
//        recomputePadding();
//    }
//    
//    if (x != 0 || y != 0)
//    {
//        scrollTo(x, y);
//    }
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

- (CGRect)selfBounds
{
    return self.viewParams->_selfBounds;
}

- (void)setSelfBounds:(CGRect)selfBounds
{
    self.viewParams->_selfBounds = selfBounds;
}

- (CGRect)contentBounds
{
    return self.viewParams->_contentBounds;
}

- (void)setContentBounds:(CGRect)contentBounds
{
    self.viewParams->_contentBounds = contentBounds;
}

- (BOOL)isPaddingResolved
{
    return (self.viewParams->_privateFlags2 & VIEW_PFLAG2_PADDING_RESOLVED) == VIEW_PFLAG2_PADDING_RESOLVED;
}

- (int)paddingLeft
{
    if(!self.isPaddingResolved)
    {
        [self resolvePadding];
    }
    return self.viewParams->_paddingLeft;
}

- (int)paddingRight
{
    if(!self.isPaddingResolved)
    {
        [self resolvePadding];
    }
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

- (int)paddingStart
{
    return VIEW_LAYOUT_DIRECTION_RTL == self.layoutDirection ? self.paddingRight : self.paddingLeft;
}

- (int)paddingEnd
{
    return VIEW_LAYOUT_DIRECTION_RTL == self.layoutDirection ? self.paddingLeft  : self.paddingRight;
}

- (int)baseline
{
    return self.viewParams->_baseline;
}

+ (BOOL)isLayoutModeOptical:(UIView*)view
{
    return NO;
}

- (void)measure:(int)widthMeasureSpec heightSpec:(int)heightMeasureSpec
{
    BOOL optical = [UIView isLayoutModeOptical:self];
    if (optical != [UIView isLayoutModeOptical:self.superview])
    {
        //TODO:
//        Insets insets = getOpticalInsets();
//        int oWidth  = insets.left + insets.right;
//        int oHeight = insets.top  + insets.bottom;
//        widthMeasureSpec  = MeasureSpec.adjust(widthMeasureSpec,  optical ? -oWidth  : oWidth);
//        heightMeasureSpec = MeasureSpec.adjust(heightMeasureSpec, optical ? -oHeight : oHeight);
    }
    
    long key = ((long)widthMeasureSpec << 32) | ((long) heightMeasureSpec & 0xffffffffL);
    
    ViewParams* viewParams = self.viewParams;
    
    BOOL forceLayout = (viewParams->_privateFlags & VIEW_PFLAG_FORCE_LAYOUT) == VIEW_PFLAG_FORCE_LAYOUT;

    const BOOL specChanged = (widthMeasureSpec != viewParams->_oldWidthMeasureSpec)
                         || (heightMeasureSpec != viewParams->_oldHeightMeasureSpec);
    
    const BOOL isSpecExactly = [MeasureSpec mode:widthMeasureSpec] == MeasureSpec_EXACTLY
                           && [MeasureSpec mode:heightMeasureSpec] == MeasureSpec_EXACTLY;
    
    const BOOL matchesSpecSize = (viewParams->_measuredWidth == [MeasureSpec size:widthMeasureSpec])
                                  && (viewParams->_measuredHeight == [MeasureSpec size:heightMeasureSpec]);
                                  
    const BOOL needsLayout = specChanged && (!isSpecExactly || !matchesSpecSize);
    
    
    NSMutableDictionary<NSNumber*, NSNumber*>* measureCache = self.measureCache;
    
    if (forceLayout || needsLayout)
    {
        viewParams-> _privateFlags &= ~VIEW_PFLAG_MEASURED_DIMENSION_SET;
        [self resolveRtlPropertiesIfNeeded];
        
        if (forceLayout || !measureCache[@(key)])
        {
            [self onMeasure:widthMeasureSpec heightSpec:heightMeasureSpec];
            viewParams->_privateFlags3 &= ~VIEW_PFLAG3_MEASURE_NEEDED_BEFORE_LAYOUT;
        }
        else
        {
            long value = [measureCache[@(key)] longValue];
            [self setMeasuredDimensionRaw:(int) (value >> 32) measuredHeight:(int)value & 0xFFFFFFFF];
            viewParams->_privateFlags3 |= VIEW_PFLAG3_MEASURE_NEEDED_BEFORE_LAYOUT;
        }
        
        if ((viewParams->_privateFlags & VIEW_PFLAG_MEASURED_DIMENSION_SET) != VIEW_PFLAG_MEASURED_DIMENSION_SET)
        {
            assert(0);//onMeasure did not set
        }
        viewParams->_privateFlags |= VIEW_PFLAG_LAYOUT_REQUIRED;
    }
    
    viewParams->_oldWidthMeasureSpec  = widthMeasureSpec;
    viewParams->_oldHeightMeasureSpec = heightMeasureSpec;
    
    long tMeasuredWidth  = (long)viewParams->_measuredWidth << 32;
    long tMeasuredHeight = (long)viewParams->_measuredHeight & 0xffffffffL;
    measureCache[@(key)] = @(tMeasuredWidth | tMeasuredHeight);
}

- (BOOL)resolveRtlPropertiesIfNeeded
{
    return NO;
    //TODO:
//    if (!needRtlPropertiesResolution()) return false;
//    
//    // Order is important here: LayoutDirection MUST be resolved first
//    if (!isLayoutDirectionResolved()) {
//        resolveLayoutDirection();
//        resolveLayoutParams();
//    }
//    // ... then we can resolve the others properties depending on the resolved LayoutDirection.
//    if (!isTextDirectionResolved()) {
//        resolveTextDirection();
//    }
//    if (!isTextAlignmentResolved()) {
//        resolveTextAlignment();
//    }
//    // Should resolve Drawables before Padding because we need the layout direction of the
//    // Drawable to correctly resolve Padding.
//    if (!areDrawablesResolved()) {
//        resolveDrawables();
//    }
//    if (!isPaddingResolved()) {
//        resolvePadding();
//    }
//    onRtlPropertiesChanged(getLayoutDirection());
//    return true;
}


- (BOOL)measureHierarchy:(LayoutParams*)lp
                   width:(int)desiredWindowWidth
                  height:(int)desiredWindowHeight
{
    int childWidthMeasureSpec;
    int childHeightMeasureSpec;
    BOOL windowSizeMayChange = NO;
    
//    if (LayoutParams_WRAP_CONTENT == lp.width)
//    {
        childWidthMeasureSpec  = [self getRootMeasureSpec:desiredWindowWidth dimension:lp.width];
        childHeightMeasureSpec = [self getRootMeasureSpec:desiredWindowHeight dimension:lp.height];
        
        [self performMeasure:childWidthMeasureSpec heightSpec:childHeightMeasureSpec];
        
        
        if ((self.layoutParams.width != self.measuredWidth) || (self.layoutParams.height != self.measuredHeight))
        {
            windowSizeMayChange = YES;
        }
//    }
    return windowSizeMayChange;
}

- (int)getRootMeasureSpec:(int)windowSize dimension:(int)rootDimension
{
    int measureSpec;
    switch (rootDimension)
    {
        case LayoutParams_MATCH_PARENT:
            measureSpec = [MeasureSpec makeMeasureSpec:windowSize mode:MeasureSpec_EXACTLY];
            break;
            
        case LayoutParams_WRAP_CONTENT:
            measureSpec = [MeasureSpec makeMeasureSpec:windowSize mode:MeasureSpec_AT_MOST];
            break;
            
        default:
            measureSpec = [MeasureSpec makeMeasureSpec:rootDimension mode:MeasureSpec_EXACTLY];
            break;
    }
    return measureSpec;
}

- (void)performMeasure:(int)childWidthMeasureSpec heightSpec:(int)childHeightMeasureSpec
{
    [self measure:childWidthMeasureSpec heightSpec:childHeightMeasureSpec];
}

- (void)onMeasure:(int)widthMeasureSpec heightSpec:(int)heightMeasureSpec
{
    int defaultWidth  = [self getDefaultSize:self.suggestedMinimumWidth  measureSpec:widthMeasureSpec];
    int defaultHeight = [self getDefaultSize:self.suggestedMinimumHeight measureSpec:heightMeasureSpec];
    
    [self setMeasuredDimension:defaultWidth measuredHeight:defaultHeight];
}

- (int)getDefaultSize:(int)size measureSpec:(int)measureSpec
{
    int result = size;
    int specMode = [MeasureSpec mode:measureSpec];
    int specSize = [MeasureSpec size:measureSpec];
    
    switch (specMode) {
        case MeasureSpec_UNSPECIFIED:
            result = size;
            break;
        case MeasureSpec_AT_MOST:
        case MeasureSpec_EXACTLY:
            result = specSize;
            break;
    }
    return result;
}

- (int)suggestedMinimumWidth
{
    return self.viewParams->_minWidth;
    //TODO:
    //return (mBackground == null) ? mMinWidth : max(mMinWidth, mBackground.getMinimumWidth());
}

- (int)suggestedMinimumHeight
{
    //TODO:
    return self.viewParams->_minHeight;
}

- (int)minWidth
{
    return self.viewParams->_minWidth;
}

- (int)minHeight
{
    return self.viewParams->_minHeight;
}

- (void)setMinWidth:(int)minWidth
{
    self.viewParams->_minWidth = minWidth;
}

- (void)setMinHeight:(int)minHeight
{
    self.viewParams->_minHeight = minHeight;
}

- (void)setMeasuredDimension:(int)measuredWidth measuredHeight:(int)measuredHeight
{
    BOOL optical = [UIView isLayoutModeOptical:self];
    if (optical != [UIView isLayoutModeOptical:self.superview])
    {
//        Insets insets = getOpticalInsets();
//        int opticalWidth  = insets.left + insets.right;
//        int opticalHeight = insets.top  + insets.bottom;
//        
//        measuredWidth  += optical ? opticalWidth  : -opticalWidth;
//        measuredHeight += optical ? opticalHeight : -opticalHeight;
    }
    [self setMeasuredDimensionRaw:measuredWidth measuredHeight:measuredHeight];
}

- (void)setMeasuredDimensionRaw:(int)measuredWidth measuredHeight:(int)measuredHeight
{
    ViewParams* viewParams = self.viewParams;
    viewParams->_measuredWidth = measuredWidth;
    viewParams->_measuredHeight = measuredHeight;
    
    viewParams->_privateFlags |= VIEW_PFLAG_MEASURED_DIMENSION_SET;
    NSLog(@"%p setMeasuredDimensionRaw:(%@,%@)", self, @(measuredWidth), @(measuredHeight));
    
    CGRect rect = self.frame;
    rect.size.width = measuredWidth;
    rect.size.height = measuredHeight;
    self.frame = rect;
}

- (int)resolveSize:(int)size measureSpec:(int)measureSpec
{
    return [self resolveSizeAndState:size measureSpec:measureSpec measuredState:0] & VIEW_MEASURED_SIZE_MASK;
}

- (int)resolveSizeAndState:(int)size measureSpec:(int)measureSpec measuredState:(int)childMeasuredState
{
    const int specMode = [MeasureSpec mode:measureSpec];
    const int specSize = [MeasureSpec size:measureSpec];
    int result;
    switch (specMode)
    {
        case MeasureSpec_AT_MOST:
            if (specSize < size)
            {
                result = specSize | VIEW_MEASURED_STATE_TOO_SMALL;
            }
            else
            {
                result = size;
            }
            break;
            
        case MeasureSpec_EXACTLY:
            result = specSize;
            break;
            
        case MeasureSpec_UNSPECIFIED:
        default:
            result = size;
    }
    return result | (childMeasuredState & VIEW_MEASURED_STATE_MASK);
}

- (void)onLayout:(BOOL)changed left:(int)left top:(int)top right:(int)right bottom:(int)bottom
{
    
}

- (void)layout:(int)l t:(int)t r:(int)r b:(int)b
{
    ViewParams* viewParams = self.viewParams;
    if(self.viewParams->_privateFlags3 & VIEW_PFLAG3_MEASURE_NEEDED_BEFORE_LAYOUT)
    {
        [self onMeasure:self.viewParams->_oldWidthMeasureSpec heightSpec:viewParams->_oldHeightMeasureSpec];
        viewParams->_privateFlags3 &= ~VIEW_PFLAG3_MEASURE_NEEDED_BEFORE_LAYOUT;
    }
    
    BOOL changed = [self setLayoutedFrame:l top:t right:r bottom:b];
    
    if (changed || (viewParams->_privateFlags & VIEW_PFLAG_LAYOUT_REQUIRED) == VIEW_PFLAG_LAYOUT_REQUIRED)
    {
        [self onLayout:changed left:l top:t right:r bottom:b];
        viewParams->_privateFlags &= ~VIEW_PFLAG_LAYOUT_REQUIRED;
    }
    
    viewParams->_privateFlags &= ~VIEW_PFLAG_FORCE_LAYOUT;
    viewParams->_privateFlags3 |= VIEW_PFLAG3_IS_LAID_OUT;
}

- (BOOL)setLayoutedFrame:(int)left top:(int)top right:(int)right bottom:(int)bottom
{
    BOOL changed = NO;
    ViewParams* viewParams = self.viewParams;
    
    if (viewParams->_left != left || viewParams->_right != right || viewParams->_top != top || viewParams->_bottom != bottom)
    {
        changed = true;
        int drawn = viewParams->_privateFlags & VIEW_PFLAG_DRAWN;
        
        int oldWidth = viewParams->_right - viewParams->_left;
        int oldHeight = viewParams->_bottom - viewParams->_top;
        int newWidth = right - left;
        int newHeight = bottom - top;
        BOOL sizeChanged = (newWidth != oldWidth) || (newHeight != oldHeight);
        (void)sizeChanged;
        
        viewParams->_left = left;
        viewParams->_top = top;
        viewParams->_right = right;
        viewParams->_bottom = bottom;
        
        CGRect rect = CGRectMake(left, top, right-left, bottom-top);
        self.frame = rect;
        
        viewParams->_privateFlags |= VIEW_PFLAG_HAS_BOUNDS;
        
        // Reset drawn bit to original value (invalidate turns it off)
        viewParams->_privateFlags |= drawn;
    }
    return changed;
}

-(void)performLayout:(LayoutParams*)lp desiredWidth:(int)desiredWindowWidth desiredHeight:(int)desiredWindowHeight
{
    UIView* host = self;

    [host layout:0 t:0 r:host.measuredWidth b:host.measuredHeight];
        
//        mInLayout = false;
//        int numViewsRequestingLayout = mLayoutRequesters.size();
//        if (numViewsRequestingLayout > 0)
//        {
//            // requestLayout() was called during layout.
//            // If no layout-request flags are set on the requesting views, there is no problem.
//            // If some requests are still pending, then we need to clear those flags and do
//            // a full request/measure/layout pass to handle this situation.
//            ArrayList<View> validLayoutRequesters = getValidLayoutRequesters(mLayoutRequesters,
//                                                                             false);
//            if (validLayoutRequesters != null) {
//                // Set this flag to indicate that any further requests are happening during
//                // the second pass, which may result in posting those requests to the next
//                // frame instead
//                mHandlingLayoutInLayoutRequest = true;
//                
//                // Process fresh layout requests, then measure and layout
//                int numValidRequests = validLayoutRequesters.size();
//                for (int i = 0; i < numValidRequests; ++i) {
//                    final View view = validLayoutRequesters.get(i);
//                    Log.w("View", "requestLayout() improperly called by " + view +
//                          " during layout: running second layout pass");
//                    view.requestLayout();
//                }
//                measureHierarchy(host, lp, mView.getContext().getResources(),
//                                 desiredWindowWidth, desiredWindowHeight);
//                mInLayout = true;
//                host.layout(0, 0, host.getMeasuredWidth(), host.getMeasuredHeight());
//                
//                mHandlingLayoutInLayoutRequest = false;
//                
//                // Check the valid requests again, this time without checking/clearing the
//                // layout flags, since requests happening during the second pass get noop'd
//                validLayoutRequesters = getValidLayoutRequesters(mLayoutRequesters, true);
//                if (validLayoutRequesters != null) {
//                    final ArrayList<View> finalRequesters = validLayoutRequesters;
//                    // Post second-pass requests to the next frame
//                    getRunQueue().post(new Runnable() {
//                        @Override
//                        public void run() {
//                            int numValidRequests = finalRequesters.size();
//                            for (int i = 0; i < numValidRequests; ++i) {
//                                final View view = finalRequesters.get(i);
//                                Log.w("View", "requestLayout() improperly called by " + view +
//                                      " during second layout pass: posting in next frame");
//                                view.requestLayout();
//                            }
//                        }
//                    });
//                }
//            }
//            
//        }
}


- (void)resolvePadding
{
    const int resolvedLayoutDirection = self.layoutDirection;
    
//    if (mBackground != null && (!mLeftPaddingDefined || !mRightPaddingDefined))
//    {
//        Rect padding = sThreadLocal.get();
//        if (padding == null) {
//            padding = new Rect();
//            sThreadLocal.set(padding);
//        }
//        mBackground.getPadding(padding);
//        if (!mLeftPaddingDefined) {
//            mUserPaddingLeftInitial = padding.left;
//        }
//        if (!mRightPaddingDefined) {
//            mUserPaddingRightInitial = padding.right;
//        }
//    }
    
    ViewParams* viewParams = self.viewParams;
    switch (resolvedLayoutDirection)
    {
        case VIEW_LAYOUT_DIRECTION_RTL:
            if (viewParams->_userPaddingStart != VIEW_UNDEFINED_PADDING)
            {
                viewParams->_userPaddingRight = viewParams->_userPaddingStart;
            }
            else
            {
                viewParams->_userPaddingRight = viewParams->_userPaddingRightInitial;
            }
            if (viewParams->_userPaddingEnd != VIEW_UNDEFINED_PADDING)
            {
                viewParams->_userPaddingLeft = viewParams->_userPaddingEnd;
            }
            else
            {
                viewParams->_userPaddingLeft = viewParams->_userPaddingLeftInitial;
            }
            break;
            
        case VIEW_LAYOUT_DIRECTION_LTR:
        default:
            if (viewParams->_userPaddingStart != VIEW_UNDEFINED_PADDING)
            {
                viewParams->_userPaddingLeft = viewParams->_userPaddingStart;
            }
            else
            {
                viewParams->_userPaddingLeft = viewParams->_userPaddingLeftInitial;
            }
            if (viewParams->_userPaddingEnd != VIEW_UNDEFINED_PADDING)
            {
                viewParams->_userPaddingRight = viewParams->_userPaddingEnd;
            }
            else
            {
                viewParams->_userPaddingRight = viewParams->_userPaddingRightInitial;
            }
    }
    
    viewParams->_userPaddingBottom = (viewParams->_userPaddingBottom >= 0) ? viewParams->_userPaddingBottom : viewParams->_paddingBottom;
    
    [self internalSetPadding:viewParams->_userPaddingLeft
                         top:viewParams->_paddingTop
                       right:viewParams->_userPaddingRight
                      bottom:viewParams->_userPaddingBottom];
    viewParams->_privateFlags2 |= VIEW_PFLAG2_PADDING_RESOLVED;
}

- (void)internalSetPadding:(int)left top:(int)top right:(int)right bottom:(int)bottom
{
    ViewParams* viewParams = self.viewParams;
    
    viewParams->_userPaddingLeft = left;
    viewParams->_userPaddingRight = right;
    viewParams->_userPaddingBottom = bottom;
    
    const int viewFlags = viewParams->_viewFlags;
    BOOL changed = NO;
    
    if (viewFlags & (VIEW_SCROLLBARS_VERTICAL|VIEW_SCROLLBARS_HORIZONTAL))
    {
        if (viewFlags & VIEW_SCROLLBARS_VERTICAL)
        {
            const int offset = (viewFlags & VIEW_SCROLLBARS_INSET_MASK) == 0 ? 0 : self.verticalScrollbarWidth;
            switch (viewParams->_verticalScrollbarPosition)
            {
                case VIEW_SCROLLBAR_POSITION_DEFAULT:
                    if (self.isLayoutRtl)
                    {
                        left += offset;
                    }
                    else
                    {
                        right += offset;
                    }
                    break;
                    
                case VIEW_SCROLLBAR_POSITION_RIGHT:
                    right += offset;
                    break;
                    
                case VIEW_SCROLLBAR_POSITION_LEFT:
                    left += offset;
                    break;
            }
        }
        if ((viewFlags & VIEW_SCROLLBARS_HORIZONTAL))
        {
            bottom += (viewFlags & VIEW_SCROLLBARS_INSET_MASK) == 0 ? 0 : self.horizontalScrollbarHeight;
        }
    }
    
    if (viewParams->_paddingLeft != left)
    {
        changed = true;
        viewParams->_paddingLeft = left;
    }
    if (viewParams->_paddingTop != top)
    {
        changed = true;
        viewParams->_paddingTop = top;
    }
    if (viewParams->_paddingRight != right)
    {
        changed = true;
        viewParams->_paddingRight = right;
    }
    if (viewParams->_paddingBottom != bottom)
    {
        changed = true;
        viewParams->_paddingBottom = bottom;
    }
    
    if (changed)
    {
        [self setNeedsLayout];
        //TODO:
    }
}

- (int)verticalScrollbarWidth
{
    //TODO:
    return 0;
}

- (int)horizontalScrollbarHeight
{
    //TODO:
    return 0;
}

@end
