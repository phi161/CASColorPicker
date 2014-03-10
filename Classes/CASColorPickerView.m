//
//  CASColorPickerView.m
//  CASColorPickerDemo
//
//  Created by phi on 11/10/13.
//
//

#import "CASColorPickerView.h"
#import "CASColorSlider.h"
#import "UIColor+CASAdditions.h"
@import QuartzCore;

#define kColorProperty @"color"

@interface CASColorPickerView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *pickerScrollView;
@property (nonatomic, assign) NSUInteger numberOfPanels;
@property (nonatomic, assign) CGFloat scrollOffset;
@property (nonatomic, assign) CGFloat ratio;


@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIScrollView *colorPanelScrollView;

@property (nonatomic, strong) CASColorSlider *redSlider;
@property (nonatomic, strong) CASColorSlider *greenSlider;
@property (nonatomic, strong) CASColorSlider *blueSlider;

@property (nonatomic, strong) CASColorSlider *hueSlider;
@property (nonatomic, strong) CASColorSlider *saturationSlider;
@property (nonatomic, strong) CASColorSlider *brightnessSlider;


@property (nonatomic, strong) CASColorSlider *alphaSlider;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *okButton;

@property (nonatomic, assign) NSInteger currentPanelIndex;

@property (nonatomic, copy) ColorPickerCompletionBlock completionBlock;

-(instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color;
-(IBAction)closeButtonTapped:(id)sender;
-(IBAction)sliderValueChanged:(id)sender;
-(void)setup;
-(void)updateSelectedColorView;
-(void)handleSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer;

@end


@implementation CASColorPickerView

#pragma mark - Setup

-(void)dealloc
{
    [self removeObserver:self.redSlider forKeyPath:kColorProperty context:NULL];
    [self removeObserver:self.greenSlider forKeyPath:kColorProperty context:NULL];
    [self removeObserver:self.blueSlider forKeyPath:kColorProperty context:NULL];

    [self removeObserver:self.hueSlider forKeyPath:kColorProperty context:NULL];
    [self removeObserver:self.saturationSlider forKeyPath:kColorProperty context:NULL];
    [self removeObserver:self.brightnessSlider forKeyPath:kColorProperty context:NULL];

    [self removeObserver:self.alphaSlider forKeyPath:kColorProperty context:NULL];
}


-(id)initWithFrame:(CGRect)frame
{
    return [[CASColorPickerView alloc] initWithFrame:frame color:[UIColor lightGrayColor]];
}


-(instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _color = color;
        [self setup];
    }
    
    return self;
}


+(instancetype)colorPickerViewWithColor:(UIColor *)color
{
    return [[CASColorPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 400) color:color];
}


