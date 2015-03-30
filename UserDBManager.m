//
//  UserDBManager.m
//  Conasys
//
//  Created by user on 6/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "UserDBManager.h"
#import "Macros.h"


@implementation UserDBManager

static UserDBManager *userDBManager = nil;

+ (id)sharedManager{
    
    if (!userDBManager) {
        
        userDBManager = [[UserDBManager alloc] init];
    }
    return userDBManager;
}


- (Users *)saveUserToDB:(NSDictionary *)dictionary
{
    Users *user = [[Users alloc]init];
    user.userId = [NSString stringWithFormat:@"%ld", [[dictionary objectForKey:@"UserId"] longValue]];
    user.username = [dictionary objectForKey:CURRENT_USERNAME_KEY];
    user.userToken = [dictionary objectForKey:@"ResultData"];
    user.password = [dictionary objectForKey:CURRENT_PASSWORD_KEY];
    
    [[UsersDB sharedDatabase] insertIntoUserTable:user];
    
    return user;
}


- (Users *)fetchUserForCredentials:(NSString *)userName andPass:(NSString *)password{
    
    return [[UsersDB sharedDatabase] fetchSavedUser:userName andPassword:password];
}

@end
