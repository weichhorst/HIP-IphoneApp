//
//  BuilderUser.m
//  Conasys
//
//  Created by user on 8/1/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BuilderUser.h"
#import "DateFormatter.h"

@implementation BuilderUser

@end


@implementation BuilderUsersDB

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
static sqlite3_stmt *updateUsersStatement;

static sqlite3_stmt *deleteUserStatement;
static sqlite3_stmt *getUsersStatement;
static sqlite3_stmt *switchParagmaON;
static sqlite3_stmt *getUserCountStatement;

static sqlite3_stmt *updateSyncDateStatement;

static sqlite3_stmt *getUserFromUsernameAndPasswordDB;


-(void)customInit {
    
    static const char *insertRecord = "INSERT  into BuilderUser (userId, username, password, userToken, performedEmail, performedName) values (?, ?, ?, ?, ?, ?)";
    sqlite3_prepare_v2(self.connection, insertRecord, -1, &insertUsersStatement, NULL);
    
    static const char *updateRecord = "Update BuilderUser set username =?, password = ?, userToken = ?, performedEmail = ?, performedName = ?, lastSyncDate= ? where userId = ?";
    
    sqlite3_prepare_v2(self.connection, updateRecord, -1, &updateUsersStatement, NULL);
    
    
    static const char *updateSyncDate = "Update BuilderUser set lastSyncDate = ? where userId = ?";
    
    sqlite3_prepare_v2(self.connection, updateSyncDate, -1, &updateSyncDateStatement, NULL);
    
    
    static const char *deleteRecord = "DELETE FROM BuilderUser WHERE userId = ?";
    sqlite3_prepare_v2(self.connection, deleteRecord, -1, &deleteUserStatement, NULL);
    
    
    static const char *getUser = "SELECT * From BuilderUser where userId = ?";
    sqlite3_prepare_v2(self.connection, getUser, -1, &getUsersStatement, NULL);
    
    
    static const char *pragmaON = "PRAGMA foreign_keys = ON";
    sqlite3_prepare_v2(self.connection, pragmaON, -1, &switchParagmaON, NULL);
    
    
    static const char *userCount = "select count(userId) from BuilderUser where userId=?";
    sqlite3_prepare_v2(self.connection, userCount, -1, &getUserCountStatement, NULL);
    
    static const char *getSavedUser = "select * from BuilderUser where username = ? and password = ?";
    sqlite3_prepare_v2(self.connection, getSavedUser, -1, &getUserFromUsernameAndPasswordDB, NULL);
    
}


