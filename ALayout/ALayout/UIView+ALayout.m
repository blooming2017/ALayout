//
//  UIView+ALayout.m
//  RMLayout
//
//  Created by splendourbell on 2017/4/6.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "UIView+ALayout.h"
#import "UIView+Params.h"
#import "ALayout.h"

@implementation UIView(ALayout)

RegisterView(view);

- (void)parseAttr:(NSDictionary*)attr
{
    [self setViewAttr:attr];
}

@end
