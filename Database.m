//
//  Database.m
//  Conasys
//
//  Created by user on 5/12/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Database.h"

@implementation Database

@synthesize connection;
@synthesize databasePath;
@synthesize databaseName;


// Creating and copying DB to Documents directory.
-(void)createDb:(Database*)sharedDatabase {
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"ConasysDB.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    
    if (!success) {
        
        // The writable database does not exist, so copy the default to the appropriate location.
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ConasysDB.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error description]);
        }
    }
    
    sqlite3 *connectio;
    sqlite3_open([writableDBPath UTF8String], &connectio);
    sharedDatabase.connection = connectio;
    
    databasePath=writableDBPath;
}

+ (id)sharedDatabase {
    
    return nil;
}

-(void)customInit {
    
}

-(long long)getLastInsertedId {
    
    return sqlite3_last_insert_rowid(connection);
}


@end
