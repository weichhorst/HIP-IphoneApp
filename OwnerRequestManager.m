//
//  OwnerRequestManager.m
//  Conasys
//
//  Created by user on 6/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "OwnerRequestManager.h"

@implementation OwnerRequestManager

#define OWNER_REQUEST @"RegisterOwner"
#define EDIT_OWNER_REQUEST @"EditRegisterOwner"

+(id)registerNewOwner:(NSMutableDictionary *)dict completionHandler:(void (^)(id, NSError *, BOOL))block{
    
    id request = [self getRequestForURL:URL_REGISTER_OWNER requestName:OWNER_REQUEST infoDict:dict];
    [request setCallBackBlock:block];
    return request;
}

+(id)editOwner:(NSMutableDictionary *)dict completionHandler:(void (^)(id, NSError *, BOOL))block{
    
    id request = [self getRequestForURL:URL_EDIT_OWNER requestName:EDIT_OWNER_REQUEST infoDict:dict];
    [request setCallBackBlock:block];
    return request;
}


// Processing the response got from server and calling the completion handler.
- (void)processTheResponse{
    
    
    NSDictionary *dict = [self validateResponse];
    
    if (dict && [self isValidRequest]) {
        
        self.callBackBlock(dict, nil, YES);
    }
    else if (dict){
        
        self.callBackBlock(dict, nil, NO);
    }
    else{
        
        self.callBackBlock(nil, nil, NO);
    }
}


- (void)processFailed{
    
    self.callBackBlock(nil, error, NO);
}
@end
