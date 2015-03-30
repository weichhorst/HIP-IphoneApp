//
//  DatabaseTests.m
//  Conasys
//
//  Created by user on 8/26/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Project.h"
#import "ProjectDataBase.h"
#import "ProjectDBManager.h"


@interface DatabaseTests : XCTestCase

@end

@implementation DatabaseTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testInstance{
    
    if ([BuilderUsersDB sharedDatabase]) {
        
        XCTAssertTrue(YES, @"Object Exist");
    }
    else{
        
        XCTFail(@"Object Doesn't exist");
    }
}


-(void)testCreateDb {
    
    NSString *databasePath;
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"ConasysDB.sqlite"];
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    
    if (!success) {
        
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ConasysDB.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        
        if (success) {
           
            XCTAssertTrue(success, @"Database is copied to Doc Dir");
        }
        else{
            
            XCTFail(@"Error! Database not copied to Doc Dir");
        }
    }
    
    sqlite3 *connectio;
    sqlite3_open([writableDBPath UTF8String], &connectio);
    databasePath=writableDBPath;
}



- (void)testUserExist{
    
    BuilderUser *builderUser = [[BuilderUser alloc]init];
    builderUser.userId = CURRENT_BUILDER_ID;
    if ([[BuilderUsersDB sharedDatabase] isUserExist:builderUser]) {
        
        XCTAssertTrue(YES, @"Builder exist");
    }
    else{
        
        XCTFail(@"Builder doesn't exist");
    }
}


- (void)testFetchSavedUser{
    
    NSString *username = @"testbuilder";
    NSString *password = @"Buildteam";
    
    if ([[BuilderUsersDB sharedDatabase] fetchSavedUser:username andPassword:password]) {
        
        XCTAssertTrue(YES, @"Builder fetched");
    }
    else{
        
        XCTFail(@"Builder doesn't exist");
    }
}


- (void)testBuilderProject{
    
    NSMutableArray *array = [[ProjectDBManager sharedManager] getAllProjectsForUser:CURRENT_BUILDER_ID];
    if (array.count) {
        
        XCTAssertTrue(YES, @"Projects Fetched");
    }
    else{
        
        XCTFail(@"Project doesn't exist");
    }
}


@end
