//
//  BuilderUser.h
//  Conasys
//
//  Created by user on 8/1/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Database.h"

@interface BuilderUser : NSObject

@property(nonatomic, retain)NSString *userId;
@property(nonatomic, retain)NSString *username;
@property(nonatomic, retain)NSString *userToken;
@property (nonatomic, retain)NSString *password;

@property (nonatomic, retain)NSString *performedEmail;
@property (nonatomic, retain)NSString *performedName;
@property (nonatomic, retain)NSString *lastSyncDate;

@end


@interface BuilderUsersDB : Database

+ (id)sharedDatabase;

- (void)insertIntoUserTable:(BuilderUser *)user;

- (BuilderUser *)fetchUser:(NSString *)userId;

- (void)deleteUserFromTable:(BuilderUser *)user;

- (BOOL)isUserExist:(BuilderUser *)user;

- (BuilderUser *)fetchSavedUser:(NSString *)userName andPassword:(NSString *)password;

- (void)updateBuilderUser:(BuilderUser *)builderUser;

- (void)updateBuilderLastSyncDate:(NSString *)userId;

@end
