//
//  ViewController.m
//  Pi
//
//  Created by phi on 3/9/14.
//  Copyright (c) 2014 Carmine Studios. All rights reserved.
//

#import "ViewController.h"
#import <CASColorPicker/CASColorPickerView.h>
#import "InfoViewController.h"
#import "CASPIView.h"
#import "UIColor+CASAdditions.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIButton *infoButton;
@property (nonatomic, strong) CASPIView *piView;
@property (nonatomic, strong) CASColorModel *colorModel;

-(IBAction)numberButtonTapped:(id)sender;
-(IBAction)infoButtonTapped:(id)sender;
-(void)setButtonTitles;
-(void)setupColors;
-(void)tintViewWithWithTag:(NSUInteger)tag animated:(BOOL)animated;

@end


@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setButtonTitles];

    [self setupColors];
    
    self.piView = [[CASPIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    self.piView.lineWidth = 1;
    self.piView.colorModel = self.colorModel;
    [self.view addSubview:self.piView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self becomeFirstResponder];

    for (int i = 1; i<=10; i++)
    {
        [self tintViewWithWithTag:i animated:YES];
    }
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self resignFirstResponder];
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        self.piView.alpha = 1.0f;
    }
    else
    {
        self.piView.alpha = 0.0f;
    }
    
}


#pragma mark - Actions

-(IBAction)numberButtonTapped:(id)sender
{
    NSUInteger tag = [sender tag] > 9? 0 : [sender tag];
    CASColorPickerView *colorPicker = [CASColorPickerView colorPickerViewWithColor:self.colorModel.colorModelAsArray[tag]];
    [colorPicker showWithCompletionBlock:^(UIColor *selectedColor, BOOL didCancel) {
        if (!didCancel)
        {
            // Update the model
            switch ([sender tag])
            {
                case 10:
                    self.colorModel.colorZero = selectedColor;
                    break;
                case 1:
                    self.colorModel.colorOne = selectedColor;
                    break;
                case 2:
                    self.colorModel.colorTwo = selectedColor;
                    break;
                case 3:
                    self.colorModel.colorThree = selectedColor;
                    break;
                case 4:
                    self.colorModel.colorFour = selectedColor;
                    break;
                case 5:
                    self.colorModel.colorFive = selectedColor;
                    break;
                case 6:
                    self.colorModel.colorSix = selectedColor;
                    break;
                case 7:
                    self.colorModel.colorSeven = selectedColor;
                    break;
                case 8:
                    self.colorModel.colorEight = selectedColor;
                    break;
                case 9:
                    self.colorModel.colorNine = selectedColor;
                    break;
                    
                default:
                    break;
            }

            [self tintViewWithWithTag:[sender tag] animated:YES];
            
            [_piView render];
		}
    }];
}


-(IBAction)infoButtonTapped:(id)sender
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, CGRectGetWidth(self.view.bounds), 0.0);
    CGContextScaleCTM(context, -1.0, 1.0);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    InfoViewController *infoViewController = [[InfoViewController alloc] initWithNibName:nil bundle:nil];
    infoViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    infoViewController.view.backgroundColor = [UIColor colorWithPatternImage:image];
    [self presentViewController:infoViewController animated:YES completion:nil];
}

#pragma mark - Setup

-(void)setButtonTitles
{
    [(UIButton *)[self.view viewWithTag:10] setTitle:NSLocalizedString(@"zero", @"0") forState:UIControlStateNormal];
    [(UIButton *)[self.view viewWithTag:1] setTitle:NSLocalizedString(@"one", @"1") forState:UIControlStateNormal];
    [(UIButton *)[self.view viewWithTag:2] setTitle:NSLocalizedString(@"two", @"2") forState:UIControlStateNormal];
    [(UIButton *)[self.view viewWithTag:3] setTitle:NSLocalizedString(@"three", @"3") forState:UIControlStateNormal];
    [(UIButton *)[self.view viewWithTag:4] setTitle:NSLocalizedString(@"four", @"4") forState:UIControlStateNormal];
    [(UIButton *)[self.view viewWithTag:5] setTitle:NSLocalizedString(@"five", @"5") forState:UIControlStateNormal];
    [(UIButton *)[self.view viewWithTag:6] setTitle:NSLocalizedString(@"six", @"6") forState:UIControlStateNormal];
    [(UIButton *)[self.view viewWithTag:7] setTitle:NSLocalizedString(@"seven", @"7") forState:UIControlStateNormal];
    [(UIButton *)[self.view viewWithTag:8] setTitle:NSLocalizedString(@"eight", @"8") forState:UIControlStateNormal];
    [(UIButton *)[self.view viewWithTag:9] setTitle:NSLocalizedString(@"nine", @"9") forState:UIControlStateNormal];
}


-(void)setupColors
{
    self.colorModel = [CASColorModel colorModel];
    
    self.colorModel.colorZero = [UIColor redColor];
    self.colorModel.colorOne = [UIColor yellowColor];
    self.colorModel.colorTwo = [UIColor orangeColor];
    self.colorModel.colorThree = [UIColor greenColor];
    self.colorModel.colorFour = [UIColor blueColor];
    self.colorModel.colorFive = [UIColor purpleColor];
    self.colorModel.colorSix = [UIColor brownColor];
    self.colorModel.colorSeven = [UIColor lightGrayColor];
    self.colorModel.colorEight = [UIColor grayColor];
    self.colorModel.colorNine = [UIColor blackColor];
}


-(void)tintViewWithWithTag:(NSUInteger)tag animated:(BOOL)animated
{
    NSUInteger normalizedTag = tag > 9? 0 : tag;
    UIButton *button = (UIButton *)[self.view viewWithTag:tag];
    UIColor *color = self.colorModel.colorModelAsArray[normalizedTag];

    // Animate
    [button setUserInteractionEnabled:NO];
    [UIView animateWithDuration:animated? 2.0f: 0.0f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [button setTintColor:color];
        [self.infoButton setTintColor:color];
    } completion:^(BOOL finished) {
        [button setUserInteractionEnabled:YES];
    }];
}


#pragma mark - Shake

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventSubtypeMotionShake)
    {
        self.colorModel.colorZero = [UIColor randomColor];
        self.colorModel.colorOne = [UIColor randomColor];
        self.colorModel.colorTwo = [UIColor randomColor];
        self.colorModel.colorThree = [UIColor randomColor];
        self.colorModel.colorFour = [UIColor randomColor];
        self.colorModel.colorFive = [UIColor randomColor];
        self.colorModel.colorSix = [UIColor randomColor];
        self.colorModel.colorSeven = [UIColor randomColor];
        self.colorModel.colorEight = [UIColor randomColor];
        self.colorModel.colorNine = [UIColor randomColor];

        for (int i = 1; i<=10; i++)
        {
            [self tintViewWithWithTag:i animated:YES];
        }
        
        [self.piView render];
    }
}


@end
