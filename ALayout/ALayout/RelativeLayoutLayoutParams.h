//
//  RelativeLayoutLayoutParams.h
//  ALayout
//
//  Created by splendourbell on 2017/4/11.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "MarginLayoutParams.h"

typedef NSMutableDictionary<NSNumber*, NSString*> RelativeRule;

@interface RelativeLayoutLayoutParams : MarginLayoutParams

@property (nonatomic) RelativeRule* rules;
@property (nonatomic) RelativeRule* initialRules;
@property (nonatomic) int left;
@property (nonatomic) int top;
@property (nonatomic) int right;
@property (nonatomic) int bottom;

@property (nonatomic) BOOL needsLayoutResolution;
@property (nonatomic) BOOL rulesChanged;
@property (nonatomic) BOOL isRtlCompatibilityMode;
@property (nonatomic) BOOL alignWithParent;


- (instancetype)initWithAttr:(NSDictionary*)attr;

- (RelativeRule*)getRules:(int)layoutDirection;

- (RelativeRule*)getRules;

@end
