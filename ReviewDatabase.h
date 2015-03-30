//
//  ReviewDatabase.h
//  Conasys
//
//  Created by user on 7/7/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Database.h"
#import "Review.h"

@interface ReviewDatabase : Database


+ (id)sharedDatabase;

- (long long)insertReview:(Review *)review;
- (NSMutableArray *)getAllSubmittedReviews;
- (void)deleteReview:(int)reviewRowId;
- (void)deleteExecutedReviews;
- (void)updateReview:(Review *)review;
@end
