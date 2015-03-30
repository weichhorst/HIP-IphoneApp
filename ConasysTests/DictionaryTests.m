//
//  DictionaryTests.m
//  Conasys
//
//  Created by user on 8/26/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDictionary+NSNullHandler.h"

@interface DictionaryTests : XCTestCase

@end

@implementation DictionaryTests

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


- (void)testDictionaryValue{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"sandeep", @"evon", nil];
    
    if ([dict objectForKey:@"evon"]) {
        
        XCTAssertNotNil([dict objectForKey:@"evon"], @"Value is not nil");
    }
    
}


- (void)testDictionaryValueNotExist{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"test", @"evon", nil];
    
    XCTAssertNil([dict objectForKey:@"test123"], @"Value Not Exist");
}


- (void)testDictionaryExist{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"test", @"evon", nil];
    XCTAssertTrue([dict isDictionaryExist], @"Dictionary not nil");
}


- (void)testDictionaryNotExist{
    
    NSDictionary *dict = nil;
    XCTAssertFalse([dict isDictionaryExist], @"Dictionary not exist");
}

@end
