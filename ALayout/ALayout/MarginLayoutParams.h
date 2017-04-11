//
//  MarginLayoutParams.h
//  RMLayout
//
//  Created by Splendour Bell on 2017/4/8.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "LayoutParams.h"

@interface MarginLayoutParams : LayoutParams

@property (assign) int leftMargin;
@property (assign) int topMargin;
@property (assign) int rightMargin;
@property (assign) int bottomMargin;

@property (assign) int startMargin;
@property (assign) int endMargin;

- (instancetype)initWithAttr:(NSDictionary*)attr;

- (void)resolveLayoutDirection:(int)layoutDirection;

- (int)layoutDirection;

- (BOOL)isLayoutRtl;

@end



