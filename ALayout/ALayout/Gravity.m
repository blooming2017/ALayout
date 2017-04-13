//
//  Gravity.m
//  RMLayout
//
//  Created by splendourbell on 2017/4/7.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "Gravity.h"
#import "UIView+Params.h"

@implementation Gravity

//    /**
//     * Apply a gravity constant to an object. This supposes that the layout direction is LTR.
//     *
//     * @param gravity The desired placement of the object, as defined by the
//     *                constants in this class.
//     * @param w The horizontal size of the object.
//     * @param h The vertical size of the object.
//     * @param container The frame of the containing space, in which the object
//     *                  will be placed.  Should be large enough to contain the
//     *                  width and height of the object.
//     * @param outRect Receives the computed frame of the object in its
//     *                container.
//     */
//    public static void apply(int gravity, int w, int h, Rect container, Rect outRect) {
//        apply(gravity, w, h, container, 0, 0, outRect);
//    }
//
//    /**
//     * Apply a gravity constant to an object and take care if layout direction is RTL or not.
//     *
//     * @param gravity The desired placement of the object, as defined by the
//     *                constants in this class.
//     * @param w The horizontal size of the object.
//     * @param h The vertical size of the object.
//     * @param container The frame of the containing space, in which the object
//     *                  will be placed.  Should be large enough to contain the
//     *                  width and height of the object.
//     * @param outRect Receives the computed frame of the object in its
//     *                container.
//     * @param layoutDirection The layout direction.
//     *
//     * @see View#LAYOUT_DIRECTION_LTR
//     * @see View#LAYOUT_DIRECTION_RTL
//     */
+ (void)apply:(int)gravity w:(int)w h:(int)h container:(const CGRect)container
      outRect:(CGRect*)outRect layoutDirection:(int)layoutDirection
{
    int absGravity = [self getAbsoluteGravity:gravity layoutDirection:layoutDirection];
    [self apply:absGravity w:w h:h container:container outRect:outRect layoutDirection:layoutDirection];
}
//
//    /**
//     * Apply a gravity constant to an object.
//     *
//     * @param gravity The desired placement of the object, as defined by the
//     *                constants in this class.
//     * @param w The horizontal size of the object.
//     * @param h The vertical size of the object.
//     * @param container The frame of the containing space, in which the object
//     *                  will be placed.  Should be large enough to contain the
//     *                  width and height of the object.
//     * @param xAdj Offset to apply to the X axis.  If gravity is LEFT this
//     *             pushes it to the right; if gravity is RIGHT it pushes it to
//     *             the left; if gravity is CENTER_HORIZONTAL it pushes it to the
//     *             right or left; otherwise it is ignored.
//     * @param yAdj Offset to apply to the Y axis.  If gravity is TOP this pushes
//     *             it down; if gravity is BOTTOM it pushes it up; if gravity is
//     *             CENTER_VERTICAL it pushes it down or up; otherwise it is
//     *             ignored.
//     * @param outRect Receives the computed frame of the object in its
//     *                container.
//     */
+ (void)apply:(int)gravity w:(int)w h:(int)h container:(const CGRect)container
         xAdj:(int)xAdj yAdj:(int)yAdj outRect:(CGRect*)outRect
{
    switch (gravity&((Gravity_AXIS_PULL_BEFORE|Gravity_AXIS_PULL_AFTER)<<Gravity_AXIS_X_SHIFT))
    {
        case 0:
            outRect->origin.x = container.origin.x
                    + ((container.size.width - w)/2) + xAdj;
            outRect->size.width = w;
            if ((gravity&(Gravity_AXIS_CLIP<<Gravity_AXIS_X_SHIFT))
                == (Gravity_AXIS_CLIP<<Gravity_AXIS_X_SHIFT))
            {
                if (outRect->origin.x < container.origin.x)
                {
                    outRect->origin.x = container.origin.x;
                }
                if (CGRectGetMaxX(*outRect) > CGRectGetMaxX(container))
                {
                    outRect->size.width = CGRectGetMaxX(container) - outRect->origin.x;
                }
            }
            break;
            
        case Gravity_AXIS_PULL_BEFORE<<Gravity_AXIS_X_SHIFT:
            outRect->origin.x = container.origin.x + xAdj;
            outRect->size.width = w;
            if ((gravity&(Gravity_AXIS_CLIP<<Gravity_AXIS_X_SHIFT))
                == (Gravity_AXIS_CLIP<<Gravity_AXIS_X_SHIFT))
            {
                if (CGRectGetMaxX(*outRect) > CGRectGetMaxX(container))
                {
                    outRect->size.width = CGRectGetMaxX(container) - outRect->origin.x;
                }
            }
            break;
            
        case Gravity_AXIS_PULL_AFTER<<Gravity_AXIS_X_SHIFT:
            outRect->size.width = CGRectGetMaxX(container) - xAdj - outRect->origin.x;
            outRect->origin.x = CGRectGetMaxX(*outRect) - w;
            if ((gravity&(Gravity_AXIS_CLIP<<Gravity_AXIS_X_SHIFT))
                == (Gravity_AXIS_CLIP<<Gravity_AXIS_X_SHIFT))
            {
                if (outRect->origin.x < container.origin.x)
                {
                    outRect->origin.x = container.origin.x;
                }
            }
            break;
        default:
            outRect->origin.x = container.origin.x + xAdj;
            outRect->size.width = CGRectGetMaxX(container) + xAdj - outRect->origin.x;
            break;
    }

    switch (gravity&((Gravity_AXIS_PULL_BEFORE|Gravity_AXIS_PULL_AFTER)<<Gravity_AXIS_Y_SHIFT))
    {
        case 0:
            outRect->origin.y = container.origin.y
                    + ((container.size.height - h)/2) + yAdj;
            outRect->size.height = outRect->origin.y + h - outRect->origin.y;
            if ((gravity&(Gravity_AXIS_CLIP<<Gravity_AXIS_Y_SHIFT))
                == (Gravity_AXIS_CLIP<<Gravity_AXIS_Y_SHIFT))
            {
                if (outRect->origin.y < container.origin.y)
                {
                    outRect->origin.y = container.origin.y;
                }
                
                if (CGRectGetMaxY(*outRect) > CGRectGetMaxY(container))
                {
                    outRect->size.height = CGRectGetMaxY(container) - outRect->origin.y;
                }
            }
            break;
        case Gravity_AXIS_PULL_BEFORE<<Gravity_AXIS_Y_SHIFT:
            outRect->origin.y = container.origin.y + yAdj;
            outRect->size.height = outRect->origin.y + h - outRect->origin.y;
            if ((gravity&(Gravity_AXIS_CLIP<<Gravity_AXIS_Y_SHIFT))
                == (Gravity_AXIS_CLIP<<Gravity_AXIS_Y_SHIFT))
            {
                if (CGRectGetMaxY(*outRect) > CGRectGetMaxY(container))
                {
                    outRect->size.height = CGRectGetMaxY(container) - outRect->origin.y;
                }
            }
            break;
        case Gravity_AXIS_PULL_AFTER<<Gravity_AXIS_Y_SHIFT:
            outRect->size.height = CGRectGetMaxY(container) - yAdj - outRect->origin.y;
            outRect->origin.y = CGRectGetMaxY(*outRect) - h;
            if ((gravity&(Gravity_AXIS_CLIP<<Gravity_AXIS_Y_SHIFT))
                == (Gravity_AXIS_CLIP<<Gravity_AXIS_Y_SHIFT))
            {
                if (outRect->origin.y < container.origin.y)
                {
                    outRect->origin.y = container.origin.y;
                }
            }
            break;
        default:
            outRect->origin.y = container.origin.y + yAdj;
            outRect->size.height = CGRectGetMaxY(container) + yAdj - outRect->origin.y;
            break;
    }
}
//
//    /**
//     * Apply a gravity constant to an object.
//     *
//     * @param gravity The desired placement of the object, as defined by the
//     *                constants in this class.
//     * @param w The horizontal size of the object.
//     * @param h The vertical size of the object.
//     * @param container The frame of the containing space, in which the object
//     *                  will be placed.  Should be large enough to contain the
//     *                  width and height of the object.
//     * @param xAdj Offset to apply to the X axis.  If gravity is LEFT this
//     *             pushes it to the right; if gravity is RIGHT it pushes it to
//     *             the left; if gravity is CENTER_HORIZONTAL it pushes it to the
//     *             right or left; otherwise it is ignored.
//     * @param yAdj Offset to apply to the Y axis.  If gravity is TOP this pushes
//     *             it down; if gravity is BOTTOM it pushes it up; if gravity is
//     *             CENTER_VERTICAL it pushes it down or up; otherwise it is
//     *             ignored.
//     * @param outRect Receives the computed frame of the object in its
//     *                container.
//     * @param layoutDirection The layout direction.
//     *
//     * @see View#LAYOUT_DIRECTION_LTR
//     * @see View#LAYOUT_DIRECTION_RTL
//     */
//    public static void apply(int gravity, int w, int h, Rect container,
//                             int xAdj, int yAdj, Rect outRect, int layoutDirection) {
//        int absGravity = getAbsoluteGravity(gravity, layoutDirection);
//        apply(absGravity, w, h, container, xAdj, yAdj, outRect);
//    }
//
//    /**
//     * Apply additional gravity behavior based on the overall "display" that an
//     * object exists in.  This can be used after
//     * {@link #apply(int, int, int, Rect, int, int, Rect)} to place the object
//     * within a visible display.  By default this moves or clips the object
//     * to be visible in the display; the gravity flags
//     * {@link #DISPLAY_CLIP_HORIZONTAL} and {@link #DISPLAY_CLIP_VERTICAL}
//     * can be used to change this behavior.
//     *
//     * @param gravity Gravity constants to modify the placement within the
//     * display.
//     * @param display The rectangle of the display in which the object is
//     * being placed.
//     * @param inoutObj Supplies the current object position; returns with it
//     * modified if needed to fit in the display.
//     */
//    public static void applyDisplay(int gravity, Rect display, Rect inoutObj) {
//        if ((gravity&DISPLAY_CLIP_VERTICAL) != 0) {
//            if (inoutObj.top < display.top) inoutObj.top = display.top;
//            if (inoutObj.bottom > display.bottom) inoutObj.bottom = display.bottom;
//        } else {
//            int off = 0;
//            if (inoutObj.top < display.top) off = display.top-inoutObj.top;
//            else if (inoutObj.bottom > display.bottom) off = display.bottom-inoutObj.bottom;
//            if (off != 0) {
//                if (inoutObj.height() > (display.bottom-display.top)) {
//                    inoutObj.top = display.top;
//                    inoutObj.bottom = display.bottom;
//                } else {
//                    inoutObj.top += off;
//                    inoutObj.bottom += off;
//                }
//            }
//        }
//
//        if ((gravity&DISPLAY_CLIP_HORIZONTAL) != 0) {
//            if (inoutObj.left < display.left) inoutObj.left = display.left;
//            if (inoutObj.right > display.right) inoutObj.right = display.right;
//        } else {
//            int off = 0;
//            if (inoutObj.left < display.left) off = display.left-inoutObj.left;
//            else if (inoutObj.right > display.right) off = display.right-inoutObj.right;
//            if (off != 0) {
//                if (inoutObj.width() > (display.right-display.left)) {
//                    inoutObj.left = display.left;
//                    inoutObj.right = display.right;
//                } else {
//                    inoutObj.left += off;
//                    inoutObj.right += off;
//                }
//            }
//        }
//    }
//
//    /**
//     * Apply additional gravity behavior based on the overall "display" that an
//     * object exists in.  This can be used after
//     * {@link #apply(int, int, int, Rect, int, int, Rect)} to place the object
//     * within a visible display.  By default this moves or clips the object
//     * to be visible in the display; the gravity flags
//     * {@link #DISPLAY_CLIP_HORIZONTAL} and {@link #DISPLAY_CLIP_VERTICAL}
//     * can be used to change this behavior.
//     *
//     * @param gravity Gravity constants to modify the placement within the
//     * display.
//     * @param display The rectangle of the display in which the object is
//     * being placed.
//     * @param inoutObj Supplies the current object position; returns with it
//     * modified if needed to fit in the display.
//     * @param layoutDirection The layout direction.
//     *
//     * @see View#LAYOUT_DIRECTION_LTR
//     * @see View#LAYOUT_DIRECTION_RTL
//     */
//    public static void applyDisplay(int gravity, Rect display, Rect inoutObj, int layoutDirection) {
//        int absGravity = getAbsoluteGravity(gravity, layoutDirection);
//        applyDisplay(absGravity, display, inoutObj);
//    }
//
//    /**
//     * <p>Indicate whether the supplied gravity has a vertical pull.</p>
//     *
//     * @param gravity the gravity to check for vertical pull
//     * @return true if the supplied gravity has a vertical pull
//     */
//    public static boolean isVertical(int gravity) {
//        return gravity > 0 && (gravity & VERTICAL_GRAVITY_MASK) != 0;
//    }
//
//    /**
//     * <p>Indicate whether the supplied gravity has an horizontal pull.</p>
//     *
//     * @param gravity the gravity to check for horizontal pull
//     * @return true if the supplied gravity has an horizontal pull
//     */
//    public static boolean isHorizontal(int gravity) {
//        return gravity > 0 && (gravity & RELATIVE_HORIZONTAL_GRAVITY_MASK) != 0;
//    }
//
//    /**
//     * <p>Convert script specific gravity to absolute horizontal value.</p>
//     *
//     * if horizontal direction is LTR, then START will set LEFT and END will set RIGHT.
//     * if horizontal direction is RTL, then START will set RIGHT and END will set LEFT.
//     *
//     *
//     * @param gravity The gravity to convert to absolute (horizontal) values.
//     * @param layoutDirection The layout direction.
//     * @return gravity converted to absolute (horizontal) values.
//     */
+ (int)getAbsoluteGravity:(int)gravity layoutDirection:(int)layoutDirection
{
    int result = gravity;
    // If layout is script specific and gravity is horizontal relative (START or END)
    if ((result & Gravity_RELATIVE_LAYOUT_DIRECTION) > 0)
    {
        if ((result & Gravity_START) == Gravity_START)
        {
            // Remove the START bit
            result &= ~Gravity_START;
            if (layoutDirection == VIEW_LAYOUT_DIRECTION_RTL)
            {
                // Set the RIGHT bit
                result |= Gravity_RIGHT;
            }
            else
            {
                // Set the LEFT bit
                result |= Gravity_LEFT;
            }
        }
        else if ((result & Gravity_END) == Gravity_END)
        {
            // Remove the END bit
            result &= ~Gravity_END;
            if (layoutDirection == VIEW_LAYOUT_DIRECTION_RTL)
            {
                // Set the LEFT bit
                result |= Gravity_LEFT;
            }
            else
            {
                // Set the RIGHT bit
                result |= Gravity_RIGHT;
            }
        }
        // Don't need the script specific bit any more, so remove it as we are converting to
        // absolute values (LEFT or RIGHT)
        result &= ~Gravity_RELATIVE_LAYOUT_DIRECTION;
    }
    return result;
}

@end
