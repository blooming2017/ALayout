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
    int leftMargin;
    int topMargin;
    int rightMargin;
    int bottomMargin;
    
    int startMargin;
    int endMargin;
    
    unsigned char mMarginFlags;
}

- (instancetype)init
{
    if(self = [super init])
    {
        startMargin = DEFAULT_MARGIN_RELATIVE;
        endMargin = DEFAULT_MARGIN_RELATIVE;
    }
    return self;
}

- (instancetype)initWithAttr:(NSDictionary*)attr
{
    if(self = [super initWithAttr:attr])
    {
        int margin = getParamsInt(attr[android_margin], -1);
        if (margin >= 0)
        {
            leftMargin   = margin;
            topMargin    = margin;
            rightMargin  = margin;
            bottomMargin = margin;
        }
        else
        {
            leftMargin   = getParamsInt(attr[android_marginLeft], UNDEFINED_MARGIN);
            if (UNDEFINED_MARGIN == leftMargin)
            {
                mMarginFlags |= LEFT_MARGIN_UNDEFINED_MASK;
                leftMargin    = DEFAULT_MARGIN_RESOLVED;
            }
            
            rightMargin  = getParamsInt(attr[android_marginRight], UNDEFINED_MARGIN);
            if (UNDEFINED_MARGIN == rightMargin)
            {
                mMarginFlags |= RIGHT_MARGIN_UNDEFINED_MASK;
                rightMargin   = DEFAULT_MARGIN_RESOLVED;
            }
            
            topMargin    = getParamsInt(attr[android_marginTop], DEFAULT_MARGIN_RESOLVED);
            bottomMargin = getParamsInt(attr[android_marginBottom], DEFAULT_MARGIN_RESOLVED);
            
            startMargin  = getParamsInt(attr[android_marginStart], DEFAULT_MARGIN_RELATIVE);
            endMargin    = getParamsInt(attr[android_marginEnd], DEFAULT_MARGIN_RELATIVE);
            
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

- (BOOL)isMarginRelative
{
    return ((startMargin != DEFAULT_MARGIN_RELATIVE) || (endMargin != DEFAULT_MARGIN_RELATIVE));
}

@end


    
    
    
    
    
    
    
    
    
    
