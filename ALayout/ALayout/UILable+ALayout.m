//
//  UILable+ALayout.m
//  ALayout
//
//  Created by splendourbell on 2017/4/11.
//  Copyright © 2017年 ajja.sdjkf.sd. All rights reserved.
//

#import "UILable+ALayout.h"
#import "MeasureSpec.h"
#import "UIView+Params.h"
#import "ALayout.h"

@implementation UILabel(ALayout)

RegisterView(TextView)

- (void)parseAttr:(NSDictionary *)attr
{
#define if_match_key(x) if([(x) isEqualToString:key])
#define elif_match_key(x) else if([(x) isEqualToString:key])
    
    for(NSString* key in attr)
    {
        if_match_key(TextView_editable)
        {
            //editable = a.getBoolean(attr, editable);
        }
        elif_match_key(TextView_digits)
        {
            //numeric = a.getInt(attr, numeric);
        }
        elif_match_key(TextView_autoText)
        {
            //autotext = a.getBoolean(attr, autotext);
        }
        elif_match_key(TextView_bufferType)
        {
            //buffertype = a.getInt(attr, buffertype);
        }
        elif_match_key(TextView_selectAllOnFocus)
        {
            //selectallonfocus = a.getBoolean(attr, selectallonfocus);
        }
        elif_match_key(TextView_autoLink)
        {
            //mAutoLinkMask = a.getInt(attr, 0);
        }
        elif_match_key(TextView_linksClickable)
        {
            //mLinksClickable = a.getBoolean(attr, true);
        }
        elif_match_key(TextView_drawableLeft)
        {
            //drawableLeft = a.getDrawable(attr);
        }
        elif_match_key(TextView_drawableTop)
        {
            //drawableTop = a.getDrawable(attr);
        }
        elif_match_key(TextView_drawableRight)
        {
            //drawableRight = a.getDrawable(attr);
        }
        elif_match_key(TextView_drawableBottom)
        {
            //drawableBottom = a.getDrawable(attr);
        }
        elif_match_key(TextView_drawableStart)
        {
            //drawableStart = a.getDrawable(attr);
        }
        elif_match_key(TextView_drawableEnd)
        {
            //drawableEnd = a.getDrawable(attr);
        }
        elif_match_key(TextView_drawableTint)
        {
            //drawableTint = a.getColorStateList(attr);
        }
        elif_match_key(TextView_drawableTintMode)
        {
            //drawableTintMode = Drawable.parseTintMode(a.getInt(attr, -1), drawableTintMode);
        }
        elif_match_key(TextView_drawablePadding)
        {
            //drawablePadding = a.getDimensionPixelSize(attr, drawablePadding);
        }
        elif_match_key(TextView_maxLines)
        {
            //setMaxLines(a.getInt(attr, -1));
        }
        elif_match_key(TextView_maxHeight)
        {
            //setMaxHeight(a.getDimensionPixelSize(attr, -1));
        }
        elif_match_key(TextView_lines)
        {
            //setLines(a.getInt(attr, -1));
        }
        elif_match_key(TextView_height)
        {
            //setHeight(a.getDimensionPixelSize(attr, -1));
        }
        elif_match_key(TextView_minLines)
        {
            //setMinLines(a.getInt(attr, -1));
        }
        elif_match_key(TextView_minHeight)
        {
            //setMinHeight(a.getDimensionPixelSize(attr, -1));
        }
        elif_match_key(TextView_maxWidth)
        {
            //setMaxEms(a.getInt(attr, -1));
        }
        elif_match_key(TextView_ems)
        {
            //setEms(a.getInt(attr, -1));
        }
        elif_match_key(TextView_width)
        {
            //setWidth(a.getDimensionPixelSize(attr, -1));
        }
        elif_match_key(TextView_minEms)
        {
            //setMinEms(a.getInt(attr, -1));
        }
        elif_match_key(TextView_minWidth)
        {
            //setMinWidth(a.getDimensionPixelSize(attr, -1));
        }
        elif_match_key(TextView_gravity)
        {
            //setGravity(a.getInt(attr, -1));
        }
        elif_match_key(TextView_hint)
        {
            //hint = a.getText(attr);
        }
        elif_match_key(TextView_text)
        {
            self.text = getParamsText(attr[key], @"");
            //text = a.getText(attr);
        }
        elif_match_key(TextView_scrollHorizontally)
        {
//            if (a.getBoolean(attr, false)) {
//                setHorizontallyScrolling(true);
//            }
        }
        elif_match_key(TextView_singleLine)
        {
            //singleLine = a.getBoolean(attr, singleLine);
        }
        elif_match_key(TextView_ellipsize)
        {
            //ellipsize = a.getInt(attr, ellipsize);
        }
        elif_match_key(TextView_marqueeRepeatLimit)
        {
            //setMarqueeRepeatLimit(a.getInt(attr, mMarqueeRepeatLimit));
        }
        elif_match_key(TextView_includeFontPadding)
        {
//            if (!a.getBoolean(attr, true)) {
//                setIncludeFontPadding(false);
//            }
        }
        elif_match_key(TextView_cursorVisible)
        {
//            if (!a.getBoolean(attr, true)) {
//                setCursorVisible(false);
//            }
        }
        elif_match_key(TextView_maxLength)
        {
            //maxlength = a.getInt(attr, -1);
        }
        elif_match_key(TextView_textScaleX)
        {
            //setTextScaleX(a.getFloat(attr, 1.0f));
        }
        elif_match_key(TextView_freezesText)
        {
            //mFreezesText = a.getBoolean(attr, false);
        }
        elif_match_key(TextView_shadowColor)
        {
            //shadowcolor = a.getInt(attr, 0);
        }
        elif_match_key(TextView_shadowDx)
        {
            //dx = a.getFloat(attr, 0);
        }
        elif_match_key(TextView_shadowDy)
        {
            //dy = a.getFloat(attr, 0);
        }
        elif_match_key(TextView_shadowRadius)
        {
            //r = a.getFloat(attr, 0);
        }
        elif_match_key(TextView_enabled)
        {
            //setEnabled(a.getBoolean(attr, isEnabled()));
        }
        elif_match_key(TextView_textColorHighlight)
        {
            //textColorHighlight = a.getColor(attr, textColorHighlight);
        }
        elif_match_key(TextView_textColor)
        {
            //textColor = a.getColorStateList(attr);
        }
        elif_match_key(TextView_textColorHint)
        {
            //textColorHint = a.getColorStateList(attr);
        }
        elif_match_key(TextView_textColorLink)
        {
            //textColorLink = a.getColorStateList(attr);
        }
        elif_match_key(TextView_textSize)
        {
            self.font = [UIFont systemFontOfSize:getDimensionPixelSize(attr[key], 16)];
            //textSize = a.getDimensionPixelSize(attr, textSize);
        }
        elif_match_key(TextView_typeface)
        {
            //typefaceIndex = a.getInt(attr, typefaceIndex);
        }
        elif_match_key(TextView_textStyle)
        {
            //styleIndex = a.getInt(attr, styleIndex);
        }
        elif_match_key(TextView_fontFamily)
        {
//            fontFamily = a.getString(attr);
//            fontFamilyExplicit = true;
        }
        elif_match_key(TextView_password)
        {
            //password = a.getBoolean(attr, password);
        }
        elif_match_key(TextView_lineSpacingExtra)
        {
//            mSpacingAdd = a.getDimensionPixelSize(attr, (int) mSpacingAdd);
        }
        elif_match_key(TextView_lineSpacingMultiplier)
        {
            //mSpacingMult = a.getFloat(attr, mSpacingMult);
        }
        elif_match_key(TextView_inputType)
        {
            //inputType = a.getInt(attr, EditorInfo.TYPE_NULL);
        }
        elif_match_key(TextView_allowUndo)
        {
//            createEditorIfNeeded();
//            mEditor.mAllowUndo = a.getBoolean(attr, true);
        }
        elif_match_key(TextView_imeOptions)
        {
//            createEditorIfNeeded();
//            mEditor.createInputContentTypeIfNeeded();
//            mEditor.mInputContentType.imeOptions = a.getInt(attr,
//                                                            mEditor.mInputContentType.imeOptions);
        }
        elif_match_key(TextView_imeActionLabel)
        {
//            createEditorIfNeeded();
//            mEditor.createInputContentTypeIfNeeded();
//            mEditor.mInputContentType.imeActionLabel = a.getText(attr);
        }
        elif_match_key(TextView_imeActionId)
        {
//            createEditorIfNeeded();
//            mEditor.createInputContentTypeIfNeeded();
//            mEditor.mInputContentType.imeActionId = a.getInt(attr,
//                                                             mEditor.mInputContentType.imeActionId);
        }
        elif_match_key(TextView_privateImeOptions)
        {
            //setPrivateImeOptions(a.getString(attr));
        }
        elif_match_key(TextView_editorExtras)
        {
//            try {
//                setInputExtras(a.getResourceId(attr, 0));
//            } catch (XmlPullParserException e) {
//                Log.w(LOG_TAG, "Failure reading input extras", e);
//            } catch (IOException e) {
//                Log.w(LOG_TAG, "Failure reading input extras", e);
//            }
        }
        elif_match_key(TextView_textCursorDrawable)
        {
            //mCursorDrawableRes = a.getResourceId(attr, 0);
        }
        elif_match_key(TextView_textSelectHandleLeft)
        {
            //mTextSelectHandleLeftRes = a.getResourceId(attr, 0);
        }
        elif_match_key(TextView_textSelectHandleRight)
        {
            //mTextSelectHandleRightRes = a.getResourceId(attr, 0);
        }
        elif_match_key(TextView_textSelectHandle)
        {
            //mTextSelectHandleRes = a.getResourceId(attr, 0);
        }
        elif_match_key(TextView_textEditSuggestionItemLayout)
        {
//            mTextEditSuggestionItemLayout = a.getResourceId(attr, 0);
        }
        elif_match_key(TextView_textEditSuggestionContainerLayout)
        {
//            mTextEditSuggestionContainerLayout = a.getResourceId(attr, 0);
        }
        elif_match_key(TextView_textEditSuggestionHighlightStyle)
        {
            //mTextEditSuggestionHighlightStyle = a.getResourceId(attr, 0);
        }
        elif_match_key(TextView_textIsSelectable)
        {
            //setTextIsSelectable(a.getBoolean(attr, false));
        }
        elif_match_key(TextView_textAllCaps)
        {
            //allCaps = a.getBoolean(attr, false);
        }
        elif_match_key(TextView_elegantTextHeight)
        {
//            elegant = a.getBoolean(attr, false);
        }
        elif_match_key(TextView_letterSpacing)
        {
            //letterSpacing = a.getFloat(attr, 0);
        }
        elif_match_key(TextView_fontFeatureSettings)
        {
            //fontFeatureSettings = a.getString(attr);
        }
        elif_match_key(TextView_breakStrategy)
        {
            //mBreakStrategy = a.getInt(attr, Layout.BREAK_STRATEGY_SIMPLE);
        }
        elif_match_key(TextView_hyphenationFrequency)
        {
            //mHyphenationFrequency = a.getInt(attr, Layout.HYPHENATION_FREQUENCY_NONE);
        }
    }
}