-(void)setup
{
    CGFloat currentY = 0.0f;
    UIColor *separatorColor = [UIColor colorWithRed:0.74f green:0.7f blue:0.7f alpha:1.0f];
    
    self.currentPanelIndex = 0;
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
   
    // Status Label
    CGFloat selectedColorHeight = 50.0f;
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake(0, currentY, CGRectGetWidth(self.bounds), selectedColorHeight), 5, 5)];
    self.statusLabel.layer.borderColor = separatorColor.CGColor;
    self.statusLabel.layer.borderWidth = 0.5f;
    self.statusLabel.layer.cornerRadius = self.layer.cornerRadius;
    [self.statusLabel setBackgroundColor:self.color];
    [self.statusLabel setTextAlignment:NSTextAlignmentCenter];
    self.statusLabel.userInteractionEnabled = YES;
    [self addSubview:self.statusLabel];
    currentY += selectedColorHeight;

    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.statusLabel addGestureRecognizer:leftSwipe];

    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.statusLabel addGestureRecognizer:rightSwipe];
    
    // Horizontal Picker
    CGFloat titleWidth = 80.0f;
    CGFloat titleHeight = 50.0f;
    self.numberOfPanels = 3;
    self.scrollOffset = (CGRectGetWidth(self.bounds)-titleWidth)/2;

    self.pickerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, currentY, CGRectGetWidth(self.bounds), titleHeight)];
    self.pickerScrollView.delegate = self;
    self.pickerScrollView.contentSize = CGSizeMake(self.numberOfPanels*titleWidth, titleHeight);
    self.pickerScrollView.contentInset = UIEdgeInsetsMake(0, self.scrollOffset, 0, self.scrollOffset);
    self.pickerScrollView.contentOffset = CGPointMake(-self.scrollOffset, 0);
    self.pickerScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.pickerScrollView];
    currentY += CGRectGetHeight(self.pickerScrollView.frame);

    // Add a view on top of the picker for fading the inactive options in the scrollView
    UIView *transparentView = [[UIView alloc] initWithFrame:self.pickerScrollView.frame];
    transparentView.userInteractionEnabled = NO;
    [self insertSubview:transparentView aboveSubview:self.pickerScrollView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = transparentView.bounds;
    gradientLayer.masksToBounds = YES;
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    gradientLayer.colors = @[
                             (id)[[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor],
                             (id)[[UIColor colorWithWhite:1.0f alpha:0.9f] CGColor],
                             (id)[[UIColor colorWithWhite:1.0f alpha:0.0f] CGColor],
                             (id)[[UIColor colorWithWhite:1.0f alpha:0.9f] CGColor],
                             (id)[[UIColor colorWithWhite:1.0f alpha:1.0f] CGColor]
                             ];
    [transparentView.layer insertSublayer:gradientLayer atIndex:0];

    UIFont *titleFont = [UIFont systemFontOfSize:16.0f];
    UIColor *titleColor = [UIColor colorWithWhite:0.1f alpha:1.0f];
    
    UILabel *rgbTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0*titleWidth, 0, titleWidth, titleHeight)];
    rgbTitleLabel.font = titleFont;
    rgbTitleLabel.textColor = titleColor;
    rgbTitleLabel.text = @"RGB";
    rgbTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.pickerScrollView addSubview:rgbTitleLabel];
    
    UILabel *hsbTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(1*titleWidth, 0, titleWidth, titleHeight)];
    hsbTitleLabel.font = titleFont;
    hsbTitleLabel.textColor = titleColor;
    hsbTitleLabel.text = @"HSB";
    hsbTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.pickerScrollView addSubview:hsbTitleLabel];
    
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(2*titleWidth, 0, titleWidth, titleHeight)];
    titleLabel1.font = titleFont;
    titleLabel1.textColor = titleColor;
    titleLabel1.text = @"HEX";
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    [self.pickerScrollView addSubview:titleLabel1];
    
    // Scrollview
    self.colorPanelScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, currentY, CGRectGetWidth(self.bounds), 180)];
    self.colorPanelScrollView.contentSize = CGSizeMake(self.numberOfPanels*CGRectGetWidth(self.colorPanelScrollView.bounds), CGRectGetHeight(self.colorPanelScrollView.bounds));
    self.colorPanelScrollView.pagingEnabled = YES;
    self.colorPanelScrollView.showsHorizontalScrollIndicator = NO;
    self.colorPanelScrollView.scrollEnabled = NO;
    [self addSubview:self.colorPanelScrollView];
    currentY += CGRectGetHeight(self.colorPanelScrollView.frame) + 10;

    self.ratio = CGRectGetWidth(self.colorPanelScrollView.bounds)/titleWidth;

    // Color panels
    CGFloat colorPanelMargin = 20.0f;
    CGFloat sliderHeight = 60.0f;
    
    // RGB
    UIView *rgbView = [[UIView alloc] initWithFrame:CGRectMake(colorPanelMargin, 0, CGRectGetWidth(self.colorPanelScrollView.bounds)-2*colorPanelMargin, CGRectGetHeight(self.colorPanelScrollView.bounds))];
    rgbView.backgroundColor = [UIColor whiteColor];
    [self.colorPanelScrollView addSubview:rgbView];

    self.redSlider = [[CASColorSlider alloc] initWithFrame:CGRectOffset(CGRectInset(rgbView.bounds, 0, sliderHeight), 0, -sliderHeight)];
    self.redSlider.colorComponentType = CASColorComponentTypeRed;
    [self.redSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [rgbView addSubview:self.redSlider];
    [self addObserver:self.redSlider forKeyPath:kColorProperty options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:NULL];
    self.redSlider.value = [self.color red];
    
    self.greenSlider = [[CASColorSlider alloc] initWithFrame:CGRectOffset(CGRectInset(rgbView.bounds, 0, sliderHeight), 0, 0)];
    self.greenSlider.colorComponentType = CASColorComponentTypeGreen;
    [self.greenSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [rgbView addSubview:self.greenSlider];
    [self addObserver:self.greenSlider forKeyPath:kColorProperty options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:NULL];
    self.greenSlider.value = [self.color green];
    
    self.blueSlider = [[CASColorSlider alloc] initWithFrame:CGRectOffset(CGRectInset(rgbView.bounds, 0, sliderHeight), 0, sliderHeight)];
    self.blueSlider.colorComponentType = CASColorComponentTypeBlue;
    [self.blueSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [rgbView addSubview:self.blueSlider];
    [self addObserver:self.blueSlider forKeyPath:kColorProperty options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:NULL];
    self.blueSlider.value = [self.color blue];
    
    // HSB
    UIView *hsbView = [[UIView alloc] initWithFrame:CGRectMake(colorPanelMargin+CGRectGetWidth(self.colorPanelScrollView.bounds), 0, CGRectGetWidth(self.colorPanelScrollView.bounds)-2*colorPanelMargin, CGRectGetHeight(self.colorPanelScrollView.bounds))];
    [self.colorPanelScrollView addSubview:hsbView];
    
    self.hueSlider = [[CASColorSlider alloc] initWithFrame:CGRectOffset(CGRectInset(hsbView.bounds, 0, sliderHeight), 0, -sliderHeight)];
    self.hueSlider.colorComponentType = CASColorComponentTypeHue;
    [self.hueSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [hsbView addSubview:self.hueSlider];
    [self addObserver:self.hueSlider forKeyPath:kColorProperty options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:NULL];
    self.hueSlider.value = [self.color hue];
    
    self.saturationSlider = [[CASColorSlider alloc] initWithFrame:CGRectOffset(CGRectInset(hsbView.bounds, 0, sliderHeight), 0, 0)];
    self.saturationSlider.colorComponentType = CASColorComponentTypeSaturation;
    [self.saturationSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [hsbView addSubview:self.saturationSlider];
    [self addObserver:self.saturationSlider forKeyPath:kColorProperty options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:NULL];
    self.saturationSlider.value = [self.color saturation];
    
    self.brightnessSlider = [[CASColorSlider alloc] initWithFrame:CGRectOffset(CGRectInset(hsbView.bounds, 0, sliderHeight), 0, sliderHeight)];
    self.brightnessSlider.colorComponentType = CASColorComponentTypeBrightness;
    [self.brightnessSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [hsbView addSubview:self.brightnessSlider];
    [self addObserver:self.brightnessSlider forKeyPath:kColorProperty options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:NULL];
    self.brightnessSlider.value = [self.color brightness];
    
    // Test
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(colorPanelMargin+2*CGRectGetWidth(self.colorPanelScrollView.bounds), 0, CGRectGetWidth(self.colorPanelScrollView.bounds)-2*colorPanelMargin, CGRectGetHeight(self.colorPanelScrollView.bounds))];
    testView.backgroundColor = [UIColor purpleColor];
    [self.colorPanelScrollView addSubview:testView];

    
    // Alpha slider
    self.alphaSlider = [[CASColorSlider alloc] initWithFrame:CGRectMake(colorPanelMargin, currentY, CGRectGetWidth(self.bounds)-2*colorPanelMargin, sliderHeight)];
    self.alphaSlider.backgroundColor = [UIColor whiteColor];
    self.alphaSlider.colorComponentType = CASColorComponentTypeAlpha;
    [self.alphaSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addObserver:self.alphaSlider forKeyPath:kColorProperty options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:NULL];
    self.alphaSlider.value = [self.color alpha];
    [self addSubview:self.alphaSlider];
    currentY += CGRectGetHeight(self.alphaSlider.frame);
    
    // Cancel button
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.layer.borderWidth = 0.5f;
    self.cancelButton.layer.borderColor = separatorColor.CGColor;
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setFrame:CGRectMake(-0.5, currentY, 151, 51)];
    [self addSubview:self.cancelButton];
    
    // OK button
    self.okButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.okButton.layer.borderWidth = 0.5f;
    self.okButton.layer.borderColor = separatorColor.CGColor;
    [self.okButton setTitle:@"OK" forState:UIControlStateNormal];
    [self.okButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.okButton setFrame:CGRectMake(150, currentY, 151, 51)];
    [self addSubview:self.okButton];

    [self updateSelectedColorView];
}


#pragma mark - Actions

-(IBAction)closeButtonTapped:(id)sender
{
    if (sender == self.cancelButton)
    {
        self.completionBlock(self.color, YES);
    }
    else if (sender == self.okButton)
    {
        self.completionBlock(self.color, NO);
    }
    
    [UIView animateWithDuration:0.3
                     animations: ^{
                         self.superview.alpha = 0.0f;
                         self.alpha = 0.0f;
                         self.transform = CGAffineTransformMakeScale(0.3, 0.3);
                     }
                     completion: ^(BOOL finished) {
                         [self.superview removeFromSuperview];
                     }];
}


-(IBAction)sliderValueChanged:(id)sender
{
    if (
        sender == self.redSlider
        ||
        sender == self.greenSlider
        ||
        sender == self.blueSlider
        )
    {
        self.color = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:self.alphaSlider.value];
        
        // Update the HSB panel
        self.hueSlider.value = [self.color hue];
        self.saturationSlider.value = [self.color saturation];
        self.brightnessSlider.value = [self.color brightness];
    }
    else
    {
        self.color = [UIColor colorWithHue:self.hueSlider.value saturation:self.saturationSlider.value brightness:self.brightnessSlider.value alpha:self.alphaSlider.value];
        
        // Update the RGB panel
        self.redSlider.value = [self.color red];
        self.greenSlider.value = [self.color green];
        self.blueSlider.value = [self.color blue];
    }

    [self updateSelectedColorView];
}


-(void)handleSwipe:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    CGFloat width = CGRectGetWidth(self.colorPanelScrollView.bounds);
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        self.currentPanelIndex++;
        if (self.currentPanelIndex > 2)
        {
            self.currentPanelIndex = 2;
        }
    }
    else if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        self.currentPanelIndex--;
        if (self.currentPanelIndex < 0)
        {
            self.currentPanelIndex = 0;
        }
    }
    [self.colorPanelScrollView scrollRectToVisible:CGRectMake(self.currentPanelIndex*width, 0, width, CGRectGetHeight(self.colorPanelScrollView.bounds)) animated:YES];
}


