//
//  Utility.m
//  Celebrity
//
//  Created by user on 3/3/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Utility.h"
//#import "AppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>

#import "AlertViewShow.h"
#import "RNBlurModalView.h"
#import "AppDelegate.h"

#define REGISTER_VIEW_X 0
#define REGISTER_VIEW_Y 0
#define REGISTER_VIEW_WIDTH 320
#define REGISTER_VIEW_HEIGHT 165


@implementation Utility

// To check if network is available or not.
+ (BOOL)isNetworkAvailble{
    
    const char *host_name = "google.com";
	BOOL _isDataSourceAvailable = NO;
	Boolean success;
	
	//Creates a reachability reference to the specified
	//network host or node name.
	SCNetworkReachabilityRef reachability =
	SCNetworkReachabilityCreateWithName(NULL,host_name);
	
	//Determines if the specified network target is reachable
	//using the current network configuration.
	SCNetworkReachabilityFlags flags;
    
	success = SCNetworkReachabilityGetFlags(reachability, &flags);
	_isDataSourceAvailable = success &&
	(flags & kSCNetworkFlagsReachable) &&
	!(flags & kSCNetworkFlagsConnectionRequired);
	
	CFRelease(reachability);
	return _isDataSourceAvailable;
    
}


// Below two methods show alertView with message being forwarded
+(void)showErrorAlert:(NSString*)errorMessage{
 
    [self showAlert:nil andMessage:errorMessage];
}


+ (void)showAlert:(NSString *)title andMessage:(NSString *)message{
    
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
}

// Getting current Operating System Version
+ (NSString *)getCurrentOS{
    
    return [[UIDevice currentDevice] systemVersion];
    
}

// Checking if current OS version is greater than or equal to iOS7.0
+ (BOOL)isiOSVersion7{
    
    return [[Utility getCurrentOS] floatValue]>=7.0?YES:NO;
}

+ (BOOL)isiOSVersion6{
    
    return [[Utility getCurrentOS] floatValue]<7.0?YES:NO;
}

+ (BOOL)isiOSVersion8{
    
    return [[Utility getCurrentOS] floatValue]>=8.0?YES:NO;
}

// Validating email, will return YES if email is in correct format else NO
+ (BOOL)validateEmail: (NSString *) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}

+ (BOOL)deviceTypeiPad{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
    return NO;
}


+(void)removeImage:(NSString *)imageName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:
                          imageName];
    
    [fileManager removeItemAtPath: fullPath error:NULL];

}

+ (BOOL)imageExist:(NSString *)imageName{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:
                          imageName];
    return [fileManager fileExistsAtPath:fullPath];
}


+ (NSString *)getImagePath:(NSString *)imageName{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:
                          imageName];
    return fullPath;
}


+(UIImage*)loadImageFromDD:(NSString*)imagePath
{
    UIImage *image1 = [UIImage imageWithContentsOfFile:imagePath];
    return image1;
};



+ (AlertViewShow *)showCustomAlertWithMessage:(NSString *)message onView:(UIView *)parentView
{
    
    for (UIView *subview in parentView.subviews) {
        
        [subview setUserInteractionEnabled:NO];
    }
    

    AlertViewShow *alertView;
    
    alertView = [[AlertViewShow alloc]initWithFrame:CGRectMake(REGISTER_VIEW_X, REGISTER_VIEW_Y, REGISTER_VIEW_WIDTH,REGISTER_VIEW_HEIGHT) andCompletionBlock:^(id data, int buttonTag, BOOL shouldHide){
        
        [[parentView.subviews objectAtIndex:parentView.subviews.count-1] removeFromSuperview];
                
        for (UIView *subview in parentView.subviews) {
            
            [subview setUserInteractionEnabled:YES];
        }
        
    }];
    
    NSString *nibName = @"AlertViewShow";
    
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
    [alertView setCenter:CGPointMake(parentView.frame.size.width/2, parentView.frame.size.height/2)];
//    [alertView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [alertView showText:message];
    
    
    
    return alertView;
}


@end