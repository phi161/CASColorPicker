//
//  UIColor+CASAdditions.m
//  CASColorPickerDemo
//
//  Created by phi on 2/7/14.
//
//

#import "UIColor+CASAdditions.h"

@implementation UIColor (CASAdditions)

#pragma mark - RGB

-(CGFloat)red
{
    CGFloat redValue;
    CGFloat greenValue;
    CGFloat blueValue;
    
    // Since getRed:green:blue does not like colors created with [UIColor colorWithWhite:] we do the following check:
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([self CGColor]);
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(colorSpace);
    
    if (colorSpaceModel == kCGColorSpaceModelRGB)
    {
        if (![self getRed:&redValue green:&greenValue blue:&blueValue alpha:nil])
        {
            redValue = 0.0;
            greenValue = 0.0;
            blueValue = 0.0;
        }
    }
    else if (colorSpaceModel == kCGColorSpaceModelMonochrome)
    {
        CGFloat whiteValue;
        
        if (![self getWhite:&whiteValue alpha:nil])
        {
            whiteValue = 0.0;
        }
        
        redValue = whiteValue;
        greenValue = whiteValue;
        blueValue = whiteValue;
    }
    else
    {
        redValue = 0.0;
        greenValue = 0.0;
        blueValue = 0.0;
    }
    
    return redValue;
}


-(CGFloat)green
{
    CGFloat redValue;
    CGFloat greenValue;
    CGFloat blueValue;
    
    // Since getRed:green:blue does not like colors created with [UIColor colorWithWhite:] we do the following check:
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([self CGColor]);
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(colorSpace);
    
    if (colorSpaceModel == kCGColorSpaceModelRGB)
    {
        if (![self getRed:&redValue green:&greenValue blue:&blueValue alpha:nil])
        {
            redValue = 0.0;
            greenValue = 0.0;
            blueValue = 0.0;
        }
    }
    else if (colorSpaceModel == kCGColorSpaceModelMonochrome)
    {
        CGFloat whiteValue;
        
        if (![self getWhite:&whiteValue alpha:nil])
        {
            whiteValue = 0.0;
        }
        
        redValue = whiteValue;
        greenValue = whiteValue;
        blueValue = whiteValue;
    }
    else
    {
        redValue = 0.0;
        greenValue = 0.0;
        blueValue = 0.0;
    }
    
    return greenValue;
}


-(CGFloat)blue
{
    CGFloat redValue;
    CGFloat greenValue;
    CGFloat blueValue;
    
    // Since getRed:green:blue does not like colors created with [UIColor colorWithWhite:] we do the following check:
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([self CGColor]);
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(colorSpace);
    
    if (colorSpaceModel == kCGColorSpaceModelRGB)
    {
        if (![self getRed:&redValue green:&greenValue blue:&blueValue alpha:nil])
        {
            redValue = 0.0;
            greenValue = 0.0;
            blueValue = 0.0;
        }
    }
    else if (colorSpaceModel == kCGColorSpaceModelMonochrome)
    {
        CGFloat whiteValue;
        
        if (![self getWhite:&whiteValue alpha:nil])
        {
            whiteValue = 0.0;
        }
        
        redValue = whiteValue;
        greenValue = whiteValue;
        blueValue = whiteValue;
    }
    else
    {
        redValue = 0.0;
        greenValue = 0.0;
        blueValue = 0.0;
    }
    
    return blueValue;
}


#pragma mark - HSB

-(CGFloat)hue
{
    CGFloat hue, saturation, brightness, alpha;
    
    if (![self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha])
    {
        hue = 0.0;
    }
    
    return hue;
}


-(CGFloat)saturation
{
    CGFloat hue, saturation, brightness, alpha;
    
    if (![self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha])
    {
        saturation = 0.0;
    }
    
    return saturation;
}


-(CGFloat)brightness
{
    CGFloat hue, saturation, brightness, alpha;
    
    if (![self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha])
    {
        brightness = 0.0;
    }

    return brightness;
}


#pragma mark - Alpha

-(CGFloat)alpha
{
    CGFloat alphaValue;
    
    // Since getRed:green:blue does not like colors created with [UIColor colorWithWhite:] we do the following check:
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([self CGColor]);
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(colorSpace);
    
    if (colorSpaceModel == kCGColorSpaceModelRGB)
    {
        if (![self getRed:nil green:nil blue:nil alpha:&alphaValue])
        {
            alphaValue = 1.0f;
        }
    }
    else if (colorSpaceModel == kCGColorSpaceModelMonochrome)
    {
        if (![self getWhite:nil alpha:&alphaValue])
        {
            alphaValue = 1.0f;
        }
    }
    else
    {
        alphaValue = 1.0f;
    }
    
    return alphaValue;
}


@end
