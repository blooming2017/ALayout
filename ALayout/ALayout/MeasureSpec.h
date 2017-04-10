//
//  MeasureSpec.h
//  RMLayout
//
//  Created by Splendour Bell on 2017/4/8.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeasureSpec : NSObject

typedef enum
{
    MeasureSpec_MODE_SHIFT = 30,
    MeasureSpec_MODE_MASK  = 0x3 << MeasureSpec_MODE_SHIFT,
    
    MeasureSpec_UNSPECIFIED = 0 << MeasureSpec_MODE_SHIFT,
    MeasureSpec_EXACTLY     = 1 << MeasureSpec_MODE_SHIFT,
    MeasureSpec_AT_MOST     = 2 << MeasureSpec_MODE_SHIFT
    
} MeasureSpecMode;

+ (int)getMode:(int)measureSpec;

+ (int)makeMeasureSpec:(int)size mode:(MeasureSpecMode)mode;

+ (int)getSize:(int)measureSpec;

@end
