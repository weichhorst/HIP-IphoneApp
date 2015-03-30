//
//  SubmitRequestManager.h
//  Conasys
//
//  Created by user on 7/7/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ConasysBaseRequest.h"

@interface SubmitRequestManager : ConasysBaseRequest

//- (void)submitReviewToServer:(NSString *

+(id)submitReviewToServer:(NSMutableDictionary *)dict completionHandler:(void (^)(id response,NSError* error, BOOL result))block;

- (void)processTheResponse;

- (void)processFailed;


@end
