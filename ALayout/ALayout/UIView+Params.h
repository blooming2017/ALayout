//
//  UIView+Params.h
//  RMLayout
//
//  Created by Splendour Bell on 2017/4/8.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewParams : NSObject

@end

typedef enum
{
    Visibility_VISIBLE      = 0x00000000,
    Visibility_INVISIBLE    = 0x00000004,
    Visibility_GONE         = 0x00000008
} VisibilityMode;

@interface UIView(Params)

- (ViewParams*)viewParams;

- (VisibilityMode)getVisibility;

- (void)setVisibility:(VisibilityMode)visibilityMode;

@end
