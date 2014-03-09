//
//  UIColor+CASAdditions.m
//  Pi
//
//  Created by phi on 3/9/14.
//  Copyright (c) 2014 Carmine Studios. All rights reserved.
//

#import "UIColor+CASAdditions.h"

@implementation UIColor (CASAdditions)

+(UIColor *)randomColor
{
    return [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];
}

@end
