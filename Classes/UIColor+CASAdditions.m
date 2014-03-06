//
//  UIColor+CASAdditions.m
//  CASColorPickerDemo
//
//  Created by phi on 2/7/14.
//
//

#import "UIColor+CASAdditions.h"

typedef NS_ENUM (NSInteger, CASColorComponent)
{
    CASColorComponentRed,
    CASColorComponentGreen,
    CASColorComponentBlue,
    CASColorComponentHue,
    CASColorComponentSaturation,
    CASColorComponentBrightness,
    CASColorComponentAlpha
};

@implementation UIColor (CASAdditions)

#pragma mark - Helpers

-(CGFloat)extractRGBAComponent:(CASColorComponent)component
{
    CGFloat redValue;
    CGFloat greenValue;
    CGFloat blueValue;
    CGFloat alphaValue;
    
    // Since getRed:green:blue does not like colors created with [UIColor colorWithWhite:] we do the following check:
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([self CGColor]);
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(colorSpace);
    
    if (colorSpaceModel == kCGColorSpaceModelRGB)
    {
        if (![self getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue])
        {
            redValue = 0.0f;
            greenValue = 0.0f;
            blueValue = 0.0f;
            alphaValue = 1.0f;
        }
    }
    else if (colorSpaceModel == kCGColorSpaceModelMonochrome)
    {
        CGFloat whiteValue;
        
        if (![self getWhite:&whiteValue alpha:&alphaValue])
        {
            whiteValue = 0.0f;
            alphaValue = 1.0f;
        }
        
        redValue = whiteValue;
        greenValue = whiteValue;
        blueValue = whiteValue;
        
    }
    else
    {
        redValue = 0.0f;
        greenValue = 0.0f;
        blueValue = 0.0f;
        alphaValue = 1.0f;
    }

    switch (component) {
        case CASColorComponentRed:
            return redValue;
            break;
            
        case CASColorComponentGreen:
            return greenValue;
            break;
            
        case CASColorComponentBlue:
            return blueValue;
            break;
            
        case CASColorComponentAlpha:
            return alphaValue;
            break;
            
        default:
            break;
    }
    
    return 0.0f;
}


-(CGFloat)extractHSBComponent:(CASColorComponent)component
{
    CGFloat hueValue;
    CGFloat saturationValue;
    CGFloat brightnessValue;

    if (![self getHue:&hueValue saturation:&saturationValue brightness:&brightnessValue alpha:nil])
    {
        hueValue = 0.0f;
        saturationValue = 0.0f;
        brightnessValue = 0.0f;
    }
    
    switch (component) {
        case CASColorComponentHue:
            return hueValue;
            break;
            
        case CASColorComponentSaturation:
            return saturationValue;
            break;
            
        case CASColorComponentBrightness:
            return brightnessValue;
            break;
            
        default:
            break;
    }
    
    return 0.0f;
}


#pragma mark - RGB

-(CGFloat)red
{
    return [self extractRGBAComponent:CASColorComponentRed];
}


-(CGFloat)green
{
    return [self extractRGBAComponent:CASColorComponentGreen];
}


-(CGFloat)blue
{
    return [self extractRGBAComponent:CASColorComponentBlue];
}


#pragma mark - HSB

-(CGFloat)hue
{
    return [self extractHSBComponent:CASColorComponentHue];
}


-(CGFloat)saturation
{
    return [self extractHSBComponent:CASColorComponentSaturation];
}


-(CGFloat)brightness
{
    return [self extractHSBComponent:CASColorComponentBrightness];
}


#pragma mark - Alpha

-(CGFloat)alpha
{
    return [self extractRGBAComponent:CASColorComponentAlpha];
}


@end
