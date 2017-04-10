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

- (instancetype)init:(NSDictionary*)attr
{
    if(self = [super init])
    {
        NSNumber* width = attr[android_layout_width];
        _width = width ? width.intValue : LayoutParams_WRAP_CONTENT;
        
        NSNumber* height = attr[android_layout_height];
        _height = height ? height.intValue : LayoutParams_MATCH_PARENT;
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
