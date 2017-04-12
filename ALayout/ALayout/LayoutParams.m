//
//  LayoutParams.m
//  RMLayout
//
//  Created by splendourbell on 2017/4/6.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "LayoutParams.h"
#import "AttrKeyDef.h"
#import <objc/runtime.h>

@implementation LayoutParams

- (instancetype)init
{
    if(self = [super init])
    {
        _width = LayoutParams_WRAP_CONTENT;
        _height = LayoutParams_WRAP_CONTENT;
    }
    return self;
}

- (instancetype)initWithAttr:(NSDictionary*)attr
{
    if(self = [super init])
    {
        NSString* width = attr[ViewGroup_Layout_layout_width];
        if(width)
        {
            if([width isEqualToString:V_match_parent])
            {
                _width = LayoutParams_MATCH_PARENT;
            }
            else if([width isEqualToString:V_wrap_content])
            {
                _width = LayoutParams_WRAP_CONTENT;
            }
            else
            {
                _width = [width intValue];
            }
        }
        
        NSString* height = attr[ViewGroup_Layout_layout_height];
        if(height)
        {
            if([height isEqualToString:V_match_parent])
            {
                _height = LayoutParams_MATCH_PARENT;
            }
            else if([height isEqualToString:V_wrap_content])
            {
                _height = LayoutParams_WRAP_CONTENT;
            }
            else
            {
                _height = [height intValue];
            }   
        }
    }
    return self;
}

@end

@implementation UIView(ALayoutParams)

static const void* KEY_layoutParams = &KEY_layoutParams;

- (LayoutParams*)layoutParams
{
    LayoutParams* layoutParams = objc_getAssociatedObject(self, KEY_layoutParams);
    if(!layoutParams)
    {
        layoutParams = [LayoutParams new];
        [self setLayoutParams:layoutParams];
    }
    return layoutParams;
}

- (void)setLayoutParams:(LayoutParams*)layoutParams
{
    objc_setAssociatedObject(self, KEY_layoutParams, layoutParams, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

int getParamsInt(id value, int defaultValue)
{
    return value ? [value intValue] : defaultValue;
}

float getParamsFloat(id value, float defaultValue)
{
    return value ? [value floatValue] : defaultValue;
}

BOOL getBool(id value, BOOL defaultValue)
{
    assert([value isKindOfClass:NSString.class]);
    NSString* boolStrValue = (NSString*)value;
    if(boolStrValue)
    {
        return [boolStrValue isEqualToString:@"true"];
    }
    return defaultValue;
}

NSString* getResourceId(id value, NSString* defaultValue)
{
    assert([value isKindOfClass:NSString.class]);
    NSString* idStr = (NSString*)value;
    NSRange range = [idStr rangeOfString:@"/" options:NSBackwardsSearch];
    if(range.length)
    {
        idStr = [idStr substringFromIndex:range.location+range.length];
    }
    else
    {
        idStr = defaultValue;
    }
    return idStr;
}

int getDimensionPixelSize(id value, int defaultValue)
{
    assert([value isKindOfClass:NSString.class]);
    
    NSString* strPx = (NSString*)value;
    if([strPx hasSuffix:@"px"])
    {
        strPx = [strPx substringToIndex:strPx.length - 2];
    }
    return strPx ? strPx.intValue : defaultValue;
}

int getDimensionPixelOffset(id value, int defaultValue)
{
    return getDimensionPixelSize(value, defaultValue);
}

