//
//  ReviewUploader.h
//  Conasys
//
//  Created by user on 7/14/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConasysRequestManager.h"


@interface ReviewUploader : NSObject

//+(id)sharedUploader;

- (void)checkAndUploadReviews;
//- (void)removeData:(Review *)review;
//- (NSMutableDictionary *)getTheDictForReview:(Review *)review;

@end