- (void)onMeasure:(int)widthMeasureSpec heightSpec:(int)heightMeasureSpec
{
    int widthMode  = [MeasureSpec mode:widthMeasureSpec];
    int heightMode = [MeasureSpec mode:heightMeasureSpec];
    int widthSize  = [MeasureSpec size:widthMeasureSpec];
    int heightSize = [MeasureSpec size:heightMeasureSpec];
    
    int width;
    int height;
    
    CGRect rect;
    
    if (MeasureSpec_EXACTLY == widthMode)
    {
        width = widthSize;
    }
    else
    {
        if(1 == self.numberOfLines)
        {
            rect = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:0 attributes:@{NSFontAttributeName:self.font} context:nil];
            
            width = ceil(rect.size.width) + self.paddingLeft + self.paddingRight;
            if (MeasureSpec_AT_MOST == widthMode)
            {
                width = MIN(widthSize, width);
            }
        }
        else
        {
            rect = [self.text boundingRectWithSize:CGSizeMake(widthSize, MAXFLOAT) options:0 attributes:@{NSFontAttributeName:self.font} context:nil];
            width = ceil(rect.size.width) + self.paddingLeft + self.paddingRight;
            if (MeasureSpec_AT_MOST == widthMode)
            {
                width = MIN(widthSize, width);
            }
        }
    }
    
    int want = width - self.paddingLeft - self.paddingRight;
    int unpaddedWidth = want;

    int hintWant = want;
    int hintWidth = hintWant;
    
    if (MeasureSpec_EXACTLY == heightMode)
    {
        height = heightSize;
    }
    else
    {
        rect = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:0 attributes:@{NSFontAttributeName:self.font} context:nil];
        height = rect.size.height;
        
        if (MeasureSpec_AT_MOST == heightMode)
        {
            height = MIN(height, heightSize);
        }
    }
    
    [self setMeasuredDimension:width measuredHeight:height];
}

@end
