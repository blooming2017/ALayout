//
//  RelativeLayout.h
//  RMLayout
//
//  Created by splendourbell on 2017/4/7.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "ViewGroup.h"
#import "ALayout.h"

#define RelativeLayout_ALIGN_VERB_COUNT 22

enum
{
    RelativeLayout_TRUE = -1,

    /**
     * Rule that aligns a child's right edge with another child's left edge.
     */
    RelativeLayout_LEFT_OF                  = 0,
    /**
     * Rule that aligns a child's left edge with another child's right edge.
     */
    RelativeLayout_RIGHT_OF                 = 1,
    /**
     * Rule that aligns a child's bottom edge with another child's top edge.
     */
    RelativeLayout_ABOVE                    = 2,
    /**
     * Rule that aligns a child's top edge with another child's bottom edge.
     */
    RelativeLayout_BELOW                    = 3,

    /**
     * Rule that aligns a child's baseline with another child's baseline.
     */
    RelativeLayout_ALIGN_BASELINE           = 4,
    /**
     * Rule that aligns a child's left edge with another child's left edge.
     */
    RelativeLayout_ALIGN_LEFT               = 5,
    /**
     * Rule that aligns a child's top edge with another child's top edge.
     */
    RelativeLayout_ALIGN_TOP                = 6,
    /**
     * Rule that aligns a child's right edge with another child's right edge.
     */
    RelativeLayout_ALIGN_RIGHT              = 7,
    /**
     * Rule that aligns a child's bottom edge with another child's bottom edge.
     */
    RelativeLayout_ALIGN_BOTTOM             = 8,

    /**
     * Rule that aligns the child's left edge with its RelativeLayout
     * parent's left edge.
     */
    RelativeLayout_ALIGN_PARENT_LEFT        = 9,
    /**
     * Rule that aligns the child's top edge with its RelativeLayout
     * parent's top edge.
     */
    RelativeLayout_ALIGN_PARENT_TOP         = 10,
    /**
     * Rule that aligns the child's right edge with its RelativeLayout
     * parent's right edge.
     */
    RelativeLayout_ALIGN_PARENT_RIGHT       = 11,
    /**
     * Rule that aligns the child's bottom edge with its RelativeLayout
     * parent's bottom edge.
     */
    RelativeLayout_ALIGN_PARENT_BOTTOM      = 12,

    /**
     * Rule that centers the child with respect to the bounds of its
     * RelativeLayout parent.
     */
    RelativeLayout_CENTER_IN_PARENT         = 13,
    /**
     * Rule that centers the child horizontally with respect to the
     * bounds of its RelativeLayout parent.
     */
    RelativeLayout_CENTER_HORIZONTAL        = 14,
    /**
     * Rule that centers the child vertically with respect to the
     * bounds of its RelativeLayout parent.
     */
    RelativeLayout_CENTER_VERTICAL          = 15,
    /**
     * Rule that aligns a child's end edge with another child's start edge.
     */
    RelativeLayout_START_OF                 = 16,
    /**
     * Rule that aligns a child's start edge with another child's end edge.
     */
    RelativeLayout_END_OF                   = 17,
    /**
     * Rule that aligns a child's start edge with another child's start edge.
     */
    RelativeLayout_ALIGN_START              = 18,
    /**
     * Rule that aligns a child's end edge with another child's end edge.
     */
    RelativeLayout_ALIGN_END                = 19,
    /**
     * Rule that aligns the child's start edge with its RelativeLayout
     * parent's start edge.
     */
    RelativeLayout_ALIGN_PARENT_START       = 20,
    /**
     * Rule that aligns the child's end edge with its RelativeLayout
     * parent's end edge.
     */
    RelativeLayout_ALIGN_PARENT_END         = 21
};


//private static final int[] RULES_VERTICAL = {
//    ABOVE, BELOW, ALIGN_BASELINE, ALIGN_TOP, ALIGN_BOTTOM
//};
//
//private static final int[] RULES_HORIZONTAL = {
//    LEFT_OF, RIGHT_OF, ALIGN_LEFT, ALIGN_RIGHT, START_OF, END_OF, ALIGN_START, ALIGN_END
//};
//
///**
// * Used to indicate left/right/top/bottom should be inferred from constraints
// */
//private static final int VALUE_NOT_SET = Integer.MIN_VALUE;

@interface RelativeLayout : ViewGroup<ALayoutProtocol>

@end


