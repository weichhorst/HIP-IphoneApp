//
//  DeficiencyReview.h
//  Conasys
//
//  Created by user on 8/1/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseModel.h"
#import "BuilderUser.h"
#import "Project.h"
#import "Unit.h"
#import "Service.h"
//#import "ReviewItem.h"

@interface DeficiencyReview : BaseModel

@property (nonatomic, readwrite)int reviewRowId;
@property (nonatomic, retain)NSString *userId;
@property (nonatomic, readwrite)NSString *unitId;
@property (nonatomic, retain)NSString *performedBySignature;
@property (nonatomic, retain)NSString *developerSignature;
@property (nonatomic, retain)NSString *developerName;
@property (nonatomic, readwrite)int isPending;

@property (nonatomic, retain)NSString *performedByEmail;
@property (nonatomic, retain)NSString *performedByName;
@property (nonatomic, retain)NSString *reviewInitiationTimeStamp;
@property (nonatomic, retain)NSString * ownerNextTimeStamp;
@property (nonatomic, retain)NSString * itemNextTimeStamp;
@property (nonatomic, retain)NSString * confirmationSubmitTimestamp;
@property (nonatomic, retain)NSString * additionalComments;

@property (nonatomic, readwrite)int lastPageNumber;
@property (nonatomic, readwrite)int selectedServiceTypeIndex;

@property (nonatomic, readwrite)int isUploaded;
@property (nonatomic, retain)NSString *possessionDate;
@property (nonatomic, retain)NSString *unitEnrolmentPolicy;
@property (nonatomic, retain)NSString *serviceTypeId;

//MUTABLE ARRAYS

@property (nonatomic, retain)NSMutableArray *deficienceyReviewItems;
@property (nonatomic, retain)NSMutableArray *reviewOwners;
@property (nonatomic, readwrite)BOOL isPDI;
@property (nonatomic, readwrite)BOOL isSyncing;

//15-sept-2014
@property (nonatomic, retain)BuilderUser *builderUser;

@end
