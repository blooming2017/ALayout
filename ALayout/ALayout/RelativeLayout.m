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
#import "RelativeLayoutLayoutParams.h"
#import "UIView+Params.h"
#import "DependencyGraph.h"

static NSArray<NSNumber*>* RULES_VERTICAL;
static NSArray<NSNumber*>* RULES_HORIZONTAL;

#define DEFAULT_WIDTH 0x00010000

@implementation RelativeLayout
{
    int mGravity;
    NSString* mIgnoreGravity;
    BOOL mDirtyHierarchy;
    
    DependencyGraph* _graph;
    
    NSMutableArray<UIView*>* _sortedHorizontalChildren;
    NSMutableArray<UIView*>* _sortedVerticalChildren;
}

+ (void)initialize
{
    RULES_VERTICAL = @[
                       @(RelativeLayout_ABOVE),
                       @(RelativeLayout_BELOW),
                       @(RelativeLayout_ALIGN_BASELINE),
                       @(RelativeLayout_ALIGN_TOP),
                       @(RelativeLayout_ALIGN_BOTTOM)
                       ];
    
    RULES_HORIZONTAL = @[
                        @(RelativeLayout_LEFT_OF),
                        @(RelativeLayout_RIGHT_OF),
                        @(RelativeLayout_ALIGN_LEFT),
                        @(RelativeLayout_ALIGN_RIGHT),
                        @(RelativeLayout_START_OF),
                        @(RelativeLayout_END_OF),
                        @(RelativeLayout_ALIGN_START),
                        @(RelativeLayout_ALIGN_END)
                        ];
}

- (instancetype)init
{
    if(self = [super init])
    {
        mGravity = Gravity_START | Gravity_TOP;
        _graph = [[DependencyGraph alloc] init];
    }
    return self;
}

- (void)parseAttr:(NSDictionary *)attr
{
    mIgnoreGravity = attr[RelativeLayout_ignoreGravity];
    mGravity = getParamsInt(attr[RelativeLayout_gravity], mGravity);
}

- (void)setNeedsLayout
{
    [super setNeedsLayout];
    mDirtyHierarchy = YES;
}

- (void)sortChildren
{
    NSArray* subviews = self.subviews;
    const int count = (int)subviews.count;
    if (_sortedVerticalChildren.count != count)
    {
        _sortedVerticalChildren = [NSMutableArray array];
    }
    
    if (_sortedHorizontalChildren.count != count)
    {
        _sortedHorizontalChildren = [NSMutableArray array];
    }
    
    DependencyGraph* graph = [[DependencyGraph alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [graph add:subviews[i]];
    }
    
    [graph getSortedViews:_sortedVerticalChildren rules:RULES_VERTICAL];
    [graph getSortedViews:_sortedHorizontalChildren rules:RULES_HORIZONTAL];
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
    
    const int layoutDirection = self.layoutDirection;
    if ([self isLayoutRtl] && myWidth == -1)//TODO:
    {
        myWidth = DEFAULT_WIDTH;
    }
    
    NSMutableArray<UIView*>* views = _sortedHorizontalChildren;
    int count = (int)views.count;
    
    for (int i = 0; i < count; i++)
    {
        UIView* child = views[i];
        if (Visibility_GONE != child.visibility)
        {
            RelativeLayoutLayoutParams* params = (RelativeLayoutLayoutParams*)child.layoutParams;
            RelativeRule* rules = [params getRules:layoutDirection];
            
            [self applyHorizontalSizeRules:params myWidth:myWidth rules:rules];
            [self measureChildHorizontal:child params:params myWidth:myWidth myHeight:myHeight];
            
            if ([self positionChildHorizontal:child params:params myWidth:myWidth wrap:isWrapContentWidth])
            {
                offsetHorizontalAxis = true;
            }
        }
    }
    
    views = _sortedVerticalChildren;
    count = (int)views.count;
    
    for (int i = 0; i < count; i++)
    {
        UIView* child = views[i];
        if (Visibility_GONE != child.visibility)
        {
            RelativeLayoutLayoutParams* params = (RelativeLayoutLayoutParams*)child.layoutParams;
            [self applyVerticalSizeRules:params myHeight:myHeight myBaseline:child.baseline];
            [self measureChild:child params:params myWidth:myWidth myHeight:myHeight];
            
            if ([self positionChildVertical:child params:params myHeight:myHeight wrap:isWrapContentHeight])
            {
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
                    width = MAX(width, (params.right + params.rightMargin));
                }
            }
            
            if (isWrapContentHeight)
            {
                height = MAX(height, (params.bottom + params.bottomMargin));
            }
            
            if (child != ignore || verticalGravity)
            {
                left = MIN(left, (params.left - params.leftMargin));
                top = MIN(top, (params.top - params.topMargin));
            }
            
            if (child != ignore || horizontalGravity)
            {
                right = MAX(right, (params.right + params.rightMargin));
                bottom = MAX(bottom, (params.bottom + params.bottomMargin));
            }
        }
    }
    
    //TODO
}

