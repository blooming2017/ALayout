//
//  UIView+Params.m
//  RMLayout
//
//  Created by Splendour Bell on 2017/4/8.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "UIView+Params.h"
#import <objc/runtime.h>

@implementation ViewParams
{
@public
    VisibilityMode mVisibilityMode;
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

- (VisibilityMode)getVisibility
{
    return self.viewParams->mVisibilityMode;
}

- (void)setVisibility:(VisibilityMode)visibilityMode
{
    self.viewParams->mVisibilityMode = visibilityMode;
}

@end
