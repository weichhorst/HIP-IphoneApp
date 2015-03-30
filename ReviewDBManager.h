//
//  ReviewDBManager.h
//  Conasys
//
//  Created by user on 7/7/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ConasysBaseRequest.h"
#import "Review.h"

@interface ReviewDBManager : ConasysBaseRequest

+ (id)sharedManager;

- (void)insertIntoReviewTable:(Review *)review;
- (NSMutableArray *)getAllSubmittedReviews;
- (void)deleteReview:(int)reviewRowId;

- (void)deleteExecutedReviews;
- (void)updateReview:(Review *)review;


@end
