//
//  Utility.h
//  Celebrity
//
//  Created by user on 3/3/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Utility : NSObject



+ (BOOL)isNetworkAvailble;

+ (NSString *)getCurrentOS;

+ (void)showAlert:(NSString *)title andMessage:(NSString *)message;

+ (BOOL)validateEmail: (NSString *) email;

+ (void)showErrorAlert:(NSString*)errorMessage;

+ (BOOL)deviceTypeiPad;

+ (BOOL)isiOSVersion7;

+ (BOOL)isiOSVersion6;

+ (BOOL)isiOSVersion8;

+(void)removeImage:(NSString *)imageName;

+ (NSString *)getImagePath:(NSString *)imageName;

+(UIImage*)loadImageFromDD:(NSString*)imagePath;

+ (BOOL)imageExist:(NSString *)imageName;

+ (UIView *)showCustomAlertWithMessage:(NSString *)message onView:(UIView *)parentView;

@end
