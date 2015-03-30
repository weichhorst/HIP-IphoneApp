//
//  Users.m
//  Conasys
//
//  Created by user on 5/12/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Users.h"

@implementation Users

@end

@implementation UsersDB

static Database *sharedDatabase = nil;

+ (id)sharedDatabase {

    if (!sharedDatabase) {
        sharedDatabase = [[self alloc] init];
        
        [sharedDatabase createDb:sharedDatabase];
        [sharedDatabase customInit];
        
    }
    return sharedDatabase;
}


static sqlite3_stmt *insertUsersStatement;
static sqlite3_stmt *deleteUserStatement;
static sqlite3_stmt *getUsersStatement;
static sqlite3_stmt *switchParagmaON;
static sqlite3_stmt *getUserCountStatement;

static sqlite3_stmt *getUserFromUsernameAndPasswordDB;


-(void)customInit {
    
    static const char *insertRecord = "INSERT OR IGNORE into User (userId, username, password, userToken) values (?, ?, ?, ?)";
        sqlite3_prepare_v2(self.connection, insertRecord, -1, &insertUsersStatement, NULL);
    
    
    static const char *deleteRecord = "DELETE FROM User WHERE userId = ?";
    sqlite3_prepare_v2(self.connection, deleteRecord, -1, &deleteUserStatement, NULL);
    
    
    static const char *getUser = "SELECT * From User where userId = ?";
    sqlite3_prepare_v2(self.connection, getUser, -1, &getUsersStatement, NULL);
    
    
    static const char *pragmaON = "PRAGMA foreign_keys = ON";
    sqlite3_prepare_v2(self.connection, pragmaON, -1, &switchParagmaON, NULL);
    
    
    static const char *userCount = "select count(userId) from User where userId=?";
    sqlite3_prepare_v2(self.connection, userCount, -1, &getUserCountStatement, NULL);
 
    
    static const char *getSavedUser = "select * from User where username = ? and password = ?";
    sqlite3_prepare_v2(self.connection, getSavedUser, -1, &getUserFromUsernameAndPasswordDB, NULL);
    
}



- (void)insertIntoUserTable:(Users *)user{
    
    
    sqlite3_bind_text(insertUsersStatement, 1, [user.userId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertUsersStatement, 2, [user.username UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertUsersStatement, 3, [user.password UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertUsersStatement, 4, [user.userToken UTF8String], -1, SQLITE_TRANSIENT);
        
    if(SQLITE_DONE != sqlite3_step(insertUsersStatement)){
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    
    sqlite3_reset(insertUsersStatement);
    
}


- (BOOL)isUserExist:(Users *)user{
    
    BOOL result = NO;
    sqlite3_bind_text(getUserCountStatement, 1, [user.userId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(getUserCountStatement)==SQLITE_ROW) {
        
        result = YES;
    }
    
    sqlite3_reset(getUserCountStatement);
    
    return result;
}


- (Users *)fetchUser:(NSString *)userId{
    
    Users *user;
    
    sqlite3_bind_text(getUsersStatement, 1, [userId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(getUsersStatement)==SQLITE_ROW) {
        
        user = [[Users alloc]init];
        
        user.userId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUsersStatement, 0)];
        
        user.username = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUsersStatement, 1)];
        
        user.password = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUsersStatement, 2)];
        
        user.userToken = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUsersStatement, 3)];
        
    }
    
    sqlite3_reset(getUsersStatement);
    return user;
}



// fetching saved user from DB, if app is in offline mode and user exists.
- (Users *)fetchSavedUser:(NSString *)userName andPassword:(NSString *)password{
    
    Users *user = [[Users alloc]init];
    
    sqlite3_bind_text(getUserFromUsernameAndPasswordDB, 1, [userName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(getUserFromUsernameAndPasswordDB, 2, [password UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(getUserFromUsernameAndPasswordDB)==SQLITE_ROW) {
                
        user.userId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUserFromUsernameAndPasswordDB, 0)];
        
        user.username = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUserFromUsernameAndPasswordDB, 1)];
        
        user.password = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUserFromUsernameAndPasswordDB, 2)];
        
        user.userToken = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUserFromUsernameAndPasswordDB, 3)];
        
    }
    
    sqlite3_reset(getUserFromUsernameAndPasswordDB);
    
    return user;
}




- (void)deleteUserFromTable:(Users *)user{
    
    [self switchPragmaOn];
    
    sqlite3_bind_text(deleteUserStatement, 1, [user.userId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(deleteUserStatement);
    sqlite3_reset(deleteUserStatement);
}



- (void)switchPragmaOn{
    
    sqlite3_step(switchParagmaON);
    sqlite3_reset(switchParagmaON);
}


@end
