//
//  ReviewUploader.m
//  Conasys
//
//  Created by user on 7/14/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ReviewUploader.h"
#import "DeficiencyReviewDatabase.h"
#import "DeficiencyReview.h"
#import "ReviewItem.h"
#import "ReviewItemImage.h"
#import "ReviewOwner.h"
#import "AppDelegate.h"
#import "DateFormatter.h"
#import "ifaddrs.h"
#import "OwnerUploader.h"

@implementation ReviewUploader

static ReviewUploader *reviewUploader = nil;

- (BOOL)isVPNConnected
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            NSString *string = [NSString stringWithFormat:@"%s" , temp_addr->ifa_name];
            if ([string rangeOfString:@"tap"].location != NSNotFound ||
                [string rangeOfString:@"tun"].location != NSNotFound ||
                [string rangeOfString:@"ppp"].location != NSNotFound){
                return YES;
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    return NO;
}


// Function will check for pending reviews and will get them uploaded
- (void)checkAndUploadReviews{
    

    [[[OwnerUploader alloc]init] checkAndUploadOwnersWithCompletionBlock:^(id data, BOOL result) {
        
        [self uploadReviewsNow];
    }];
}


- (void)uploadReviewsNow{
    
    [[DeficiencyReviewDatabase sharedDatabase] deleteExecutedDeficiencyReviews];
    
    NSMutableArray *submittedReviews = [[DeficiencyReviewDatabase sharedDatabase] getAllDeficiencyReviews];
    
    NSLog(@"submitted reviews count== %d", submittedReviews.count);
    
    for (DeficiencyReview *deficiencyReview in submittedReviews) {
        
        deficiencyReview.isSyncing = YES;
        
        [[DeficiencyReviewDatabase sharedDatabase] updateDeficiencyReview:deficiencyReview];
        
        [[ConasysRequestManager sharedConasysRequestManager] submitReview:[self getDictForDeficiencyReview:deficiencyReview] completionHandler:^(id response, NSError *error, BOOL result) {
            if (result) {
                
                deficiencyReview.isUploaded = YES;
                
                [[BuilderUsersDB sharedDatabase]updateBuilderLastSyncDate:deficiencyReview.userId]; // updating last sync date for user.
                
                AppDelegate *delegate = DELEGATE;
                
                [[DeficiencyReviewDatabase sharedDatabase] updateDeficiencyReview:deficiencyReview];
                [[DeficiencyReviewDatabase sharedDatabase] deleteDeficiencyReview:deficiencyReview.reviewRowId];
                
                if ([delegate.currentBuilder.userId isEqualToString:deficiencyReview.userId]) {
                    
                    delegate.currentBuilder.lastSyncDate = [[DateFormatter sharedFormatter]getSyncStringFromDate:[NSDate date]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:SYNC_UPDATE_NOTIFICATION object:nil];
                }
                
            }
            else{
                
                deficiencyReview.isSyncing = NO;
                deficiencyReview.isUploaded = NO;
                [[DeficiencyReviewDatabase sharedDatabase] updateDeficiencyReview:deficiencyReview];
            }
        }];
    }
}

- (NSMutableDictionary *)getDictForDeficiencyReview:(DeficiencyReview *)deficiencyReview{
    
    
    NSMutableDictionary *dictionary =  [self getMainDict:deficiencyReview];
    
    NSMutableArray *itemListArray = [NSMutableArray new];
    
    for (ReviewItem *reviewItem in deficiencyReview.deficienceyReviewItems) {
        
        NSMutableArray *imageArray = [NSMutableArray new];
        
        for (ReviewItemImage *reviewItemImage in reviewItem.reviewItemImages) {
            
            [imageArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:reviewItemImage.base64String, @"ImageStream",@"image.png", @"ImageName", nil]];
            
        }
        
        NSMutableDictionary *itemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:reviewItem.itemDescription, @"Description", reviewItem.itemLocation ,@"Location", reviewItem.productId, @"ProductId", imageArray, @"Files", nil];
        
        [itemListArray addObject:itemDict];
    }
    
    NSMutableArray *ownersArray = [NSMutableArray new];
    
    if (!deficiencyReview.isPDI) {
        
        goto here;
    }
    
    for (ReviewOwner *reviewOwner in deficiencyReview.reviewOwners) {
        
        if (reviewOwner.isSelectedOwner) {
            
            [ownersArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:reviewOwner.userName, @"userName", reviewOwner.ownerSignature, @"signatureImage", reviewOwner.printName, @"printName",reviewOwner.email, @"userEmail", nil]];
        }
    }
    
here:
    [dictionary setObject:ownersArray forKey:@"IncludeOwnerList"];
    
    [dictionary setObject:itemListArray forKey:@"ItemList"];
    
    return dictionary;
}


// creating the dictionary to be uploaded.
- (NSMutableDictionary *)getMainDict:(DeficiencyReview *)deficiencyReview{
    
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:deficiencyReview.isPDI?@"false":@"true", @"IsConstructionReview", deficiencyReview.builderUser.username, @"BuilderUserName", deficiencyReview.unitId, @"UnitId", deficiencyReview.builderUser.userToken, @"AuthanticationToken", deficiencyReview.performedByName,@"PerformedByName",deficiencyReview.performedByEmail, @"PerformedByEmail", deficiencyReview.performedBySignature, @"PerformedBySignature", deficiencyReview.additionalComments, @"AdditionalComments", deficiencyReview.unitEnrolmentPolicy, @"UnitEnrolmentNo", deficiencyReview.possessionDate, @"PossessionDate", deficiencyReview.serviceTypeId, @"ServiceTypeId", deficiencyReview.reviewInitiationTimeStamp, @"ReviewInitiationTimeStamp", deficiencyReview.ownerNextTimeStamp, @"OwnerNextTimeStamp", deficiencyReview.itemNextTimeStamp, @"ItemNextTimeStamp", deficiencyReview.confirmationSubmitTimestamp, @"ConfirmationSubmitTimestamp",  deficiencyReview.developerName, @"DeveloperPrintName", deficiencyReview.developerSignature, @"DeveloperSignImage",nil];
}



@end
