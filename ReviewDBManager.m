//
//  ReviewDBManager.m
//  Conasys
//
//  Created by user on 7/7/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ReviewDBManager.h"
#import "ReviewOwnerDatabase.h"
#import "ReviewDatabase.h"


@implementation ReviewDBManager


static ReviewDBManager *reviewDBManager = nil;

+ (id)sharedManager{
    
    if (!reviewDBManager) {
        
        reviewDBManager = [[ReviewDBManager alloc] init];
    }
    return reviewDBManager;
}



- (void)insertIntoReviewTable:(Review *)review{
    
    
    long long rowId = [[ReviewDatabase sharedDatabase] insertReview:review];

    ReviewOwnerDatabase *reviewOwnerDatabase = [ReviewOwnerDatabase sharedDatabase];
    for (ReviewOwner *reviewOwner in review.reviewOwners) {
        
        reviewOwner.reviewRowId = rowId;
        [reviewOwnerDatabase insertIntoReviewOwnerTable:reviewOwner];
    }
    
}



- (NSMutableArray *)getAllSubmittedReviews{
    
    return [[ReviewDatabase sharedDatabase] getAllSubmittedReviews];
}



- (void)deleteReview:(int)reviewRowId{
    
    [[ReviewDatabase sharedDatabase] deleteReview:reviewRowId];
}


- (void)deleteExecutedReviews{
    
    [[ReviewDatabase sharedDatabase] deleteExecutedReviews];
}


- (void)updateReview:(Review *)review{
    
    [[ReviewDatabase sharedDatabase] updateReview:review];
}

@end
