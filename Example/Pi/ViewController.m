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
@import MessageUI;
@import AudioToolbox;

@interface ViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *infoButton;
@property (nonatomic, weak) IBOutlet UIButton *mailButton;
@property (nonatomic, strong) CASPIView *piView;
@property (nonatomic, strong) CASColorModel *colorModel;
@property (nonatomic, strong) UIScrollView *piScrollView;
@property (nonatomic, assign) SystemSoundID soundID;

-(IBAction)numberButtonTapped:(id)sender;
-(IBAction)infoButtonTapped:(id)sender;
-(IBAction)mailButtonTapped:(id)sender;
-(void)setButtonTitles;
-(void)setupColors;
-(void)setupPiView;
-(void)tintViewWithWithTag:(NSUInteger)tag animated:(BOOL)animated;
-(void)playRandomSound;

@end


@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setButtonTitles];
    
    [self setupColors];
    
    [self setupPiView];
    
    self.mailButton.alpha = [MFMailComposeViewController canSendMail]? 1.0f : 0.0f;
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
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        [UIView animateWithDuration:duration animations:^{
            self.piScrollView.alpha = 1.0f;
            for (int i = 1; i<=10; i++)
            {
                [self.view viewWithTag:i].alpha = 0.0f;
            }
        } completion:^(BOOL finished) {
            //
        }];
    }
    else if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
    {
        [UIView animateWithDuration:duration animations:^{
            self.piScrollView.alpha = 0.0f;
            for (int i = 1; i<=10; i++)
            {
                [self.view viewWithTag:i].alpha = 1.0f;
            }
        } completion:^(BOOL finished) {
            //
        }];
    }
}


#pragma mark - Actions

-(IBAction)numberButtonTapped:(id)sender
{
    [self playRandomSound];

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


-(IBAction)mailButtonTapped:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate = self;
        [mailComposeViewController setSubject:@"π RGB"];
        [mailComposeViewController setMessageBody:[self.colorModel stringRepresentation] isHTML:NO];
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
    }
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Setup

-(void)setButtonTitles
{
    // Layout the buttons evenly based on the screen height
    CGFloat buttonHeight = (CGRectGetHeight(self.view.bounds) - 40) / 10;
    
    ((UIButton *)[self.view viewWithTag:10]).frame = CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), buttonHeight);
    
    CGFloat currentY = 20 + buttonHeight;
    for (int i = 1; i < 10; i++)
    {
        ((UIButton *)[self.view viewWithTag:i]).frame = CGRectMake(0, currentY, CGRectGetWidth(self.view.bounds), buttonHeight);
        currentY+=buttonHeight;
    }
    
    self.mailButton.frame = CGRectMake(10, currentY-10, 20, 20);
    self.infoButton.frame = CGRectMake(CGRectGetWidth(self.view.bounds)-30, currentY-10, 20, 20);
    
    // Set the localized text
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


-(void)setupPiView
{
    // The pi view
    CGFloat margin = 40.0f;
    self.piView = [[CASPIView alloc] initWithFrame:CGRectMake(0, margin, 3000, CGRectGetWidth(self.view.bounds)-2*margin)];
    self.piView.lineWidth = 1;
    self.piView.colorModel = self.colorModel;
    
    // The scroll view that hosts the pi view
    self.piScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds))];
    self.piScrollView.alpha = 0.0f;
    self.piScrollView.contentSize = self.piView.bounds.size;
    [self.piScrollView addSubview:self.piView];
    
    // The pi letter view
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(-200, 0, 200, CGRectGetWidth(self.view.bounds))];
    headerView.image = [UIImage imageNamed:@"pi.png"];
    headerView.contentMode = UIViewContentModeCenter;
    [self.piScrollView addSubview:headerView];
    
    // The infinity
    UIImageView *footerView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.piView.bounds), 0, 200, CGRectGetWidth(self.view.bounds))];
    footerView.image = [UIImage imageNamed:@"infinity.png"];
    footerView.contentMode = UIViewContentModeCenter;
    [self.piScrollView addSubview:footerView];
    
    [self.view addSubview:self.piScrollView];
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


#pragma mark - Audio

-(void)playRandomSound
{
    NSString *randomFile = [NSString stringWithFormat:@"%i", arc4random_uniform(15)];
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:randomFile withExtension:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_soundID);
    AudioServicesPlaySystemSound (_soundID);
}


-(void)dealloc
{
    AudioServicesDisposeSystemSoundID(_soundID);
}


@end
