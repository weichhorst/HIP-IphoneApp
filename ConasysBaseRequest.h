//
//  ConasysBaseRequest.h
//  Conasys
//
//  Created by user on 4/24/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "HeaderFiles.h"
#import "ResponseKeys.h"
                                        

@interface ConasysBaseRequest : ASIFormDataRequest



@property (copy,nonatomic) void(^callBackBlock)(id response,NSError* error, BOOL result);

+ (id)getRequestForURL:(NSString*)urlString requestName:(NSString *)reqName infoDict:(NSMutableDictionary *)dict;

- (id)validateResponse;

- (void)processTheResponse;

- (void)processFailed;

- (BOOL)isValidRequest;

@end
