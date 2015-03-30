//
//  ConasysRequestManager.h
//  Conasys
//
//  Created by user on 4/25/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeaderFiles.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface ConasysRequestManager : NSObject


typedef void(^CompletionBlock)(id response,NSError* error, BOOL result);

+ (ConasysRequestManager *)sharedConasysRequestManager;


- (void)loginUser:(NSMutableDictionary *)userInfo completionHandler:(CompletionBlock)block;


- (void)getAllProjectList:(NSMutableDictionary *)userInfo completionHandler:(CompletionBlock)block;

- (void)registerOwnerWithDetails:(NSMutableDictionary *)userInfo completionHandler:(CompletionBlock)block;

- (void)editOwnerWithDetails:(NSMutableDictionary *)userInfo completionHandler:(CompletionBlock)block;

- (void)submitReview:(NSMutableDictionary *)dict completionHandler:(void (^)(id response,NSError* error, BOOL result))block;

@end
