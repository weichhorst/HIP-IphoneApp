//
//  ReviewItemDatabase.h
//  Conasys
//
//  Created by user on 8/4/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Database.h"
#import "ReviewItem.h"

@interface ReviewItemDatabase : Database


- (void)insertIntoReviewItemTable:(ReviewItem *)reviewItem;
- (void)updateReviewItem:(ReviewItem *)reviewItem;
- (NSMutableArray *)getAllReviewItemsForReview:(int)reviewRowId;
- (ReviewItem *)getLastInsertedReviewItem;
- (void)deleteReviewItem:(ReviewItem *)reviewItem;
- (void)switchPragmaOn;

@end
