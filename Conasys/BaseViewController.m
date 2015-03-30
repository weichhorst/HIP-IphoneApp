//
//  BaseViewController.m
//  Conasys
//
//  Created by user on 4/24/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseViewController.h"
#import "AlertViewShow.h"


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 220;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 500;
CGFloat animatedDistance;

#define SLIDER_VIEW_X 0

#define SLIDER_VIEW_WIDTH self.view.frame.size.width
#define SLIDER_VIEW_HEIGHT 100

#define BOTTOM_VIEW_X 0
#define BOTTOM_VIEW_WIDHT self.view.frame.size.width
#define BOTTOM_VIEW_HEIGHT 50
#define BOTTOM_VIEW_Y self.view.frame.size.height-BOTTOM_VIEW_HEIGHT


#define REGISTER_VIEW_X 0
#define REGISTER_VIEW_Y 0
#define REGISTER_VIEW_WIDTH 320
#define REGISTER_VIEW_HEIGHT 165

#define ALERT_VIEW_NIB @"AlertViewShow"
#define APP_BOTTOM_NIB @"AppBottomView"
#define STEP_SLIDER_NIB @"StepSliderView"
#define OVERLAY_IMAGE_NAME @"overlay-0.25.png"



@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.view setBackgroundColor:COLOR_BACKGROUND_APP];
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSyncTime:) name:SYNC_UPDATE_NOTIFICATION object:nil];
}


- (void)updateSyncTime:(NSNotification *)notification{
    
    [appBottomView enterLastSyncDate];
}

- (void)startBackgroundProcess{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:INTERNET_NOTIFICATION object:nil];
}


- (void)networkChanged:(NSNotification *)notification{
    

    BOOL netStatus = [[[notification userInfo] objectForKey:INTERNET_NOTIFICATION_INFO_KEY] intValue];
    [appBottomView internetConnectedNow:netStatus==NotReachable?NO:YES];
    
}



- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:INTERNET_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYNC_UPDATE_NOTIFICATION object:nil];
    
    [self removeBottomBar];
}

- (IBAction)backButtonClicked:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)logoutClicked:(UIButton *)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
 
    [super didReceiveMemoryWarning];
}

// returning YES if network is available else NO
- (BOOL)isNetworkAvailable
{
    if (isConnected) {
        
        return YES;
    }
    
    [Utility showErrorAlert:NETWORK_ERROR_MESSAGE];
    return NO;
    
}


- (BOOL)networkAvailable
{
    
#if DIRECT_NAVIGATION_ON
    
    return NO;
#endif
    
    if (isConnected) {
        
        return YES;
    }    
    return NO;
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
	[self.view.window convertRect:editingView.bounds fromView:editingView];
	CGRect viewRect =
	[self.view.window convertRect:self.view.bounds fromView:self.view];
	
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
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y -= animatedDistance;
    
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	
    
	[self.view setFrame:viewFrame];
	
	[UIView commitAnimations];
}


- (void)downTheView:(UIView *)editingView{
    
    CGRect viewFrame = self.view.frame;
	viewFrame.origin.y += animatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	
	[self.view setFrame:viewFrame];
	
	[UIView commitAnimations];
}


#pragma mark - Slider Views

- (void)addTheSliderView{
    
    stepSliderView = [[StepSliderView alloc]initWithFrame:CGRectMake(SLIDER_VIEW_X, SLIDER_VIEW_Y, SLIDER_VIEW_WIDTH, SLIDER_VIEW_HEIGHT) andCompletionBlock:^(id data, int buttonTag, BOOL result) {
        
    }];
    
    NSString *nibName = STEP_SLIDER_NIB;
    
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:nibName owner:stepSliderView options:nil];
    
    
    UIView *viewFromXib;
    for (id currentObject in topLevelObjects)
    {
        
        if ([currentObject isKindOfClass:[UIView class]])
        {
            
            viewFromXib = (UIView*)currentObject;
            break;
        }
    }
    
    [stepSliderView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [stepSliderView addSubview:viewFromXib];
    [stepSliderView setBackgroundColor:[UIColor whiteColor]];
    [stepSliderView makeButtonsRounded];
    [self.view addSubview:stepSliderView];
}


- (void)addTheBottomImage{
    
    
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

- (int)orientationTypePortrait{
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        return YES;
    }
    
    return NO;
}

