//
//  RelativeLayoutLayoutParams.h
//  ALayout
//
//  Created by splendourbell on 2017/4/11.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "MarginLayoutParams.h"

@interface RelativeLayoutLayoutParams : MarginLayoutParams

@property (nonatomic) NSMutableDictionary<NSNumber*, NSString*>* rules;
@property (nonatomic) NSMutableDictionary<NSNumber*, NSString*>* initialRules;
@property (nonatomic) int left;
@property (nonatomic) int top;
@property (nonatomic) int right;
@property (nonatomic) int bottom;

@property (nonatomic) BOOL needsLayoutResolution;
@property (nonatomic) BOOL rulesChanged;
@property (nonatomic) BOOL isRtlCompatibilityMode;
@property (nonatomic) BOOL alignWithParent;


- (instancetype)initWithAttr:(NSDictionary*)attr;

@end