- (BOOL)positionChildHorizontal:(UIView*)child
                         params:(RelativeLayoutLayoutParams*)params
                        myWidth:(int)myWidth
                           wrap:(BOOL)wrapContent
{
    
    int layoutDirection = self.layoutDirection;
    RelativeRule* rules = [params getRules:layoutDirection];
    
    if ((RelativeLayout_VALUE_NOT_SET == params.left) && (RelativeLayout_VALUE_NOT_SET != params.right))
    {
        params.left = params.left - child.measuredWidth;
    }
    else if (RelativeLayout_VALUE_NOT_SET != params.left && RelativeLayout_VALUE_NOT_SET == params.right)
    {
        params.right = params.left + child.measuredWidth;
    }
    else if (RelativeLayout_VALUE_NOT_SET == params.left && RelativeLayout_VALUE_NOT_SET == params.right)
    {
        if (rules[@(RelativeLayout_CENTER_IN_PARENT)] || rules[@(RelativeLayout_CENTER_HORIZONTAL)])
        {
            if (!wrapContent)
            {
                [self centerHorizontal:child params:params myWidth:myWidth];
            } else
            {
                params.left = self.paddingLeft + params.leftMargin;
                params.right = params.left + child.measuredWidth;
            }
            return true;
        }
        else
        {
            if ([self isLayoutRtl])
            {
                params.right = myWidth - self.paddingRight- params.rightMargin;
                params.left = params.right - child.measuredWidth;
            }
            else
            {
                params.left = self.paddingLeft + params.leftMargin;
                params.right = params.left + child.measuredWidth;
            }
        }
    }
    return rules[@(RelativeLayout_ALIGN_PARENT_END)];
}

- (void) centerHorizontal:(UIView*)child params:(RelativeLayoutLayoutParams*)params myWidth:(int)myWidth
{
    int childWidth = child.measuredWidth;
    int left = (myWidth - childWidth) / 2;
    
    params.left = left;
    params.right = left + childWidth;
}

- (void)centerVertical:(UIView*)child params:(RelativeLayoutLayoutParams*)params myHeight:(int)myHeight
{
    int childHeight = child.measuredHeight;
    int top = (myHeight - childHeight) / 2;
    
    params.top = top;
    params.bottom = top + childHeight;
}

- (BOOL)positionChildVertical:(UIView*)child
                       params:(RelativeLayoutLayoutParams*)params
                     myHeight:(int)myHeight
                         wrap:(BOOL)wrapContent
{
    
    RelativeRule* rules = [params getRules];
    
    if (RelativeLayout_VALUE_NOT_SET == params.top && RelativeLayout_VALUE_NOT_SET != params.bottom)
    {
        params.top = params.bottom - child.measuredHeight;
    }
    else if (RelativeLayout_VALUE_NOT_SET != params.top && RelativeLayout_VALUE_NOT_SET == params.bottom)
    {
        params.bottom = params.top + child.measuredHeight;
    } else if (RelativeLayout_VALUE_NOT_SET == params.top && RelativeLayout_VALUE_NOT_SET == params.bottom)
    {
        if (rules[@(RelativeLayout_CENTER_IN_PARENT)] || rules[@(Gravity_CENTER_VERTICAL)]) {
            if (!wrapContent)
            {
                [self centerVertical:child params:params myHeight:myHeight];
            }
            else
            {
                params.top = self.paddingTop + params.topMargin;
                params.bottom = params.top + child.measuredHeight;
            }
            return true;
        }
        else
        {
            params.top = self.paddingTop + params.topMargin;
            params.bottom = params.top + child.measuredHeight;
        }
    }
    return rules[@(RelativeLayout_ALIGN_PARENT_BOTTOM)];
}

