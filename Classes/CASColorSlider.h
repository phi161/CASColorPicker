//
//  CASColorSlider.h
//  CASColorPickerDemo
//
//  Created by phi on 2/5/14.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, CASColorComponentType)
{
    CASColorComponentTypeRed,
    CASColorComponentTypeGreen,
    CASColorComponentTypeBlue,
    CASColorComponentTypeHue,
    CASColorComponentTypeSaturation,
    CASColorComponentTypeBrightness,
    CASColorComponentTypeAlpha
};

/**
 A view that represents a unique color component like green, saturation or alpha.
 Knows how to update its labels and background color by observing the 'color' property of the picker.
 */
@interface CASColorSlider : UIControl

/**
 The component type that this slider represents, like red, alpha or saturation
 */
@property (nonatomic, assign) CASColorComponentType colorComponentType;

/**
 The value of the control is the value of the slider
 */
@property (nonatomic, assign) CGFloat value;

/**
 The value in a string format, according to the component type.
 For example, alpha is from 0 to 100, red is from 0 to 255 and hue is from 0 to 359 degrees
 */
@property (nonatomic, copy, readonly) NSString *stringValue;

@end
