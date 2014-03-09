//
//  CASColorModel.m
//  PIVisualizer
//
//  Created by Patrik Nyblad on 19/02/14.
//  Copyright (c) 2014 Carmine Studios. All rights reserved.
//

#import "CASColorModel.h"
#import <CASColorPicker/UIColor+CASAdditions.h>

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


-(NSString *)stringRepresentation
{
    NSString *string = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@",
                        [NSString stringWithFormat:@"0: [%lu %lu %lu]", (long)roundf(self.colorZero.red * 255), (long)roundf(self.colorZero.green * 255), (long)roundf(self.colorZero.blue * 255)],
                        [NSString stringWithFormat:@"1: [%lu %lu %lu]", (long)roundf(self.colorOne.red * 255), (long)roundf(self.colorOne.green * 255), (long)roundf(self.colorOne.blue * 255)],
                        [NSString stringWithFormat:@"2: [%lu %lu %lu]", (long)roundf(self.colorTwo.red * 255), (long)roundf(self.colorTwo.green * 255), (long)roundf(self.colorTwo.blue * 255)],
                        [NSString stringWithFormat:@"3: [%lu %lu %lu]", (long)roundf(self.colorThree.red * 255), (long)roundf(self.colorThree.green * 255), (long)roundf(self.colorThree.blue * 255)],
                        [NSString stringWithFormat:@"4: [%lu %lu %lu]", (long)roundf(self.colorFour.red * 255), (long)roundf(self.colorFour.green * 255), (long)roundf(self.colorFour.blue * 255)],
                        [NSString stringWithFormat:@"5: [%lu %lu %lu]", (long)roundf(self.colorFive.red * 255), (long)roundf(self.colorFive.green * 255), (long)roundf(self.colorFive.blue * 255)],
                        [NSString stringWithFormat:@"6: [%lu %lu %lu]", (long)roundf(self.colorSix.red * 255), (long)roundf(self.colorSix.green * 255), (long)roundf(self.colorSix.blue * 255)],
                        [NSString stringWithFormat:@"7: [%lu %lu %lu]", (long)roundf(self.colorSeven.red * 255), (long)roundf(self.colorSeven.green * 255), (long)roundf(self.colorSeven.blue * 255)],
                        [NSString stringWithFormat:@"8: [%lu %lu %lu]", (long)roundf(self.colorEight.red * 255), (long)roundf(self.colorEight.green * 255), (long)roundf(self.colorEight.blue * 255)],
                        [NSString stringWithFormat:@"9: [%lu %lu %lu]", (long)roundf(self.colorNine.red * 255), (long)roundf(self.colorNine.green * 255), (long)roundf(self.colorNine.blue * 255)]
                        ];
    
    return string;
}


@end
