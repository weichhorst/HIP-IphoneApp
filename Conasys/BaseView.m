//
//  BaseView.m
//  Conasys
//
//  Created by user on 5/8/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 220;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 500;
CGFloat animatedDistance;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	
	[self upTheView:textField];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
	[self downTheView:textField];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}
#pragma mark - textView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    [self upTheView:textView];
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [self downTheView:textView];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
    
}
#pragma mark - Common Methods

- (void)upTheView:(UIView *)editingView{
    

    CGRect textFieldRect =
	[self.window convertRect:editingView.bounds fromView:editingView];
	CGRect viewRect =
	[self.window convertRect:self.bounds fromView:self];
	
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
	CGFloat numerator =
	midline - viewRect.origin.y
	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
	CGFloat denominator =
	(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
	* viewRect.size.height;
	CGFloat heightFraction = numerator / denominator;
	if (heightFraction < 0.0)
	{
		heightFraction = 0.0;
		
	}
	else if (heightFraction > 1.0)
	{
		heightFraction = 1.0;
        
	}
    
	UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
	
	if (orientation == UIInterfaceOrientationPortrait ||  orientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
        
		
	}
	else
	{
        
		animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
        
	}
	CGRect viewFrame = self.frame;
	viewFrame.origin.y -= animatedDistance;
    
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	
    
	[self setFrame:viewFrame];
	
	[UIView commitAnimations];
}


- (void)downTheView:(UIView *)editingView{
    
    CGRect viewFrame = self.frame;
	viewFrame.origin.y += animatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	
	[self setFrame:viewFrame];
	
	[UIView commitAnimations];
}


- (void)setKeyBoardNotifications{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameUp:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameDown:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
}


- (void)keyboardFrameUp:(NSNotification *)notification{
    
    
}

- (void)keyboardFrameDown:(NSNotification *)notification{
    
    
}

- (void)removeObservers{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
}


- (BOOL)isPortrait{
    
    if ([[UIDevice currentDevice] orientation]==UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation]==UIDeviceOrientationPortraitUpsideDown) {
        
        return YES;
    }
    return NO;
    
}

- (BOOL)isLandscape{
    
    if ([[UIDevice currentDevice] orientation]==UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation]==UIDeviceOrientationLandscapeRight) {
        
        return YES;
    }
    return NO;
    
}

- (int)locationTypePortrait{
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        return YES;
    }
    
    return NO;
}


@end
