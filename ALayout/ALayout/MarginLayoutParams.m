//
//  MarginLayoutParams.m
//  RMLayout
//
//  Created by Splendour Bell on 2017/4/8.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "MarginLayoutParams.h"
#import "LayoutDirection.h"
#import "AttrKeyDef.h"

enum
{
    DEFAULT_MARGIN_RESOLVED     = 0,
    DEFAULT_MARGIN_RELATIVE     = INT_MIN,
    
    LAYOUT_DIRECTION_MASK       = 0x00000003,
    LEFT_MARGIN_UNDEFINED_MASK  = 0x00000004,
    RIGHT_MARGIN_UNDEFINED_MASK = 0x00000008,
    RTL_COMPATIBILITY_MODE_MASK = 0x00000010,
    NEED_RESOLUTION_MASK        = 0x00000020,

    UNDEFINED_MARGIN            = DEFAULT_MARGIN_RELATIVE
};

@implementation MarginLayoutParams
{
    unsigned char mMarginFlags;
}

- (instancetype)init
{
    if(self = [super init])
    {
        _startMargin = DEFAULT_MARGIN_RELATIVE;
        _endMargin = DEFAULT_MARGIN_RELATIVE;
    }
    return self;
}

- (instancetype)initWithAttr:(NSDictionary*)attr
{
    if(self = [super initWithAttr:attr])
    {
        int margin = getParamsInt(attr[ViewGroup_MarginLayout_layout_margin], -1);
        if (margin >= 0)
        {
            _leftMargin   = margin;
            _topMargin    = margin;
            _rightMargin  = margin;
            _bottomMargin = margin;
        }
        else
        {
            _leftMargin   = getParamsInt(attr[ViewGroup_MarginLayout_layout_marginLeft], UNDEFINED_MARGIN);
            if (UNDEFINED_MARGIN == _leftMargin)
            {
                mMarginFlags |= LEFT_MARGIN_UNDEFINED_MASK;
                _leftMargin    = DEFAULT_MARGIN_RESOLVED;
            }
            
            _rightMargin  = getParamsInt(attr[ViewGroup_MarginLayout_layout_marginRight], UNDEFINED_MARGIN);
            if (UNDEFINED_MARGIN == _rightMargin)
            {
                mMarginFlags |= RIGHT_MARGIN_UNDEFINED_MASK;
                _rightMargin   = DEFAULT_MARGIN_RESOLVED;
            }
            
            _topMargin    = getParamsInt(attr[ViewGroup_MarginLayout_layout_marginTop], DEFAULT_MARGIN_RESOLVED);
            _bottomMargin = getParamsInt(attr[ViewGroup_MarginLayout_layout_marginBottom], DEFAULT_MARGIN_RESOLVED);
            
            _startMargin  = getParamsInt(attr[ViewGroup_MarginLayout_layout_marginStart], DEFAULT_MARGIN_RELATIVE);
            _endMargin    = getParamsInt(attr[ViewGroup_MarginLayout_layout_marginEnd], DEFAULT_MARGIN_RELATIVE);
            
            if (self.isMarginRelative)
            {
                mMarginFlags |= NEED_RESOLUTION_MASK;
            }
            
            const BOOL hasRtlSupport = NO;//TODO:c.getApplicationInfo().hasRtlSupport();
            if (!hasRtlSupport)
            {
                mMarginFlags |= RTL_COMPATIBILITY_MODE_MASK;
            }
            
            mMarginFlags |= View_LAYOUT_DIRECTION_LTR;
        }
    }
    return self;
}

- (BOOL) isLayoutRtl
{
    return NO; //TODO: ((mMarginFlags & LAYOUT_DIRECTION_MASK) == View.LAYOUT_DIRECTION_RTL);
}

- (int)layoutDirection
{
    return (mMarginFlags & LAYOUT_DIRECTION_MASK);
}

- (BOOL)isMarginRelative
{
    return ((_startMargin != DEFAULT_MARGIN_RELATIVE) || (_endMargin != DEFAULT_MARGIN_RELATIVE));
}

- (void)resolveLayoutDirection:(int)layoutDirection
{
}

@end


    
    
    
    
    
    
    
    
    
    
