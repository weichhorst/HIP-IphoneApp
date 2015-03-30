//
//  OwnerRequestManager.h
//  Conasys
//
//  Created by user on 6/16/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ConasysBaseRequest.h"

@interface OwnerRequestManager : ConasysBaseRequest

+(id)registerNewOwner:(NSMutableDictionary *)dict completionHandler:(void (^)(id response,NSError* error, BOOL result))block;

+(id)editOwner:(NSMutableDictionary *)dict completionHandler:(void (^)(id, NSError *, BOOL))block;

- (void)processTheResponse;
- (void)processFailed;
@end
