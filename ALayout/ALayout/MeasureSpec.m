//
//  MeasureSpec.m
//  RMLayout
//
//  Created by Splendour Bell on 2017/4/8.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "MeasureSpec.h"

@implementation MeasureSpec

+ (int)getMode:(int)measureSpec
{
    return (measureSpec & MeasureSpec_MODE_MASK);
}

+ (int)makeMeasureSpec:(int)size mode:(MeasureSpecMode)mode
{
    return (size & ~MeasureSpec_MODE_MASK) | (mode & MeasureSpec_MODE_MASK);
}

+ (int)getSize:(int)measureSpec
{
    return (measureSpec & ~MeasureSpec_MODE_MASK);
}

@end