- (void)measureChild:(UIView*)child params:(RelativeLayoutLayoutParams*)params myWidth:(int)myWidth myHeight:(int)myHeight
{
    int childWidthMeasureSpec = [self getChildMeasureSpec:params.left childEnd:params.right childSize:params.width startMargin:params.leftMargin endMargin:params.rightMargin startPadding:self.paddingLeft endPadding:self.paddingRight mySize:myWidth];
    
    
    
    int childHeightMeasureSpec = [self getChildMeasureSpec:params.top childEnd:params.bottom childSize:params.height startMargin:params.topMargin endMargin:params.bottomMargin startPadding:self.paddingTop endPadding:self.paddingBottom mySize:myHeight];
    
    [child measure:childWidthMeasureSpec heightSpec:childHeightMeasureSpec];
}

- (void)applyVerticalSizeRules:(RelativeLayoutLayoutParams*)childParams myHeight:(int)myHeight myBaseline:(int)myBaseline
{
    RelativeRule* rules = [childParams getRules];
    
    int baselineOffset = [self getRelatedViewBaselineOffset:rules];
    if (baselineOffset != -1)
    {
        if (myBaseline != -1)
        {
            baselineOffset -= myBaseline;
        }
        childParams.top = baselineOffset;
        childParams.bottom = RelativeLayout_VALUE_NOT_SET;
        return;
    }
    
    RelativeLayoutLayoutParams* anchorParams;
    
    childParams.top = RelativeLayout_VALUE_NOT_SET;
    childParams.bottom = RelativeLayout_VALUE_NOT_SET;
    
    anchorParams = (RelativeLayoutLayoutParams*)[self getRelatedViewParams:rules relation:RelativeLayout_ABOVE];
    
    if (anchorParams)
    {
        childParams.bottom = anchorParams.top - (anchorParams.topMargin + childParams.bottomMargin);
    }
    else if (childParams.alignWithParent && rules[@(RelativeLayout_ABOVE)])
    {
        if (myHeight >= 0)
        {
            childParams.bottom = myHeight - self.paddingBottom - childParams.bottomMargin;
        }
    }
    
    anchorParams = (RelativeLayoutLayoutParams*)[self getRelatedViewParams:rules relation:RelativeLayout_BELOW];
    if (anchorParams)
    {
        childParams.top = anchorParams.bottom + (anchorParams.bottomMargin + childParams.topMargin);
    }
    else if (childParams.alignWithParent && rules[@(RelativeLayout_BELOW)])
    {
        childParams.top = self.paddingTop + childParams.topMargin;
    }
    
    anchorParams = (RelativeLayoutLayoutParams*)[self getRelatedViewParams:rules relation:RelativeLayout_ALIGN_TOP];
    if (anchorParams)
    {
        childParams.top = anchorParams.top + childParams.topMargin;
    }
    else if (childParams.alignWithParent && rules[@(RelativeLayout_ALIGN_TOP)])
    {
        childParams.top = self.paddingTop + childParams.topMargin;
    }
    
    anchorParams = (RelativeLayoutLayoutParams*)[self getRelatedViewParams:rules relation:RelativeLayout_ALIGN_BOTTOM];
    if (anchorParams)
    {
        childParams.bottom = anchorParams.bottom - childParams.bottomMargin;
    }
    else if (childParams.alignWithParent && rules[@(RelativeLayout_ALIGN_BOTTOM)])
    {
        if (myHeight >= 0)
        {
            childParams.bottom = myHeight - self.paddingBottom - childParams.bottomMargin;
        }
    }
    
    if (rules[@(RelativeLayout_ALIGN_PARENT_TOP)])
    {
        childParams.top = self.paddingTop + childParams.topMargin;
    }
    
    if (0 != rules[@(RelativeLayout_ALIGN_PARENT_BOTTOM)])
    {
        if (myHeight >= 0)
        {
            childParams.bottom = myHeight - self.paddingBottom - childParams.bottomMargin;
        }
    }
}

- (int)getRelatedViewBaselineOffset:(RelativeRule*)rules
{
    UIView* v = [self getRelatedView:rules relation:RelativeLayout_ALIGN_BASELINE];
    if (v)
    {
        int baseline = v.baseline;
        if (baseline != -1)
        {
            LayoutParams* params = v.layoutParams;
            if([params isKindOfClass:RelativeLayoutLayoutParams.class])
            {
                RelativeLayoutLayoutParams* anchorParams = (RelativeLayoutLayoutParams*) v.layoutParams;
                return anchorParams.top + baseline;
            }
        }
    }
    return -1;
}