#pragma mark - Show & Hide

-(void)showWithCompletionBlock:(ColorPickerCompletionBlock)completionBlock
{
    self.completionBlock = [completionBlock copy];
    
    UIView *pickerBackgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [pickerBackgroundView setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.95]];
    [pickerBackgroundView setUserInteractionEnabled:YES];
    [pickerBackgroundView addSubview:self];
    
    self.alpha = 0.0f;
    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.center = pickerBackgroundView.center;
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    [win addSubview:pickerBackgroundView];
    
    [UIView animateWithDuration:0.3 animations: ^{
                         self.alpha = 1.0f;
                         self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     }];
}


#pragma mark - Update GUI

-(void)updateSelectedColorView
{
    [self.statusLabel setBackgroundColor:self.color];
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.pickerScrollView)
    {
        CGFloat colorPanelOffset = self.ratio*(self.scrollOffset+self.pickerScrollView.contentOffset.x);
        [self.colorPanelScrollView setContentOffset:CGPointMake(colorPanelOffset, 0) animated:NO];
    }
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat titleWidth = 80.0f;
    if (scrollView == self.pickerScrollView)
    {
        CGFloat x = targetContentOffset->x;
        x+=self.scrollOffset;
        NSInteger index = roundf(x / titleWidth);
        x = index * titleWidth;
        targetContentOffset->x = x-self.scrollOffset;

        [self.colorPanelScrollView setContentOffset:CGPointMake(index*CGRectGetWidth(self.colorPanelScrollView.bounds), 0) animated:YES];
    }
}


@end
