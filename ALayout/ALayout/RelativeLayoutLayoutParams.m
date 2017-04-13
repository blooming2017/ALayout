//
//  RelativeLayoutLayoutParams.m
//  ALayout
//
//  Created by splendourbell on 2017/4/11.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "AttrKeyDef.h"
#import "RelativeLayout.h"
#import "RelativeLayoutLayoutParams.h"

@implementation RelativeLayoutLayoutParams

- (instancetype)initWithAttr:(NSDictionary*)attr
{
    if(self = [super initWithAttr:attr])
    {
        _rules = [NSMutableDictionary dictionary];
        _needsLayoutResolution = YES;
        [self parseAttr:attr];
    }
    return self;
}

- (void)parseAttr:(NSDictionary*)attr
{
#define if_match_key(x) if([(x) isEqualToString:key])
#define elif_match_key(x) else if([(x) isEqualToString:key])
    
    RelativeRule* rules = _rules;
    
    for(NSString* key in attr)
    {
        if_match_key(RelativeLayout_Layout_layout_alignWithParentIfMissing)
        {
            self.alignWithParent = getBool(attr[key], NO);
        }
        elif_match_key(RelativeLayout_Layout_layout_toLeftOf)
        {
            rules[@(RelativeLayout_LEFT_OF)] = getResourceId(attr[key], nil);
        }
        elif_match_key(RelativeLayout_Layout_layout_toRightOf)
        {
            rules[@(RelativeLayout_RIGHT_OF)] = getResourceId(attr[key], nil);
        }
        elif_match_key(RelativeLayout_Layout_layout_above)
        {
            rules[@(RelativeLayout_ABOVE)] = getResourceId(attr[key], nil);
        }
        elif_match_key(RelativeLayout_Layout_layout_below)
        {
            rules[@(RelativeLayout_BELOW)] = getResourceId(attr[key], nil);
        }
        elif_match_key(RelativeLayout_Layout_layout_alignBaseline)
        {
            rules[@(RelativeLayout_ALIGN_BASELINE)] = getResourceId(attr[key], nil);
        }
        elif_match_key(RelativeLayout_Layout_layout_alignLeft)
        {
            rules[@(RelativeLayout_ALIGN_LEFT)] = getResourceId(attr[key], nil);
        }
        elif_match_key(RelativeLayout_Layout_layout_alignTop)
        {
            rules[@(RelativeLayout_ALIGN_TOP)] = getResourceId(attr[key], nil);
        }
        elif_match_key(RelativeLayout_Layout_layout_alignRight)
        {
            rules[@(RelativeLayout_ALIGN_RIGHT)] = getResourceId(attr[key], nil);
        }
        elif_match_key(RelativeLayout_Layout_layout_alignBottom)
        {
            rules[@(RelativeLayout_ALIGN_BOTTOM)] = getResourceId(attr[key], nil);
        }
        elif_match_key(RelativeLayout_Layout_layout_alignParentLeft)
        {
            rules[@(RelativeLayout_ALIGN_PARENT_LEFT)] = getBool(attr[key], NO) ? @"" : nil;
        }
        elif_match_key(RelativeLayout_Layout_layout_alignParentTop)
        {
            rules[@(RelativeLayout_ALIGN_PARENT_TOP)] = getBool(attr[key], NO) ? @"" : nil;
        }
        elif_match_key(RelativeLayout_Layout_layout_alignParentRight)
        {
            rules[@(RelativeLayout_ALIGN_PARENT_RIGHT)] = getBool(attr[key], NO) ? @"" : nil;
        }
        elif_match_key(RelativeLayout_Layout_layout_alignParentBottom)
        {
            rules[@(RelativeLayout_ALIGN_PARENT_BOTTOM)] = getBool(attr[key], NO) ? @"" : nil;
        }
        elif_match_key(RelativeLayout_Layout_layout_centerInParent)
        {
            rules[@(RelativeLayout_CENTER_IN_PARENT)] = getBool(attr[key], NO) ? @"" : nil;
        }
        elif_match_key(RelativeLayout_Layout_layout_centerHorizontal)
        {
            rules[@(RelativeLayout_CENTER_HORIZONTAL)] = getBool(attr[key], NO) ? @"" : nil;
        }
        elif_match_key(RelativeLayout_Layout_layout_centerVertical)
        {
            rules[@(RelativeLayout_CENTER_VERTICAL)] = getBool(attr[key], NO) ? @"" : nil;
        }
        elif_match_key(RelativeLayout_Layout_layout_toStartOf)
        {
            rules[@(RelativeLayout_START_OF)] = getResourceId(attr[key], nil);
        }
        elif_match_key(RelativeLayout_Layout_layout_toEndOf)
        {
            rules[@(RelativeLayout_END_OF)] = getResourceId(attr[key], nil);
        }
        elif_match_key(RelativeLayout_Layout_layout_alignStart)
        {
            rules[@(RelativeLayout_ALIGN_START)] = getResourceId(attr[key], nil);
        }
        elif_match_key(RelativeLayout_Layout_layout_alignEnd)
        {
            rules[@(RelativeLayout_ALIGN_END)] = getResourceId(attr[key], nil);
        }
        elif_match_key(RelativeLayout_Layout_layout_alignParentStart)
        {
            rules[@(RelativeLayout_ALIGN_PARENT_START)] = getBool(attr[key], NO) ? @"" : nil;
        }
        elif_match_key(RelativeLayout_Layout_layout_alignParentEnd)
        {
            rules[@(RelativeLayout_ALIGN_PARENT_END)] = getBool(attr[key], NO) ? @"" : nil;
        }
    }
    self.rulesChanged = YES;
    self.initialRules = [rules mutableCopy];
}

