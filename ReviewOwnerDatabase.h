//
//  ReviewOwnerDatabase.h
//  Conasys
//
//  Created by user on 7/7/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Database.h"
#import "ReviewOwner.h"

@interface ReviewOwnerDatabase : Database

+ (id)sharedDatabase;


- (void)insertIntoReviewOwnerTable:(ReviewOwner *)review;
- (NSMutableArray *)getAllReviewOwnersForReviewId:(int)reviewRowId;
- (void)deleteReviewOwners:(int)reviewId;
- (void)updateReviewOwnerTable:(ReviewOwner *)reviewOwner;

@end
