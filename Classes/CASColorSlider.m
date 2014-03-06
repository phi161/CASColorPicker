//
//  CASColorSlider.m
//  CASColorPickerDemo
//
//  Created by phi on 2/5/14.
//
//

#import "CASColorSlider.h"
#import "UIColor+CASAdditions.h"

@interface CASColorSlider ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, copy) NSString *stringValue;

-(void)setup;
-(IBAction)sliderValueDidChange:(id)sender;
-(void)updateGradientForColor:(UIColor *)color;

@end


@implementation CASColorSlider

#pragma mark - Setup

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}


-(void)setup
{
    CGFloat labelHeight = 20.0f;
    CGFloat halfWidth = CGRectGetWidth(self.bounds) / 2.0f;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, halfWidth, labelHeight)];
    self.valueLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.nameLabel];
    
    self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(halfWidth, 0, halfWidth, labelHeight)];
    self.valueLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.valueLabel];
    
    self.slider = [[UISlider alloc] initWithFrame:CGRectOffset(CGRectInset(self.bounds, 0, labelHeight / 2), 0, labelHeight / 2)];
    UIImage *dystopia = [[UIImage alloc] init];
    [self.slider setMinimumTrackImage:dystopia forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:dystopia forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.slider];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectInset(self.slider.bounds, 4.0f, 8.0f);
    self.gradientLayer.cornerRadius = 8.0f;
    self.gradientLayer.masksToBounds = YES;
    self.gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    self.gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    
    [self.slider.layer insertSublayer:self.gradientLayer atIndex:0];
}


#pragma mark - Setters & Getters

-(void)setColorComponentType:(CASColorComponentType)colorComponent
{
    if (_colorComponentType != colorComponent)
    {
        _colorComponentType = colorComponent;
    }
    
    switch (colorComponent)
    {
        case CASColorComponentTypeRed:
            self.nameLabel.text = @"Red";
            break;
            
        case CASColorComponentTypeGreen:
            self.nameLabel.text = @"Green";
            break;
            
        case CASColorComponentTypeBlue:
            self.nameLabel.text = @"Blue";
            break;
            
        case CASColorComponentTypeHue:
            self.nameLabel.text = @"Hue";
            break;
            
        case CASColorComponentTypeSaturation:
            self.nameLabel.text = @"Saturation";
            break;
            
        case CASColorComponentTypeBrightness:
            self.nameLabel.text = @"Brightness";
            break;
            
        case CASColorComponentTypeAlpha:
            self.nameLabel.text = @"Alpha";
            break;
            
        default:
            self.nameLabel.text = @"unset&upset";
            break;
    }
}


// Setting the value of the control updates the internal GUI as well
-(void)setValue:(CGFloat)value
{
    if (_value != value)
    {
        _value = value;
        
        self.slider.value = value;
        self.valueLabel.text = self.stringValue;
    }
}


-(NSString *)stringValue
{
    NSString *humanValueString = @"";
    
    switch (self.colorComponentType)
    {
        case CASColorComponentTypeRed:
        case CASColorComponentTypeGreen:
        case CASColorComponentTypeBlue:
            humanValueString = [NSString stringWithFormat:@"%lu", (long)roundf(self.slider.value * 255)];
            break;
            
        case CASColorComponentTypeHue:
            humanValueString = [NSString stringWithFormat:@"%lu", (long)roundf(self.slider.value * 359)];
            break;
            
        case CASColorComponentTypeAlpha:
        case CASColorComponentTypeSaturation:
        case CASColorComponentTypeBrightness:
            humanValueString = [NSString stringWithFormat:@"%lu", (long)roundf(self.slider.value * 100)];
            break;
            
        default:
            humanValueString = [NSString stringWithFormat:@"%f", self.slider.value];
            break;
    }
    
    return humanValueString;
}


#pragma mark - Actions

-(IBAction)sliderValueDidChange:(id)sender
{
    self.value = self.slider.value;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIColor *color = change[NSKeyValueChangeNewKey];
    [self updateGradientForColor:color];
}


-(void)updateGradientForColor:(UIColor *)color
{
    CGFloat redValue = [color red];
    CGFloat greenValue = [color green];
    CGFloat blueValue = [color blue];
    
    CGFloat hueValue = [color hue];
    CGFloat saturationValue = [color saturation];
    CGFloat brightnessValue = [color brightness];
    
    switch (self.colorComponentType)
    {
        case CASColorComponentTypeRed:
        {
            self.gradientLayer.colors = @[
                                          (id)[[UIColor colorWithRed:0.0f green:greenValue blue:blueValue alpha:1.0f] CGColor],
                                          (id)[[UIColor colorWithRed:1.0f green:greenValue blue:blueValue alpha:1.0f] CGColor]
                                          ];
        }
            break;
            
        case CASColorComponentTypeGreen:
        {
            self.gradientLayer.colors = @[
                                          (id)[[UIColor colorWithRed:redValue green:0.0f blue:blueValue alpha:1.0f] CGColor],
                                          (id)[[UIColor colorWithRed:redValue green:1.0f blue:blueValue alpha:1.0f] CGColor]
                                          ];
        }
            break;
            
        case CASColorComponentTypeBlue:
        {
            self.gradientLayer.colors = @[
                                          (id)[[UIColor colorWithRed:redValue green:greenValue blue:0.0f alpha:1.0f] CGColor],
                                          (id)[[UIColor colorWithRed:redValue green:greenValue blue:1.0f alpha:1.0f] CGColor]
                                          ];
        }
            break;
            
        case CASColorComponentTypeHue:
        {
            self.gradientLayer.colors = @[
                                          (id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f] CGColor],
                                          (id)[[UIColor colorWithRed:1.0f green:1.0f blue:0.0f alpha:1.0f] CGColor],
                                          (id)[[UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1.0f] CGColor],
                                          (id)[[UIColor colorWithRed:0.0f green:1.0f blue:1.0f alpha:1.0f] CGColor],
                                          (id)[[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f] CGColor],
                                          (id)[[UIColor colorWithRed:1.0f green:0.0f blue:1.0f alpha:1.0f] CGColor],
                                          (id)[[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f] CGColor],
                                          ];
        }
            break;
            
        case CASColorComponentTypeSaturation:
        {
            self.gradientLayer.colors = @[
                                          (id)[[UIColor colorWithHue:hueValue saturation:0.0f brightness:brightnessValue alpha:1.0f] CGColor],
                                          (id)[[UIColor colorWithHue:hueValue saturation:1.0f brightness:brightnessValue alpha:1.0f] CGColor]
                                          ];
        }
            break;
            
        case CASColorComponentTypeBrightness:
        {
            self.gradientLayer.colors = @[
                                          (id)[[UIColor colorWithHue:hueValue saturation:saturationValue brightness:0.0f alpha:1.0f] CGColor],
                                          (id)[[UIColor colorWithHue:hueValue saturation:saturationValue brightness:1.0f alpha:1.0f] CGColor]
                                          ];
        }
            break;
            
        case CASColorComponentTypeAlpha:
        {
            self.gradientLayer.colors = @[
                                          (id)[[UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:0.0f] CGColor],
                                          (id)[[UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1.0f] CGColor]
                                          ];
        }
            break;
            
        default:
            break;
    }
}


@end
