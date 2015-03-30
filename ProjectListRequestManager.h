//
//  ProjectListRequestManager.h
//  Conasys
//
//  Created by user on 6/4/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ConasysBaseRequest.h"

@interface ProjectListRequestManager : ConasysBaseRequest


+(id)getAllProjectsList:(NSMutableDictionary *)dict completionHandler:(void (^)(id response,NSError* error, BOOL result))block;

- (void)processTheResponse;
- (void)processFailed;


@end
