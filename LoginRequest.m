//
//  LoginRequest.m
//  Conasys
//
//  Created by user on 4/24/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest

#define LOGIN_REQUEST @"login"


// Returns login request to be processed by ConasysRequestManager.
+(id)loginWithDetails:(NSMutableDictionary *)dict completionHandler:(void(^)(id response,NSError* error, BOOL result))block{
    
    id request = [self getRequestForURL:URL_LOGIN requestName:LOGIN_REQUEST infoDict:dict];
    [request setCallBackBlock:block];
    return request;
}


// Processing the response got from server and calling the completion handler.
- (void)processTheResponse{
    
    NSDictionary *dict = [self validateResponse];
    if (dict && [self isValidRequest]) {
        
        self.callBackBlock(dict, nil, YES);
    }
    else{
        
        self.callBackBlock(nil, nil, NO);
    }
}

- (void)processFailed{
    
    self.callBackBlock(nil, nil, NO);
}

@end