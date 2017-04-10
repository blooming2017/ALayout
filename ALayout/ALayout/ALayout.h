//
//  ALayout.h
//  RMLayout
//
//  Created by splendourbell on 2017/4/6.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RegisterView(viewName) \
+ (void)load \
{\
    void RegisterViewClass(NSString* viewName, Class cls);\
    RegisterViewClass(@#viewName, self);\
}

@protocol ALayoutProtocol <NSObject>

@optional

- (void)parseAttr:(NSDictionary*)attr;

- (void)onMeasure:(int)widthMeasureSpec heightSpec:(int)heightMeasureSpec;

@end

@interface UIView(ALayoutProtocol) <ALayoutProtocol>

@end

@interface ALayout : NSObject

- (instancetype)init:(NSDictionary*)attr;

- (UIView*)parse;

@end
