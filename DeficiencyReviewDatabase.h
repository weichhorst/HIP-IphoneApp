//
//  DeficiencyReviewDatabase.h
//  Conasys
//
//  Created by user on 8/1/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Database.h"
#import "DeficiencyReview.h"

@interface DeficiencyReviewDatabase : Database

+ (id)sharedDatabase;

- (long long)insertDeficiencyReview:(DeficiencyReview *)review;

- (NSMutableArray *)getAllDeficiencyReviews;

- (DeficiencyReview *)getDeficiencyReviewForUnit:(NSString *)unitId;

- (void)deleteDeficiencyReview:(int)reviewRowId;

- (void)deleteExecutedDeficiencyReviews;

- (void)updateDeficiencyReview:(DeficiencyReview *)review;

- (void)deleteDeficiencyReviewForUnit:(NSString *)unitId;

- (int)pendingProjectsForUser:(NSString *)userId;

@end
