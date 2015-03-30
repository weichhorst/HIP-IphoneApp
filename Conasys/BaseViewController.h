//
//  BaseViewController.h
//  Conasys
//
//  Created by user on 4/24/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Requests.h"
#import "ConasysRequestManager.h"
#import "UIView+customization.h"
#import "CustomViewHeader.h"
#import "CustomTableHeader.h"
#import "UIImageView+WebCache.h"
#import "DBManagerHeader.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "ImageFile.h"

#import "Unit.h"
#import "Reachability.h"
#import "DateFormatter.h"
#import "ResponseKeys.h"
#import "CategoryHeaderFile.h"

#import "DeficiencyReview.h"
#import "DeficiencyReviewDatabase.h"
#import "ReviewItem.h"
#import "ReviewItemDatabase.h"
#import "ReviewItemImage.h"
#import "ReviewItemImageDatabase.h"

#define SLIDER_VIEW_Y 90

@interface BaseViewController : UIViewController{
    
    StepSliderView *stepSliderView;
    
    MBProgressHUD *progressBar;
    
    AppBottomView *appBottomView;
    
    RNBlurModalView *rnBlurModalView;
    
}

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;


- (BOOL)networkAvailable;      //    has no message.
- (BOOL)isNetworkAvailable;    //    has error message.

- (IBAction)backButtonClicked:(UIButton *)sender;
- (IBAction)logoutClicked:(UIButton *)sender;
- (void)addTheSliderView;

- (BOOL)isPortrait;
- (BOOL)isLandscape;


-(void)hideLoader;
- (BOOL)isLoadingBarPresent;
-(void)showLoader :(NSString *)message;
-(void)showLoader :(NSString *)message onView:(UIView *)view;
-(void)showLoader :(NSString *)message inViewController:(UIViewController *)viewController;

- (void)addBottomBar;

- (void)removeBottomBar;
- (void)startBackgroundProcess;

- (void)upTheView:(UIView *)editingView;
- (void)downTheView:(UIView *)editingView;

- (void)updateDeficiencyReview:(DeficiencyReview *)deficiencyReview;

- (int)orientationTypePortrait;
-(void)showCustomAlertWithMessage:(NSString *)message;

- (void)changedTitle:(BOOL)isPDI;
@end
