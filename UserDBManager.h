//
//  UserDBManager.h
//  Conasys
//
//  Created by user on 6/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseDBManager.h"
#import "Users.h"

@interface UserDBManager : BaseDBManager



- (Users *)saveUserToDB:(NSDictionary *)dictionary;
- (Users *)fetchUserForCredentials:(NSString *)userName andPass:(NSString *)password;

@end
