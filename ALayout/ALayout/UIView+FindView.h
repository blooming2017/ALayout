//
//  UIView+FindView.h
//  RMLayout
//
//  Created by Splendour Bell on 2017/4/8.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(FindView)

- (void)setStrTag:(id _Nullable)strTagHashable;

- (nullable id)strTag;

- (nullable __kindof UIView *)objectAtIndexedSubscript:(int)tag;

- (nullable __kindof UIView *)objectForKeyedSubscript:(id _Nonnull)strTag;

@end