- (RelativeRule*)getRules:(int)layoutDirection
{
    [self resolveLayoutDirection:layoutDirection];
    return _rules;
}

- (RelativeRule*)getRules
{
    return _rules;
}

- (void)resolveLayoutDirection:(int)layoutDirection
{
    if ([self shouldResolveLayoutDirection:layoutDirection])
    {
        [self resolveRules:layoutDirection];
    }
    [super resolveLayoutDirection:layoutDirection];
}

- (BOOL)shouldResolveLayoutDirection:(int)layoutDirection
{
    return (_needsLayoutResolution || [self hasRelativeRules])
        && (_rulesChanged || (layoutDirection != self.layoutDirection));
}

- (BOOL)hasRelativeRules
{
    return  (  _initialRules[@(RelativeLayout_START_OF)]            || _initialRules[@(RelativeLayout_END_OF)]
            || _initialRules[@(RelativeLayout_ALIGN_START)]         || _initialRules[@(RelativeLayout_ALIGN_END)]
            || _initialRules[@(RelativeLayout_ALIGN_PARENT_START)]  || _initialRules[@(RelativeLayout_ALIGN_PARENT_END)] );
}

- (BOOL)isRelativeRule:(int)rule
{
    return  (  rule == RelativeLayout_START_OF           || rule == RelativeLayout_END_OF
            || rule == RelativeLayout_ALIGN_START        || rule == RelativeLayout_ALIGN_END
            || rule == RelativeLayout_ALIGN_PARENT_START || rule == RelativeLayout_ALIGN_PARENT_END );
}

- (void)resolveRules:(int)layoutDirection
{
    BOOL isLayoutRtl = NO;//TODO:(layoutDirection == View.LAYOUT_DIRECTION_RTL);
    
    _initialRules = [_rules mutableCopy];
    
    if ((_rules[@(RelativeLayout_ALIGN_START)] || _rules[@(RelativeLayout_ALIGN_END)]) &&
        (_rules[@(RelativeLayout_ALIGN_LEFT)]  || _rules[@(RelativeLayout_ALIGN_RIGHT)]))
    {
        _rules[@(RelativeLayout_ALIGN_LEFT)]  = nil;
        _rules[@(RelativeLayout_ALIGN_RIGHT)] = nil;
    }
    if (_rules[@(RelativeLayout_ALIGN_START)])
    {
        _rules[isLayoutRtl ? @(RelativeLayout_ALIGN_RIGHT) : @(RelativeLayout_ALIGN_LEFT)] = _rules[@(RelativeLayout_ALIGN_START)];
        _rules[@(RelativeLayout_ALIGN_START)] = nil;
    }
    if (_rules[@(RelativeLayout_ALIGN_END)])
    {
        _rules[isLayoutRtl ? @(RelativeLayout_ALIGN_LEFT) : @(RelativeLayout_ALIGN_RIGHT)] = _rules[@(RelativeLayout_ALIGN_END)];
        _rules[@(RelativeLayout_ALIGN_END)] = nil;
    }
    
    if ((_rules[@(RelativeLayout_START_OF)] || _rules[@(RelativeLayout_END_OF)]) &&
        (_rules[@(RelativeLayout_LEFT_OF)]  || _rules[@(RelativeLayout_RIGHT_OF)]))
    {
        _rules[@(RelativeLayout_LEFT_OF)] = nil;
        _rules[@(RelativeLayout_RIGHT_OF)] = nil;
    }
    if (_rules[@(RelativeLayout_START_OF)])
    {
        _rules[isLayoutRtl ? @(RelativeLayout_RIGHT_OF) : @(RelativeLayout_LEFT_OF)] = _rules[@(RelativeLayout_START_OF)];
        _rules[@(RelativeLayout_START_OF)] = nil;
    }
    if (_rules[@(RelativeLayout_END_OF)])
    {
        _rules[isLayoutRtl ? @(RelativeLayout_LEFT_OF) : @(RelativeLayout_RIGHT_OF)] = _rules[@(RelativeLayout_END_OF)];
        _rules[@(RelativeLayout_END_OF)] = nil;
    }
    
    if ((_rules[@(RelativeLayout_ALIGN_PARENT_START)] || _rules[@(RelativeLayout_ALIGN_PARENT_END)]) &&
        (_rules[@(RelativeLayout_ALIGN_PARENT_LEFT)]  || _rules[@(RelativeLayout_ALIGN_PARENT_RIGHT)]))
    {
        _rules[@(RelativeLayout_ALIGN_PARENT_LEFT)] = nil;
        _rules[@(RelativeLayout_ALIGN_PARENT_RIGHT)] = nil;
    }
    if (_rules[@(RelativeLayout_ALIGN_PARENT_START)])
    {
        _rules[isLayoutRtl ? @(RelativeLayout_ALIGN_PARENT_RIGHT) : @(RelativeLayout_ALIGN_PARENT_LEFT)] = _rules[@(RelativeLayout_ALIGN_PARENT_START)];
        _rules[@(RelativeLayout_ALIGN_PARENT_START)] = nil;
    }
    if (_rules[@(RelativeLayout_ALIGN_PARENT_END)])
    {
        _rules[isLayoutRtl ? @(RelativeLayout_ALIGN_PARENT_LEFT) : @(RelativeLayout_ALIGN_PARENT_RIGHT)] = _rules[@(RelativeLayout_ALIGN_PARENT_END)];
        _rules[@(RelativeLayout_ALIGN_PARENT_END)] = nil;
    }
    
    _rulesChanged = NO;
    _needsLayoutResolution = NO;
}

@end
