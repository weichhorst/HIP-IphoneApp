//
//  SubmitRequestManager.m
//  Conasys
//
//  Created by user on 7/7/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "SubmitRequestManager.h"

@implementation SubmitRequestManager

#define SUBMIT_REQUEST @"SubmitReview"


+(id)submitReviewToServer:(NSMutableDictionary *)dict completionHandler:(void (^)(id response,NSError* error, BOOL result))block{
    
    id request = [self getRequestForURL:URL_SUBMIT_REVIEW requestName:SUBMIT_REQUEST infoDict:dict];
    [request setCallBackBlock:block];
    return request;
}


- (void)processTheResponse{
    
    NSDictionary *dict = [self validateResponse];
    
    if (dict && [self isValidRequest]) {
        
        NSLog(@"IF processTheResponse");
        self.callBackBlock(dict, nil, YES);
    }
    else{
        
        NSLog(@"ELSE processTheResponse");
        self.callBackBlock(nil, nil, NO);
    }
}


- (void)processFailed{
    
    NSLog(@"processFailed");
    self.callBackBlock(nil, nil, NO);
}


@end
