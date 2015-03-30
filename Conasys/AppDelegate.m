//
//  AppDelegate.m
//  Conasys
//
//  Created by user on 4/24/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"

#import "DBManagerHeader.h"
#import "ConasysRequestManager.h"
#import "Owner.h"
#import "ReviewUploader.h"
#import "Utility.h"


@implementation AppDelegate

//@synthesize progressBar;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.currentBuilder = [[BuilderUser alloc]init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BaseNavigationController *baseNavController = [[BaseNavigationController alloc]initWithRootViewController:[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil]];
    [baseNavController.navigationBar setTintColor:[UIColor blackColor]];
    self.window.rootViewController = baseNavController;
    [self.window makeKeyAndVisible];
    
    [self startBackgroundProcess];
    
    if ([Utility isiOSVersion6]) {
        
        if (myTimer) {
            
            [myTimer invalidate];
            myTimer =nil;
        }

    }
   
    return YES;
}


- (BOOL)checkForConnectivity
{
    
    NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
    
    return [dict count] > 0;
}



// background process is being started to work and check for network status and upload reviews that were submitted offline.
- (void)startBackgroundProcess{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityHasChanged:) name:kReachabilityChangedNotification object:nil];
    
   self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
	[self updateInterfaceWithReachability:self.internetReachability];
}


- (void) reachabilityHasChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:INTERNET_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", netStatus], INTERNET_NOTIFICATION_INFO_KEY, nil]];
    
    if (netStatus!=NotReachable) {
        
        [self checkAndUploadReview];
    };
}

- (void)checkAndUploadReview{
    
    ReviewUploader *review = [[ReviewUploader alloc]init];
    
    [review performSelectorInBackground:@selector(checkAndUploadReviews) withObject:nil];
}


// when app enters in background it will start the background tasks open
- (void)applicationDidEnterBackground:(UIApplication *)application{
    
    
//    if([Utility isiOSVersion6]){
//        
//        myTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkAndUploadReview) userInfo:nil repeats:YES];
//        
//        [myTimer fire];
//    }
    
    taskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
        
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    
    if ([Utility isiOSVersion6]) {

        if (myTimer) {
            
            [myTimer invalidate];
            myTimer =nil;
        }
    }
    [application endBackgroundTask:taskIdentifier];
//    [self checkAndUploadReview];
}

@end
