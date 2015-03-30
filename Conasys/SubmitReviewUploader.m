//
//  SubmitReviewUploader.m
//  Conasys
//
//  Created by user on 7/25/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "SubmitReviewUploader.h"

#import "DeficiencyReviewDatabase.h"
#import "BuilderUser.h"
#import "DateFormatter.h"
#import "OwnerUploader.h"

@implementation SubmitReviewUploader


- (void)uploadReviewInBackground:(NSMutableDictionary *)dict{
    
    
    [[[OwnerUploader alloc]init] checkAndUploadOwnersWithCompletionBlock:^(id data, BOOL result) {
        
        [self uploadReviewsNow:dict];

    }];
}

- (void)uploadReviewsNow:(NSMutableDictionary *)dict{
    
    
    [[ConasysRequestManager sharedConasysRequestManager] submitReview:dict completionHandler:^(id response, NSError *error, BOOL result) {
        if (result) {
            
            AppDelegate *delegate =  DELEGATE;
            delegate.currentBuilder.lastSyncDate = [[DateFormatter sharedFormatter]getSyncStringFromDate:[NSDate date]];
            
            [[BuilderUsersDB sharedDatabase]updateBuilderLastSyncDate:self.currentDeficiencyReview.userId];
            
            [[DeficiencyReviewDatabase sharedDatabase] deleteDeficiencyReview:self.currentDeficiencyReview.reviewRowId];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_UPDATE_NOTIFICATION object:nil];
            
        }
        else{
            
            self.currentDeficiencyReview.isSyncing = NO;
            [[DeficiencyReviewDatabase sharedDatabase]updateDeficiencyReview:self.currentDeficiencyReview];
        }
    }];
}


@end