- (void)applyHorizontalSizeRules:(RelativeLayoutLayoutParams*)childParams myWidth:(int)myWidth rules:(RelativeRule*)rules
{
    RelativeLayoutLayoutParams* anchorParams;
    
    // VALUE_NOT_SET indicates a "soft requirement" in that direction. For example:
    // left=10, right=VALUE_NOT_SET means the view must start at 10, but can go as far as it
    // wants to the right
    // left=VALUE_NOT_SET, right=10 means the view must end at 10, but can go as far as it
    // wants to the left
    // left=10, right=20 means the left and right ends are both fixed
    childParams.left = RelativeLayout_VALUE_NOT_SET;
    childParams.right = RelativeLayout_VALUE_NOT_SET;
    
    anchorParams = (RelativeLayoutLayoutParams*)[self getRelatedViewParams:rules relation:RelativeLayout_LEFT_OF];
    if (anchorParams)
    {
        childParams.right = anchorParams.left - (anchorParams.leftMargin + childParams.rightMargin);
    }
    else if (childParams.alignWithParent && rules[@(RelativeLayout_LEFT_OF)])
    {
        if (myWidth >= 0)
        {
            childParams.right = myWidth - self.paddingRight - childParams.rightMargin;
        }
    }
    
    anchorParams = (RelativeLayoutLayoutParams*)[self getRelatedViewParams:rules relation:RelativeLayout_RIGHT_OF];
    if (anchorParams)
    {
        childParams.left = anchorParams.right + (anchorParams.rightMargin + childParams.leftMargin);
    }
    else if (childParams.alignWithParent && rules[@(RelativeLayout_RIGHT_OF)])
    {
        childParams.left = self.paddingLeft + childParams.leftMargin;
    }
    
    anchorParams = (RelativeLayoutLayoutParams*)[self getRelatedViewParams:rules relation:RelativeLayout_ALIGN_LEFT];
    if (anchorParams)
    {
        childParams.left = anchorParams.left + childParams.leftMargin;
    }
    else if (childParams.alignWithParent && rules[@(RelativeLayout_ALIGN_LEFT)])
    {
        childParams.left = self.paddingLeft + childParams.leftMargin;
    }
    
    anchorParams = (RelativeLayoutLayoutParams*)[self getRelatedViewParams:rules relation:RelativeLayout_ALIGN_RIGHT];
    if (anchorParams)
    {
        childParams.right = anchorParams.right - childParams.rightMargin;
    } else if (childParams.alignWithParent && rules[@(RelativeLayout_ALIGN_RIGHT)])
    {
        if (myWidth >= 0)
        {
            childParams.right = myWidth - self.paddingRight - childParams.rightMargin;
        }
    }
    
    if (rules[@(RelativeLayout_ALIGN_PARENT_LEFT)])
    {
        childParams.left = self.paddingLeft + childParams.leftMargin;
    }
    
    if (rules[@(RelativeLayout_ALIGN_PARENT_RIGHT)])
    {
        if (myWidth >= 0)
        {
            childParams.right = myWidth - self.paddingRight - childParams.rightMargin;
        }
    }
}

- (LayoutParams*)getRelatedViewParams:(RelativeRule*)rules relation:(int)relation
{
    UIView* v = [self getRelatedView:rules relation:relation];
    if (v)
    {
        LayoutParams* params = v.layoutParams;
        if([params isKindOfClass:RelativeLayoutLayoutParams.class])
        {
            return (LayoutParams*)v.layoutParams;
        }
    }
    return nil;
}

- (UIView*)getRelatedView:(RelativeRule*)rules relation:(int)relation
{
    NSString* strTag = rules[@(relation)];
    if (strTag)
    {
        DependencyGraph_Node* node = _graph.keyNodes[strTag];
        if (node)
        {
            UIView* v = node.view;
            while (Visibility_GONE == v.visibility)
            {
                rules = [((RelativeLayoutLayoutParams*)v.layoutParams) getRules:v.layoutDirection];
                node = _graph.keyNodes[rules[@(relation)]];
                
                if (!node) return nil;

                v = node.view;
            }
            return v;
        }
    }
    
    return nil;
}

