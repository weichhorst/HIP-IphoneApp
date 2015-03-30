//
//  Macros.h
//  Celebrity
//
//  Created by user on 3/3/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#ifndef Celebrity_Macros_h
#define Celebrity_Macros_h

#import "Utility.h"
#import "UserDefaults.h"
#import "AppDelegate.h"


#define APP_NAME @"Conasys"
#define ERROR_TITLE @"Error!"
#define ALERT_ERROR_TITLE @"Error!"
#define CURRENT_USERNAME_KEY @"username"
#define CURRENT_PASSWORD_KEY @"userPassword"
#define CURRENT_USER_TOKEN_KEY @"userToken"
#define NETWORK_ERROR_MESSAGE @"Network Problem"
#define LOGIN_IMAGE_NAME_KEY @"Login_Image_Name"
#define REMEMBER_ME_USERNAME @"rememberUsername"
#define REMEMBER_ME_PASSWORD @"rememberPassword"

#define SPINNER_WAIT_TITLE @"Please wait.."
#define SPINNER_REFRESH_TITLE @"Refreshing.."

#define DELEGATE (AppDelegate *)[[UIApplication sharedApplication]delegate]

#define DEBUGGIN_ON 1

#define DIRECT_NAVIGATION_ON 0

#define SYNC_UPDATE_NOTIFICATION @"syncUpdatedNotification"
#define OVERLAY_NOTIFICATION @"OverlayNotification"

//********CURRENT USER DETAILS**********
#pragma mark - CURRENT USER DETAILS

#define CURRENT_USERNAME [UserDefaults valueForKey:CURRENT_USERNAME_KEY]
#define CURRENT_USER_TOKEN [UserDefaults valueForKey:CURRENT_USER_TOKEN_KEY]

#define CURRENT_BUILDER_ID [[(AppDelegate *)[[UIApplication sharedApplication]delegate] currentBuilder] userId]

#define CURRENT_BUILDER_PERFORMED_EMAIL [[(AppDelegate *)[[UIApplication sharedApplication]delegate] currentBuilder] performedEmail]

#define CURRENT_BUILDER_PERFORMED_NAME [[(AppDelegate *)[[UIApplication sharedApplication]delegate] currentBuilder] performedName]

#define INTERNET_NOTIFICATION @"NetworkNotification"
#define  INTERNET_NOTIFICATION_INFO_KEY @"hasInternet"

#pragma mark - Functions


#define isConnected [Utility isNetworkAvailble]
#define is_iPad [Utility deviceTypeiPad]


#endif
