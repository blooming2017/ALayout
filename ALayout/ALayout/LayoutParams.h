//
//  LayoutParams.h
//  RMLayout
//
//  Created by splendourbell on 2017/4/6.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import <UIKit/UIKit.h>

enum
{
    LayoutParams_MATCH_PARENT = -1,
    LayoutParams_WRAP_CONTENT = -2
};

@interface LayoutParams : NSObject

- (instancetype)initWithAttr:(NSDictionary*)attr;

@property (nonatomic) int width;
@property (nonatomic) int height;

@end

@interface UIView(ALayoutParams)

- (LayoutParams*)layoutParams;

- (void)setLayoutParams:(LayoutParams*)layoutParams;

@end

int getParamsInt(id value, int defaultValue);

float getParamsFloat(id value, float defaultValue);

BOOL getBool(id value, BOOL defaultValue);

NSString* getResourceId(id value, NSString* defaultValue);

int getDimensionPixelSize(id value, int defaultValue);

int getDimensionPixelOffset(id value, int defaultValue);
