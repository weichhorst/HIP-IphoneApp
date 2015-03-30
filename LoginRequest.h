//
//  LoginRequest.h
//  Conasys
//
//  Created by user on 4/24/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ConasysBaseRequest.h"

@interface LoginRequest : ConasysBaseRequest


+(id)loginWithDetails:(NSMutableDictionary *)dict completionHandler:(void (^)(id response,NSError* error, BOOL result))block;

- (void)processTheResponse;
- (void)processFailed;

@end
