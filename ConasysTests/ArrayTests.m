//
//  ArrayTests.m
//  Conasys
//
//  Created by user on 8/26/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSMutableArray+NullHandler.h"

@interface ArrayTests : XCTestCase

@end

@implementation ArrayTests

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


- (void)testArrayCount{
    NSArray *arr = [NSArray arrayWithObjects:@"Evon",@"Dehradun",@"Clock Tower",@"60/61",nil];
    int indexCount = 3;
    if ([arr count]>indexCount) {
        XCTAssertNotNil( [arr objectAtIndex:indexCount], @"array not out of bound");
    }
    else{
        XCTFail(@"out of bound");
    }
}




- (void)testArrayExist{
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:@"evon", @"dehradun", nil];
    XCTAssertTrue([array isArrayExist], @"Array exist or not null");
}


- (void)testArrayNotExist{
    
    NSMutableArray *array = nil;
    XCTAssertTrue(![array isArrayExist], @"Array doesn't exist or null");
}


- (void)testArraySorting{
    
    NSArray *jumbledArray = [NSArray arrayWithObjects:@"2",@"1",@"3", nil];
    NSArray *sortedArray = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
    
   jumbledArray = [jumbledArray sortedArrayUsingComparator:^(NSString *firstObject, NSString *secondObject) {
        
        return [firstObject compare:secondObject options:NSRegularExpressionSearch];
    }];
    
    XCTAssertEqualObjects(jumbledArray, sortedArray, @"array sorted");
}

@end
