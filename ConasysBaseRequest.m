//
//  ConasysBaseRequest.m
//  Conasys
//
//  Created by user on 4/24/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ConasysBaseRequest.h"
#import "JSON.h"

@implementation ConasysBaseRequest

#define TIME_OUT_SECONDS 3600

#define REQUEST_METHOD @"POST"


// Function return request object with all parameters set.

+ (id)getRequestForURL:(NSString*)urlString requestName:(NSString *)reqName infoDict:(NSMutableDictionary *)dict
{
    
    id request = [self requestWithURL:[NSURL URLWithString:urlString]];
    
//#if DEBUGGIN_ON
//    
    NSLog(@"postdict is====== %@, request name==%@, urlstring==%@",dict, reqName, urlString);
//#endif
    
    NSDictionary *temp = [NSDictionary dictionaryWithObject:reqName forKey:@"RequestName"];
    
    [request setDelegate:self];
    
    [request setUserInfo:temp];
    
    [request addRequestHeader:@"Content-Type" value:@"application/json"];

    [request appendPostData:[NSMutableData dataWithData:[dict.JSONRepresentation dataUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setTimeOutSeconds:TIME_OUT_SECONDS];
    [request setRequestMethod:REQUEST_METHOD];
    return request;
}


// Processing the response got from server.
- (void)processTheResponse{
    
}

- (void)processFailed{
    
    
}

// This will validate and check and return the response.

- (id)validateResponse{
    
    NSLog(@"Processing the response ===%@", self.responseData);
    if (!self.responseData) {
        
        return nil;
    }
    
//#if DEBUGGIN_ON
//    
    NSLog(@"RESPONSE JSON STRING IS== %@", self.responseString);
//#endif
    return self.responseString.JSONValue;
}


- (BOOL)isValidRequest{
    NSDictionary *dict = [self.responseString JSONValue];

    BOOL status = (BOOL)[[[dict objectForKey:RESPONSE_RESULT_MESSAGE] objectForKey:RESPONSE_Status]integerValue];
    NSLog(@"smit app dir: %@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
    if (status) {
        
        return YES;
    }

    return NO;
}


@end
