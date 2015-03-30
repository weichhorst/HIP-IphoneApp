//
//  UnitsDBManager.m
//  Conasys
//
//  Created by user on 6/9/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "UnitsDBManager.h"
#import "UnitDataBase.h"
#import "OwnerDBManager.h"
#import "LocationDBManager.h"

@implementation UnitsDBManager

static UnitsDBManager *unitsDBManager = nil;


+ (id)sharedManager{
    
    if (!unitsDBManager) {
        
        unitsDBManager = [[UnitsDBManager alloc] init];
    }
    return unitsDBManager;
}


- (void)saveUnitsToDB:(NSMutableArray *)unitsArray{
    
    
    UnitDataBase *unitDataBase = [UnitDataBase sharedDatabase];
    
    OwnerDBManager * ownerDBManager = [OwnerDBManager sharedManager];
    
    LocationDBManager *locationDBManager =[LocationDBManager sharedManager];
    
    for (Unit *unit in unitsArray) {

        
        [unitDataBase insertIntoUnitTable:unit];
        
        [locationDBManager saveLocationToDB:unit.locationList];
        
        [ownerDBManager saveOwnerToDB:unit.ownersList];
        
    }
}


- (NSMutableArray *)getAllUnitsForProject:(NSString *)projectId
{
    
    UnitDataBase *unitDataBase = [UnitDataBase sharedDatabase];
    
    return [unitDataBase getAllUnitsForProject:projectId];
}


- (void)updateUnit:(Unit *)unit{
    
    [[UnitDataBase sharedDatabase] updateUnit:unit];
}

- (Unit *)getUnitForUnitRowId:(int)unitsRowId{
    
    return [[UnitDataBase sharedDatabase] getUnitForUnitRowId:unitsRowId];
}

- (int)getPendingUnitsCountForProject:(NSString *)projectId{
    
    return [[UnitDataBase sharedDatabase] getPendingUnitsCountForProject:projectId];
}

- (NSMutableArray *)getAllUnitIdsForProjectId:(NSString *)projectId{
    
    return [[UnitDataBase sharedDatabase] getAllUnitIdsForProjectId:projectId];
}

- (int)getAllPendingUnitsCount:(NSString *)userId;
{
    return [[UnitDataBase sharedDatabase] getAllPendingUnitsCount:userId];
}

@end
