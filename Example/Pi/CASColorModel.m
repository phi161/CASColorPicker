//
//  CASColorModel.m
//  PIVisualizer
//
//  Created by Patrik Nyblad on 19/02/14.
//  Copyright (c) 2014 Carmine Studios. All rights reserved.
//

#import "CASColorModel.h"

@implementation CASColorModel

+(id)colorModel
{
    return [[CASColorModel alloc] init];
}

-(NSArray *)colorModelAsArray
{
    UIColor *defaultColor = [UIColor clearColor];
    return @[_colorZero     ? : defaultColor,
             _colorOne      ? : defaultColor,
             _colorTwo      ? : defaultColor,
             _colorThree    ? : defaultColor,
             _colorFour     ? : defaultColor,
             _colorFive     ? : defaultColor,
             _colorSix      ? : defaultColor,
             _colorSeven    ? : defaultColor,
             _colorEight    ? : defaultColor,
             _colorNine     ? : defaultColor];
}

@end
