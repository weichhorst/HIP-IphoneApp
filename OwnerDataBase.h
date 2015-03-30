//
//  OwnerDataBase.h
//  Conasys
//
//  Created by user on 6/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Database.h"
#import "Owner.h"

@interface OwnerDataBase : Database


+ (id)sharedDatabase;

- (void)insertIntoOwnerTable:(Owner *)owner;
- (NSMutableArray *)getAllOwnersForUnit:(NSString *)unitId;

- (Owner *)getOwnerForOwnerId:(int)ownerId;

- (Owner *)getLastOwnerInserted;
- (void)updateIntoOwnerTable:(Owner *)owner;

- (NSMutableArray *)allOfflineOwners;
- (int)sycingOwnerCount;

//- (void)deleteOwner:(Owner *)owner;
//- (void)deleteAllOwners:(NSString *)unitId;

@end
