//
//  AppDelegate.h
//  Conasys
//
//  Created by user on 4/24/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MBProgressHUD.h"

#import "BuilderUser.h"
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
//    Review *review;
    
    UIBackgroundTaskIdentifier taskIdentifier;
    
    NSTimer *myTimer;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain)BuilderUser *currentBuilder;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
@property (nonatomic, readwrite)float popOverMargin;

@property (nonatomic, readwrite)BOOL lockOrientation;



@end
