//
//  UnitsDBManager.h
//  Conasys
//
//  Created by user on 6/9/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseDBManager.h"
#import "Unit.h"

@interface UnitsDBManager : BaseDBManager


- (void)saveUnitsToDB:(NSMutableArray *)unitsArray;

- (NSMutableArray *)getAllUnitsForProject:(NSString *)projectId;

- (void)updateUnit:(Unit *)unit;

- (Unit *)getUnitForUnitRowId:(int)unitsRowId;

- (int)getPendingUnitsCountForProject:(NSString *)projectId;

- (NSMutableArray *)getAllUnitIdsForProjectId:(NSString *)projectId;

- (int)getAllPendingUnitsCount:(NSString *)userId;
@end
