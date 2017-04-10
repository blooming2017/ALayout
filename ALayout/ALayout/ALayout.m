//
//  ALayout.m
//  RMLayout
//
//  Created by splendourbell on 2017/4/6.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "ALayout.h"
#import "LayoutParams.h"
#import "AttrKeyDef.h"

static NSMutableDictionary* ViewClassRegisters = nil;

void RegisterViewClass(NSString* viewName, Class cls)
{
    if(!ViewClassRegisters) ViewClassRegisters = [NSMutableDictionary new];
#ifdef DEBUG
    //不能重复注册
    assert(!ViewClassRegisters[viewName]);
#endif
    ViewClassRegisters[viewName] = cls;
}

@implementation UIView(ALayoutProtocol)

@end

@implementation ALayout
{
    NSDictionary* _attr;
}

- (instancetype)init:(NSDictionary*)attr
{
    if(self = [super init])
    {
        _attr = attr;
    }
    return self;
}

- (UIView*)parse
{
    return [self parseView:_attr];
}

- (UIView*)parseTree:(NSDictionary*)attr
{
    UIView* view = [self parseView:attr];
    [self parseChildren:attr[@"children"] parent:view];
    return view;
}

- (void)parseChildren:(NSArray<NSDictionary*>*) children parent:(UIView*)parent
{
    for(NSDictionary* attr in children)
    {
        UIView* view = [self parseView:attr];
        [parent addSubview:view];
    }
}

- (UIView*)parseView:(NSDictionary*)attr
{
    NSString* className = attr[@"class"];
    Class cls = ViewClassRegisters[className];
    UIView* view = [cls new];
    [self preParseAttr:attr view:view];
    
    if([view conformsToProtocol:@protocol(ALayoutProtocol)])
    {
        if([view respondsToSelector:@selector(parseAttr:)])
        {
            [(id<ALayoutProtocol>)view parseAttr:attr];
        }
    }
    return view;
}

- (void)preParseAttr:(NSDictionary*)attr view:(UIView*)view
{

}

@end
