//
//  View+FindView.m
//  RMLayout
//
//  Created by Splendour Bell on 2017/4/8.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "UIView+FindView.h"
#import <objc/runtime.h>

@implementation UIView(FindView)

static const void* KEY_strTag = &KEY_strTag;

- (void)setStrTag:(id _Nullable)strTagHashable
{
    objc_setAssociatedObject(self, KEY_strTag, strTagHashable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable id)strTag;
{
    return objc_getAssociatedObject(self,KEY_strTag);
}

- (nullable __kindof UIView *)viewWithStrTag:(id _Nonnull)strTagHashable
{
    return [self viewWithStrTagHash:[strTagHashable hash]];
}

- (nullable __kindof UIView *)viewWithStrTagHash:(NSUInteger)strTagHash
{
    if ([self.strTag hash] == strTagHash)
    {
        return self;
    }
    else
    {
        NSArray* subViews = self.subviews;
        for(UIView* view in subViews)
        {
            UIView* subView = [view viewWithStrTagHash:strTagHash];
            if(subView)
            {
                return subView;
            }
        }
        return nil;
    }
}

- (nullable __kindof UIView *)objectAtIndexedSubscript:(int)tag
{
    return [self viewWithTag:tag];
}

- (nullable __kindof UIView *)objectForKeyedSubscript:(id _Nonnull)strTag
{
    return [self viewWithStrTag:strTag];
}

@end
