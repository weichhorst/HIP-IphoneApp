//
//  UserProjectDataBase.m
//  Conasys
//
//  Created by user on 6/9/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "UserProjectDataBase.h"
#import "Macros.h"

@implementation UserProjectDataBase

static sqlite3_stmt *insertLocationStatement;
static sqlite3_stmt *getAllLocationStatement;
//static sqlite3_stmt *deleteLocationStatement;
//static sqlite3_stmt *deleteAllLocationStatement;


static Database *sharedDatabase = nil;


+ (id)sharedDatabase
{
    
    if (!sharedDatabase)
    {
        sharedDatabase = [[self alloc] init];
        
        [sharedDatabase createDb:sharedDatabase];
        [sharedDatabase customInit];
        
    }
    return sharedDatabase;
}


-(void)customInit
{
    
    static const char *insertRecord = "Insert into LocationTable (projectId, userId) values (?, ?)";
    sqlite3_prepare_v2(self.connection, insertRecord, -1, &insertLocationStatement, NULL);
    
    static const char *getUser = "SELECT * From LocationTable where userId = ?";
    sqlite3_prepare_v2(self.connection, getUser, -1, &getAllLocationStatement, NULL);
    
}


- (void)insertIntoUserProjectTable:(NSString *)projectId{
    
    
    sqlite3_bind_text(insertLocationStatement, 1, [projectId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertLocationStatement, 2, [CURRENT_USER_ID UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(insertLocationStatement))
    {
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    
    sqlite3_reset(insertLocationStatement);
}



- (NSMutableArray *)getAllProjectForUser:(NSString *)userId{
    
    
    NSMutableArray *projectIdArray = [NSMutableArray new];
    
    sqlite3_bind_text(getAllLocationStatement, 1, [userId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(getAllLocationStatement)==SQLITE_ROW)
    {
        
        [projectIdArray addObject:[NSString stringWithFormat:@"%d", sqlite3_column_int(getAllLocationStatement, 0)]];
    }
    
    sqlite3_reset(getAllLocationStatement);
    
    return projectIdArray;
}



@end

