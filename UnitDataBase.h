//
//  UnitDataBase.h
//  Conasys
//
//  Created by user on 6/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Database.h"
#import "Unit.h"

@interface UnitDataBase : Database

+ (id)sharedDatabase;

- (void)insertIntoUnitTable:(Unit *)unit;

- (NSMutableArray *)getAllUnitsForProject:(NSString *)projectId;

- (Unit *)getUnitForUnitId:(NSString *)unitId;

- (void)updateUnit:(Unit *)unit;
- (void)deleteUnit:(Unit *)unit;
- (void)deleteAllUnits:(NSString *)projectId;
- (int)getPendingUnitsCountForProject:(NSString *)projectId;
- (int)getLocationRowIdForOtherLocation:(NSString *)UnitId;
- (NSMutableArray *)getAllUnitIdsForProjectId:(NSString *)projectId;

- (int)getAllPendingUnitsCount:(NSString *)userId;

@end