- (void)measureChildHorizontal:(UIView*)child params:(RelativeLayoutLayoutParams*)params myWidth:(int)myWidth myHeight:(int)myHeight
{
    const int childWidthMeasureSpec = [self getChildMeasureSpec:params.left childEnd:params.right childSize:params.width startMargin:params.leftMargin endMargin:params.rightMargin startPadding:self.paddingLeft endPadding:self.paddingRight mySize:myWidth];
    
    int childHeightMeasureSpec;
    if (myHeight < 0)
    {
        if (params.height >= 0)
        {
            childHeightMeasureSpec = [MeasureSpec makeMeasureSpec:params.height mode:MeasureSpec_EXACTLY];
        }
        else
        {
            childHeightMeasureSpec = [MeasureSpec makeMeasureSpec:0 mode:MeasureSpec_UNSPECIFIED];
        }
    }
    else
    {
        const int maxHeight = MAX(0, (myHeight - self.paddingTop - self.paddingBottom - params.topMargin - params.bottomMargin));
        
        int heightMode;
        if (LayoutParams_MATCH_PARENT == params.height)
        {
            heightMode = MeasureSpec_EXACTLY;
        }
        else
        {
            heightMode = MeasureSpec_AT_MOST;
        }
        childHeightMeasureSpec = [MeasureSpec makeMeasureSpec:maxHeight mode:heightMode];
    }
    
    [child measure:childWidthMeasureSpec heightSpec:childHeightMeasureSpec];
}

- (int)getChildMeasureSpec:(int)childStart
                  childEnd:(int)childEnd
                 childSize:(int)childSize
               startMargin:(int)startMargin
                 endMargin:(int)endMargin
              startPadding:(int)startPadding
                endPadding:(int)endPadding
                    mySize:(int)mySize
{
    int childSpecMode = 0;
    int childSpecSize = 0;
    
    BOOL isUnspecified = mySize < 0;
    if (isUnspecified)
    {
        if ((RelativeLayout_VALUE_NOT_SET != childStart) && (RelativeLayout_VALUE_NOT_SET != childEnd))
        {
            childSpecSize = MAX(0, (childEnd - childStart));
            childSpecMode = MeasureSpec_EXACTLY;
        }
        else if (childSize >= 0)
        {
            childSpecSize = childSize;
            childSpecMode = MeasureSpec_EXACTLY;
        }
        else
        {
            childSpecSize = 0;
            childSpecMode = MeasureSpec_UNSPECIFIED;
        }
        
        return [MeasureSpec makeMeasureSpec:childSpecSize mode:childSpecMode];
    }
    
    int tempStart = childStart;
    int tempEnd = childEnd;
    
    if (RelativeLayout_VALUE_NOT_SET == tempStart)
    {
        tempStart = startPadding + startMargin;
    }
    if (RelativeLayout_VALUE_NOT_SET == tempEnd)
    {
        tempEnd = mySize - endPadding - endMargin;
    }
    
    const int maxAvailable = tempEnd - tempStart;
    
    if (RelativeLayout_VALUE_NOT_SET != childStart && RelativeLayout_VALUE_NOT_SET != childEnd)
    {
        childSpecMode = isUnspecified ? MeasureSpec_UNSPECIFIED : MeasureSpec_EXACTLY;
        childSpecSize = MAX(0, maxAvailable);
    } else
    {
        if (childSize >= 0)
        {
            childSpecMode = MeasureSpec_EXACTLY;
            
            if (maxAvailable >= 0)
            {
                childSpecSize = MIN(maxAvailable, childSize);
            }
            else
            {
                childSpecSize = childSize;
            }
        }
        else if (LayoutParams_MATCH_PARENT == childSize)
        {
            childSpecMode = isUnspecified ? MeasureSpec_UNSPECIFIED : MeasureSpec_EXACTLY;
            childSpecSize = MAX(0, maxAvailable);
        }
        else if (LayoutParams_WRAP_CONTENT == childSize)
        {
            if (maxAvailable >= 0)
            {
                // We have a maximum size in this dimension.
                childSpecMode = MeasureSpec_AT_MOST;
                childSpecSize = maxAvailable;
            }
            else
            {
                childSpecMode = MeasureSpec_UNSPECIFIED;
                childSpecSize = 0;
            }
        }
    }
    
    return [MeasureSpec makeMeasureSpec:childSpecSize mode:childSpecMode];
}

@end
