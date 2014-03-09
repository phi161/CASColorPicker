//
//  CASColorModel.h
//  PIVisualizer
//
//  Created by Patrik Nyblad on 19/02/14.
//  Copyright (c) 2014 Carmine Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CASColorModel : NSObject

@property (nonatomic, strong) UIColor *colorZero;
@property (nonatomic, strong) UIColor *colorOne;
@property (nonatomic, strong) UIColor *colorTwo;
@property (nonatomic, strong) UIColor *colorThree;
@property (nonatomic, strong) UIColor *colorFour;
@property (nonatomic, strong) UIColor *colorFive;
@property (nonatomic, strong) UIColor *colorSix;
@property (nonatomic, strong) UIColor *colorSeven;
@property (nonatomic, strong) UIColor *colorEight;
@property (nonatomic, strong) UIColor *colorNine;


+(id)colorModel;

-(NSArray *)colorModelAsArray;

-(NSString *)stringRepresentation;

@end
