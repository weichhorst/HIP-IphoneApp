//
//  OwnerDBManager.h
//  Conasys
//
//  Created by user on 6/9/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseDBManager.h"
#import "Owner.h"

@interface OwnerDBManager : BaseDBManager


- (void)saveOwnerToDB:(NSMutableArray *)ownerArray;

- (NSMutableArray *)getAllOwnersForUnit:(NSString *)unitId;

- (void)updateOwner:(NSMutableArray *)ownerArray;

- (Owner *)lastInsertedOwner;

- (Owner *)getOwnerFromId:(int)ownerRowId;

- (NSMutableArray *)allOfflineOwners;

- (int)sycingOwnerCount;

@end
