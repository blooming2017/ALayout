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
#import "UIView+Params.h"

static NSMutableDictionary* ViewClassRegisters = nil;

void RegisterViewClass(NSString* className, Class cls)
{
    if(!ViewClassRegisters) ViewClassRegisters = [NSMutableDictionary new];
#ifdef DEBUG
    //不能重复注册
    assert(!ViewClassRegisters[className]);
#endif
    ViewClassRegisters[className] = cls;
}

static Class viewClass(NSString* className)
{
    Class cls = ViewClassRegisters[className];
    
#ifdef DEBUG
    assert(className);
#endif
    
    if(!cls && className)
    {
        cls = NSClassFromString(className);
        ViewClassRegisters[className] = cls;
    }
    return cls;
}

@implementation UIView(ALayoutProtocol)

@end

@implementation ALayout
{
    NSDictionary* _attr;
}

- (instancetype)initWithDict:(NSDictionary*)attr
{
    if(self = [super init])
    {
        _attr = attr;
    }
    return self;
}

- (UIView*)parse
{
    UIView* view = [self parseTree:_attr];
    LayoutParams* layoutParams = [view generateLayoutParams:_attr];
    view.layoutParams = layoutParams;
    return view;
}

- (UIView*)parseTree:(NSDictionary*)attr
{
    UIView* view = [self parseView:attr];
    [self parseChildren:attr[@"children"] parent:view];
    return view;
}

- (UIView*)parseView:(NSDictionary*)attr
{
    NSString* className = attr[@"class"];
    Class cls = viewClass(className);
    UIView* view = [cls new];
    [self preParseAttr:attr view:view];
    [(id<ALayoutProtocol>)view parseAttr:attr];
    
    return view;
}

- (void)parseChildren:(NSArray<NSDictionary*>*) children parent:(UIView*)parent
{
    for(NSDictionary* attr in children)
    {
        UIView* view = [self parseView:attr];
        view.layoutParams = [parent generateLayoutParams:attr];
        [parent addSubview:view];
    }
}

- (void)preParseAttr:(NSDictionary*)attr view:(UIView*)view
{

}

@end
