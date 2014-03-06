//
//  CASColorPickerView.h
//  CASColorPickerDemo
//
//  Created by phi on 11/10/13.
//
//

#import <UIKit/UIKit.h>

typedef void (^ColorPickerCompletionBlock) (UIColor *selectedColor, BOOL didCancel);

@interface CASColorPickerView : UIView

+(instancetype)colorPickerViewWithColor:(UIColor *)color;

-(void)showWithCompletionBlock:(ColorPickerCompletionBlock)completionBlock;

// TODO: Implement this by hiding the alpha slider
// @property (nonatomic, assign) BOOL canEditALpha;

// @property (nonatomic, assign) BOOL canEditRGB;

// @property (nonatomic, assign) BOOL canEditHSB;

// @property (nonatomic, assign) BOOL canEditImageCanvas;

@end
