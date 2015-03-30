//
//  ReviewOwner.h
//  Conasys
//
//  Created by user on 8/1/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseModel.h"
#import "Owner.h"

@interface ReviewOwner : BaseModel


@property (nonatomic, readwrite)long long reviewOwnerRowId;
@property (nonatomic, retain)NSString *printName;
@property (nonatomic, retain)NSString *ownerSignature;
@property (nonatomic, readwrite)int isSelectedOwner;
@property (nonatomic, readwrite)int reviewRowId;
@property (nonatomic, readwrite)int ownerRowId;
@property (nonatomic, retain)Owner *owner;
@property (nonatomic, retain)NSString *userName;
@property (nonatomic, retain)NSString *email;

@end
