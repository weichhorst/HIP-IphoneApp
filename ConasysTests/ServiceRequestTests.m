//
//  ServiceRequestTests.m
//  Conasys
//
//  Created by user on 8/26/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Requests.h"
#import "ConasysRequestManager.h"


@interface ServiceRequestTests : XCTestCase

@end

@implementation ServiceRequestTests

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

- (void)testLoginService{
    
    ConasysRequestManager *requestManager = [ConasysRequestManager sharedConasysRequestManager];
    
    NSString *username = @"testbuilder";
    NSString *password = @"Buildteam";
    [requestManager loginUser:[NSMutableDictionary dictionaryWithObjectsAndKeys:username, LOGIN_USERNAME_KEY, password, LOGIN_PASSWORD_KEY, nil]  completionHandler:^(id response, NSError *error, BOOL result) {
        
        if (result) {
            
            XCTAssertTrue(YES, @"Valid credentials");
        }
        else{
            
            XCTFail(@"Invalid credentials");
        }
        
    }];
}


- (void)testProjectService{
    
    ConasysRequestManager *requestManager = [ConasysRequestManager sharedConasysRequestManager];
    
    [requestManager getAllProjectList:[NSMutableDictionary dictionaryWithObjectsAndKeys:CURRENT_USER_TOKEN, BUILDER_API_TOKEN_KEY, CURRENT_USERNAME, BUILDER_API_USERNAME_KEY, nil]  completionHandler:^(id response, NSError *error, BOOL result) {
        
        if (result) {
            
            XCTAssertTrue(YES, @"Request succeeds");
        }
        else{
            
            XCTFail(@"Request fails");
        }
        
    }];
}


@end
