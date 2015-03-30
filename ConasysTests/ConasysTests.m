//
//  ConasysTests.m
//  ConasysTests
//
//  Created by user on 4/24/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Utility.h"
#import "UserDefaults.h"
#import "NSData+Base64.h"
#import "DateFormatter.h"

@interface ConasysTests : XCTestCase

@end

@implementation ConasysTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testPositive
{
    int a=10;
    int b=20;
    int c=20;
    XCTAssertEqual(b,c, @"values are equal");
    XCTAssertNotEqual(a, b, @"Values are different");
}


- (void)testEmailValidation{
    
    NSString *email = @"sandeep@gmail.com";
    XCTAssertTrue([Utility validateEmail:email], @"Email valid");
}


- (void)testEmailFailure{
    
    NSString *email = @"sandeepmail.com";
    XCTAssertFalse([Utility validateEmail:email], @"Invalid Email");

}


- (void)testNetwork{
    
    XCTAssertTrue([Utility isNetworkAvailble], @"Network is available");
}


- (void)testIfOSVersion7{
    
    XCTAssertTrue([Utility isiOSVersion7], @"Version 7 or later");
}


- (void)testIfOSVersion6{
    
    XCTAssertTrue([Utility isiOSVersion6], @"Version 6 or earlier");
}


- (void)testUserDefaultSuccess{
    
    NSString *key = @"myTestingKey";
    [UserDefaults saveObject:@"test" forKey:key];
    XCTAssertEqual(@"test", [UserDefaults valueForKey:key], @"Values are equal");
}

- (void)testUserDefaultFailure{
    
    NSString *key = @"myTestingKey";
    [UserDefaults saveObject:@"testing" forKey:key];
    [UserDefaults removeValueForKey:key];
    XCTAssertNil([UserDefaults valueForKey:key], @"nil value");
}

- (void)testOrientation{
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        XCTAssertTrue(YES, @"Orientation is Portrait");
    }
    else{
        
        XCTFail(@"Orientation is Landscape");
    }
}


- (void)testDataTo64String{
    
    
    NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"AppIcon72x72.png"], 1.0);
    
    NSString *string = [data base64EncodedString];
    
    if (string && string.length) {
        
        XCTAssertTrue(YES, @"Conversion Successful");
    }
    else{
        
        XCTFail(@"Conversion Failed");
    }
}


- (void)testStringFromDate{
    
    
    NSString *string = [[DateFormatter sharedFormatter] getStringFromDate:[NSDate date]];
    
    if (string && string.length) {
        
        XCTAssertTrue(YES, @"Valid Date");
    }
    else{
        
        XCTFail(@"Date invalid or nil");
    }
}

@end