- (void)insertIntoUserTable:(BuilderUser *)builderUser{
    
    if ([self isUserExist:builderUser]) {
        
        
        BuilderUser *myUser = [[BuilderUsersDB sharedDatabase] fetchUser:builderUser.userId];
        builderUser.lastSyncDate = myUser.lastSyncDate;
        [self updateBuilderUser:builderUser];
        
        return;
    }
    sqlite3_bind_text(insertUsersStatement, 1, [builderUser.userId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertUsersStatement, 2, [builderUser.username UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertUsersStatement, 3, [builderUser.password UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertUsersStatement, 4, [builderUser.userToken UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertUsersStatement, 5, [builderUser.performedEmail UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertUsersStatement, 6, [builderUser.performedName UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(insertUsersStatement)){
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    
    sqlite3_reset(insertUsersStatement);
    
}


- (void)updateBuilderUser:(BuilderUser *)builderUser{
    
    sqlite3_bind_text(updateUsersStatement, 1, [builderUser.username UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(updateUsersStatement, 2, [builderUser.password UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(updateUsersStatement, 3, [builderUser.userToken UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(updateUsersStatement, 4, [builderUser.performedEmail UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(updateUsersStatement, 5, [builderUser.performedName UTF8String], -1, SQLITE_TRANSIENT);
        
    sqlite3_bind_text(updateUsersStatement, 6, [builderUser.lastSyncDate UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateUsersStatement, 7, [builderUser.userId UTF8String], -1, SQLITE_TRANSIENT);

    
    if(SQLITE_DONE != sqlite3_step(updateUsersStatement)){
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    
    sqlite3_reset(updateUsersStatement);
}


- (void)updateBuilderLastSyncDate:(NSString *)userId{
    
    
    sqlite3_bind_text(updateSyncDateStatement, 1, [[[DateFormatter sharedFormatter] getSyncStringFromDate:[NSDate date]] UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateSyncDateStatement, 2, [userId UTF8String], -1, SQLITE_TRANSIENT);
    
    
    if(SQLITE_DONE != sqlite3_step(updateSyncDateStatement)){
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    
    sqlite3_reset(updateSyncDateStatement);
}



- (BOOL)isUserExist:(BuilderUser *)builderUser{
    
    BOOL result = NO;
    sqlite3_bind_text(getUserCountStatement, 1, [builderUser.userId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(getUserCountStatement)==SQLITE_ROW) {
        
        result = sqlite3_column_int(getUserCountStatement, 0);
    }
    
    sqlite3_reset(getUserCountStatement);
    
    return result;
}


- (BuilderUser *)fetchUser:(NSString *)builderUserId{
    
    BuilderUser *builderUser;
    
    sqlite3_bind_text(getUsersStatement, 1, [builderUserId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(getUsersStatement)==SQLITE_ROW) {
        
        builderUser = [[BuilderUser alloc]init];
        
        builderUser.userId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUsersStatement, 0)];
        
        builderUser.username = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUsersStatement, 1)];
        
        builderUser.password = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUsersStatement, 2)];
        
        builderUser.userToken = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUsersStatement, 3)];
        
        if(sqlite3_column_text(getUsersStatement, 4) != nil){
            
            builderUser.performedEmail = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUsersStatement, 4)];
        }
        else{
            
            builderUser.performedEmail = @"";
        }
        
        
        if(sqlite3_column_text(getUsersStatement, 5) != nil){
            
            builderUser.performedName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUsersStatement, 5)];
        }
        else{
            
            builderUser.performedName = @"";
        }
        
        if(sqlite3_column_text(getUsersStatement, 6) != nil){
            
            builderUser.lastSyncDate = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUsersStatement, 6)];
        }
        else{
            
            builderUser.lastSyncDate = @"";
        }
        
        
    }
    
    sqlite3_reset(getUsersStatement);
    return builderUser;
}



// fetching saved user from DB, if app is in offline mode and user exists.
- (BuilderUser *)fetchSavedUser:(NSString *)builderUserName andPassword:(NSString *)password{
    
    BuilderUser *builderUser = [[BuilderUser alloc]init];
    
    sqlite3_bind_text(getUserFromUsernameAndPasswordDB, 1, [builderUserName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(getUserFromUsernameAndPasswordDB, 2, [password UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(getUserFromUsernameAndPasswordDB)==SQLITE_ROW) {
        
        builderUser.userId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUserFromUsernameAndPasswordDB, 0)];
        
        builderUser.username = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUserFromUsernameAndPasswordDB, 1)];
        
        builderUser.password = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUserFromUsernameAndPasswordDB, 2)];
        
        builderUser.userToken = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUserFromUsernameAndPasswordDB, 3)];
        
        
        
        if(sqlite3_column_text(getUserFromUsernameAndPasswordDB, 4) != nil){
            
            builderUser.performedEmail = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUserFromUsernameAndPasswordDB, 4)];
        }
        else{
            builderUser.performedEmail = @"";
        }
        
        
        if(sqlite3_column_text(getUserFromUsernameAndPasswordDB, 5) != nil){
            
            builderUser.performedName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUserFromUsernameAndPasswordDB, 5)];
        }
        else{
            
            builderUser.performedName = @"";
        }
        
        if(sqlite3_column_text(getUserFromUsernameAndPasswordDB, 6) != nil){
            
            builderUser.lastSyncDate = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUserFromUsernameAndPasswordDB, 6)];
        }
        else{
            
            builderUser.lastSyncDate = @"";
        }
        
    }
    
    sqlite3_reset(getUserFromUsernameAndPasswordDB);
    
    return builderUser;
}



- (void)deleteUserFromTable:(BuilderUser *)builderUser{
    
    [self switchPragmaOn];
    
    sqlite3_bind_text(deleteUserStatement, 1, [builderUser.userId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(deleteUserStatement);
    sqlite3_reset(deleteUserStatement);
}



- (void)switchPragmaOn{
    
    sqlite3_step(switchParagmaON);
    sqlite3_reset(switchParagmaON);
}

@end