#pragma mark - Loader Methods
-(void)showLoader :(NSString *)message inViewController:(UIViewController *)viewController {
	
    [self showLoader:message onView:viewController.view];
}

-(void)showLoader :(NSString *)message
{
    
    [self showLoader:message onView:self.view];
}

// This will show Loading icon over black view with text passed.
-(void)showLoader :(NSString *)message onView:(UIView *)view
{
	
    [self hideLoader];
	progressBar = [[MBProgressHUD alloc] initWithView:view];
	progressBar.userInteractionEnabled = YES;
	progressBar.labelText = message;
    [progressBar setCenter:view.center];
	[view addSubview:progressBar];
	[view bringSubviewToFront:progressBar];
	[progressBar show:YES];
}


// will be called when view rotates.
-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    UIView *parentView = (UIView *)[progressBar superview];
    [progressBar setCenter:parentView.center];
}


-(void)hideLoader {

    [progressBar hide:YES];
}


- (BOOL)isLoadingBarPresent{
    
    return ![progressBar isHidden];
}


// adding the bottom Tabbar displaying all data about n/w and last sync.
- (void)addBottomBar{
    
    if (appBottomView) {
        
        [appBottomView removeFromSuperview];
    }
    
    appBottomView = [[AppBottomView alloc]initWithFrame:CGRectMake(BOTTOM_VIEW_X, BOTTOM_VIEW_Y, BOTTOM_VIEW_WIDHT, BOTTOM_VIEW_HEIGHT) ];
    
    NSString *nibName = APP_BOTTOM_NIB;
    
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:nibName owner:appBottomView options:nil];
    
    
    UIView *viewFromXib;
    for (id currentObject in topLevelObjects)
    {
        
        if ([currentObject isKindOfClass:[UIView class]])
        {
            
            viewFromXib = (UIView*)currentObject;
            break;
        }
    }
    
    [appBottomView addSubview:viewFromXib];
    
    if (![self orientationTypePortrait]) {

        [appBottomView changeFrameForLandscape];
    }
    
    
    [appBottomView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:appBottomView];

    [appBottomView internetConnectedNow:isConnected];
    
    [appBottomView setBackgroundColor:[UIColor clearColor]];
    
    [self startBackgroundProcess];
    
}

// Removing the bottom tabbar displaying all data about n/w and last sync.
- (void)removeBottomBar{
    
    if (appBottomView) {

        [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
        [appBottomView removeFromSuperview];
        appBottomView = nil;
    }
}

// Updating item view number.
- (void)updateDeficiencyReview:(DeficiencyReview *)defiReview{
    
    
    DeficiencyReviewDatabase *deficiencyReviewDB = [DeficiencyReviewDatabase sharedDatabase];
    
    [deficiencyReviewDB updateDeficiencyReview:defiReview];
}


// Showing custom alert with passed message
-(void)showCustomAlertWithMessage:(NSString *)message
{
    
    AlertViewShow *alertView = [[AlertViewShow alloc]initWithFrame:CGRectMake(REGISTER_VIEW_X, REGISTER_VIEW_Y, REGISTER_VIEW_WIDTH,REGISTER_VIEW_HEIGHT) andCompletionBlock:^(id data, int buttonTag, BOOL shouldHide){
        
        [rnBlurModalView hide];
                         
    }];
    
    NSString *nibName = ALERT_VIEW_NIB;
    
    NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:nibName owner:alertView options:nil];
    
    
    UIView *viewFromXib;
    for (id currentObject in topLevelObjects)
    {
        
        if ([currentObject isKindOfClass:[UIView class]])
        {
            
            viewFromXib = (UIView*)currentObject;
            break;
        }
    }
    
    [alertView addSubview:viewFromXib];
    [alertView setCenter:self.view.center];
    
    [alertView showText:message];
    
    rnBlurModalView = [[RNBlurModalView alloc]initWithViewController:self view:alertView];
    [rnBlurModalView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:OVERLAY_IMAGE_NAME]]];
    [rnBlurModalView show];
    
    return;
 
}

// changing title of view at the top present in ownerIdentificaiton, ReviewItems and confirmation page
- (void)changedTitle:(BOOL)isPDI{
    
    [stepSliderView changeTitleIsPDI:isPDI];
}

@end
