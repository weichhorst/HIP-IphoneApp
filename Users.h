//
//  Users.h
//  Conasys
//
//  Created by user on 5/12/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Database.h"

@interface Users : NSObject

@property(nonatomic, retain)NSString *userId;
@property(nonatomic, retain)NSString *username;
@property(nonatomic, retain)NSString *userToken;
@property (nonatomic, retain)NSString *password;

@end


@interface UsersDB : Database

+ (id)sharedDatabase;

- (void)insertIntoUserTable:(Users *)user;

- (Users *)fetchUser:(NSString *)userId;

- (void)deleteUserFromTable:(Users *)user;

- (BOOL)isUserExist:(Users *)user;

- (Users *)fetchSavedUser:(NSString *)userName andPassword:(NSString *)password;


@end
