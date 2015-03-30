//
//  OwnerDBManager.m
//  Conasys
//
//  Created by user on 6/9/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "OwnerDBManager.h"
#import "Owner.h"
#import "OwnerDataBase.h"

@implementation OwnerDBManager


static OwnerDBManager *ownerDBManager = nil;


+ (id)sharedManager{
    
    if (!ownerDBManager) {
        
        ownerDBManager = [[OwnerDBManager alloc] init];
    }
    return ownerDBManager;
}

- (void)saveOwnerToDB:(NSMutableArray *)ownerArray{
    
    OwnerDataBase *ownerDataBase = [OwnerDataBase sharedDatabase];
    
    for (Owner *owner in ownerArray) {
        
        [ownerDataBase insertIntoOwnerTable:owner];
        
    }
}


- (NSMutableArray *)getAllOwnersForUnit:(NSString *)unitId{
    
    OwnerDataBase *ownerDataBase = [OwnerDataBase sharedDatabase];
    
    return [ownerDataBase getAllOwnersForUnit:unitId];
}


- (void)updateOwner:(NSMutableArray *)ownerArray
{
    
    OwnerDataBase *ownerDataBase = [OwnerDataBase sharedDatabase];
    
    for (Owner *owner in ownerArray)
    {
        
        [ownerDataBase updateIntoOwnerTable:owner];
        
    }
}


- (Owner *)lastInsertedOwner{
    
    return [[OwnerDataBase sharedDatabase] getLastOwnerInserted];
}


- (Owner *)getOwnerFromId:(int)ownerRowId{
    
    return [[OwnerDataBase sharedDatabase] getOwnerForOwnerId:ownerRowId];
}


- (NSMutableArray *)allOfflineOwners{
    
    return [[OwnerDataBase sharedDatabase] allOfflineOwners];
}


- (int)sycingOwnerCount{
    
    return [[OwnerDataBase sharedDatabase] sycingOwnerCount];
}

@end
