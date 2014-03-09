//
//  CASPIView.h
//  PIVisualizer
//
//  Created by Patrik Nyblad on 19/02/14.
//  Copyright (c) 2014 Carmine Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CASColorModel.h"

@interface CASPIView : UIView

/**
 Set this to generate an image representing all colors from the color model based on the number PI. 
 The property digitPixelWidth will be used to determine how many pixels one digit is represented by.
 */
@property (nonatomic, strong) CASColorModel *colorModel;

/**
 Setting this will generate a new image from the color model but with the new pixel width. 
 This value defaults to 1.
 */
@property (nonatomic, assign) u_int lineWidth;


/**
 The number of digits of PI to render.
 If set to 0, we use view width / digitPixelWidth.
 This value defaults to 0.
 */
@property (nonatomic, assign) NSUInteger numberOfDigitsToVisalize;


/**
 Initialize the view and pass a color model to draw directly.
 */
-(id)initWithColorModel:(CASColorModel *)colorModel;


/**
 Get the Visilization as a UIImage
 */
-(UIImage *)visualizationAsImage;

/**
 Renders the image and updates the View. This method is called automatically when setting a new colormodel or changing the lineWidth.
 */
-(void)render;

@end
