//
//  Developer.m
//  Conasys
//
//  Created by user on 7/17/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Developer.h"

@implementation Developer

@end


@implementation DeveloperDB

static Database *sharedDatabase = nil;

+ (id)sharedDatabase {
    
    if (!sharedDatabase) {
        sharedDatabase = [[self alloc] init];
        
        [sharedDatabase createDb:sharedDatabase];
        [sharedDatabase customInit];
        
    }
    return sharedDatabase;
}



static sqlite3_stmt *insertDeveloperStatement;
static sqlite3_stmt *deleteDeveloperStatement;
static sqlite3_stmt *getDeveloperStatement;
static sqlite3_stmt *updateDeveloperStatement;


-(void)customInit {
    
    static const char *insertRecord = "INSERT into DeveloperDataTable (userId, unitsRowId, developerName, developerImage) values (?, ?, ?, ?)";
    sqlite3_prepare_v2(self.connection, insertRecord, -1, &insertDeveloperStatement, NULL);
    
    static const char *deleteRecord = "DELETE FROM DeveloperDataTable WHERE userId = ? and unitsRowId = ?";
    sqlite3_prepare_v2(self.connection, deleteRecord, -1, &deleteDeveloperStatement, NULL);
    
    static const char *getUser = "SELECT * From DeveloperDataTable where userId = ? and unitsRowId = ?";
    sqlite3_prepare_v2(self.connection, getUser, -1, &getDeveloperStatement, NULL);
    
    static const char *pragmaON = "Update DeveloperDataTable set developerName = ?, developerImage = ? where userId=? and unitsRowId=?";
    sqlite3_prepare_v2(self.connection, pragmaON, -1, &updateDeveloperStatement, NULL);
}


- (void)insertIntoDeveloperTable:(Developer *)developer{
    
    sqlite3_bind_text(insertDeveloperStatement, 1, [developer.userId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(insertDeveloperStatement, 2, developer.unitsRowId);
    
    sqlite3_bind_text(insertDeveloperStatement, 3, [developer.developerName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertDeveloperStatement, 4, [developer.base64String UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(insertDeveloperStatement)){
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    
    sqlite3_reset(insertDeveloperStatement);
}


- (Developer *)fetchDeveloper:(NSString *)userId andUnitRowId:(int)unitsRowId{
    
    
    NSLog(@"SELECT * From DeveloperDataTable where userId = %@ and unitsRowId = %d", userId, unitsRowId);
    
    sqlite3_bind_text(getDeveloperStatement, 1, [userId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(getDeveloperStatement, 2, unitsRowId);
    
    Developer *developer = [[Developer alloc]init];
    
    while (sqlite3_step(getDeveloperStatement)==SQLITE_ROW)
    {
        
        developer.userId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeveloperStatement, 0)];
        
        developer.unitsRowId = sqlite3_column_int(getDeveloperStatement, 1);
        
        developer.developerName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeveloperStatement, 2)];
                
        if(sqlite3_column_text(getDeveloperStatement, 3) != nil)
        {
            
            developer.base64String = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeveloperStatement, 3)];
            
        }
        else{
            
            developer.base64String = @" ";
        }
    }
    
    sqlite3_reset(getDeveloperStatement);
    
    return developer;
}


- (void)deleteDeveloperFromTable:(Developer *)developer{
    
    sqlite3_bind_text(deleteDeveloperStatement, 1, [developer.userId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(deleteDeveloperStatement, 2, developer.unitsRowId);
    sqlite3_step(deleteDeveloperStatement);
    sqlite3_reset(deleteDeveloperStatement);

}

- (void)updateDeveloper:(Developer *)developer{
    
    sqlite3_bind_text(updateDeveloperStatement, 1, [developer.developerName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateDeveloperStatement, 2, [developer.base64String UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateDeveloperStatement, 3, [developer.userId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(updateDeveloperStatement, 4, developer.unitsRowId);
    
    sqlite3_step(updateDeveloperStatement);
    sqlite3_reset(updateDeveloperStatement);
}

@end
