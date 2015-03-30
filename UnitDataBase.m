//
//  UnitDataBase.m
//  Conasys
//
//  Created by user on 6/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "UnitDataBase.h"

#import "OwnerDBManager.h"
#import "LocationDBManager.h"

@implementation UnitDataBase


static Database *sharedDatabase = nil;

+ (id)sharedDatabase{
    
    if (!sharedDatabase) {
        sharedDatabase = [[self alloc] init];
        
        [sharedDatabase createDb:sharedDatabase];
        [sharedDatabase customInit];
        
    }
    return sharedDatabase;
}




static sqlite3_stmt *insertUnitStatement;
static sqlite3_stmt *getAllUnitsStatement;
static sqlite3_stmt *deleteUnitStatement;
static sqlite3_stmt *deleteAllUnitsStatement;
static sqlite3_stmt *updateUnitStatement;
static sqlite3_stmt *getUnitForUnitId;
static sqlite3_stmt *countPendingUnitStatement;
static sqlite3_stmt *getAllUnitIdsStatement;
static sqlite3_stmt *countAllPendingUnitsStatement;
static sqlite3_stmt *getUnitIdForOtherFieldStatement;


// This method will initialiaze all sqlite statement(insertion, fetching, deletion) at once and can be used to perform DB Operations.
-(void)customInit {
    
    static const char *insertRecord = "Insert into Unit (unitId, address, completionDate, possessionDate, unitEnrollmentNumber, unitLegalDes, unitNumber, projectId) values (?, ?, ?, ?, ?, ?, ?, ?)";
    sqlite3_prepare_v2(self.connection, insertRecord, -1, &insertUnitStatement, NULL);
    
    static const char *getRecord = "SELECT * From Unit where projectId = ? order by address ASC, unitNumber ASC";
    sqlite3_prepare_v2(self.connection, getRecord, -1, &getAllUnitsStatement, NULL);
    
    
    static const char *getUnitFromId = "SELECT * From Unit where unitId = ?";
    sqlite3_prepare_v2(self.connection, getUnitFromId, -1, &getUnitForUnitId, NULL);
    
    static const char *getUnitIds = "SELECT unitId From Unit where projectId = ?";
    sqlite3_prepare_v2(self.connection, getUnitIds, -1, &getAllUnitIdsStatement, NULL);
    
    
    static const char *deleteRecord = "DELETE FROM Unit WHERE projectId = ? AND unitId = ?";
    sqlite3_prepare_v2(self.connection, deleteRecord, -1, &deleteUnitStatement, NULL);
    
    
    static const char *deleteStatement = "DELETE FROM Unit WHERE projectId = ?";
    sqlite3_prepare_v2(self.connection, deleteStatement, -1, &deleteAllUnitsStatement, NULL);
    
    static const char *updateStatement = "Update Unit set address=?, completionDate = ?, possessionDate = ?, unitEnrollmentNumber = ?, unitLegalDes = ?, isPendingUnit= ?, unitNumber=? where unitId = ?";
    sqlite3_prepare_v2(self.connection, updateStatement, -1, &updateUnitStatement, NULL);
    
    
    static const char *countUnits = "SELECT count(*) From Unit where isPendingUnit = ? and projectId = ?";
    sqlite3_prepare_v2(self.connection, countUnits, -1, &countPendingUnitStatement, NULL);
    
    static const char *countAllPendingUnits = "SELECT Count(*) FROM Unit U JOIN Project P ON U.projectId=P.projectId JOIN BuilderUser BR on P.userId=BR.userId where BR.userId=? and U.isPendingUnit=?";
    sqlite3_prepare_v2(self.connection, countAllPendingUnits, -1, &countAllPendingUnitsStatement, NULL);
	
	  static const char *getUnitIdForOtherFieldQuery ="SELECT * FROM Location where unitId = ? and  locationName = 'Other'";
	  sqlite3_prepare_v2(self.connection, getUnitIdForOtherFieldQuery, -1, &getUnitIdForOtherFieldStatement, NULL);

	
	
}

- (int)getAllPendingUnitsCount:(NSString *)userId
{
    int count = 0;
    
    sqlite3_bind_text(countAllPendingUnitsStatement, 1, [userId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(countAllPendingUnitsStatement, 2, 1);
    
    while (sqlite3_step(countAllPendingUnitsStatement)==SQLITE_ROW)
    {
        count =  sqlite3_column_int(countAllPendingUnitsStatement, 0);
    }
    
    sqlite3_reset(countAllPendingUnitsStatement);
    
    return count;
}

- (void)insertIntoUnitTable:(Unit *)unit{
    
    
    sqlite3_bind_text(insertUnitStatement, 1, [unit.unitId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertUnitStatement, 2, [unit.address UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertUnitStatement, 3, [unit.completionDate UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertUnitStatement, 4, [unit.possessionDate UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertUnitStatement, 5, [unit.unitEnrollmentNumber UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertUnitStatement, 6, [unit.unitLegalDes UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertUnitStatement, 7, [unit.unitNumber UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertUnitStatement, 8, [unit.projectId UTF8String], -1, SQLITE_TRANSIENT);
    
    
    if(SQLITE_DONE != sqlite3_step(insertUnitStatement)){
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    
    sqlite3_reset(insertUnitStatement);
}



- (NSMutableArray *)getAllUnitsForProject:(NSString *)projectId
{
    
    NSMutableArray *allUnitsArray = [NSMutableArray new];
    
    sqlite3_bind_text(getAllUnitsStatement, 1, [projectId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(getAllUnitsStatement)==SQLITE_ROW)
    {
        
        Unit *unit = [[Unit alloc]init];
        
        unit.unitId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllUnitsStatement, 0)];
        
        
        if(sqlite3_column_text(getAllUnitsStatement, 1) != nil)
        {
            unit.address = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllUnitsStatement, 1)];
        }
        else{
            unit.address=@"";
        }
        
        if(sqlite3_column_text(getAllUnitsStatement, 2) != nil)
        {
            unit.completionDate = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllUnitsStatement, 2)];
        }
        else
        {
            unit.completionDate=@"";
        }
        if(sqlite3_column_text(getAllUnitsStatement, 3) != nil)
        {
            unit.possessionDate = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllUnitsStatement, 3)];
        }
        else{
            unit.possessionDate=@"";
            
        }
        if(sqlite3_column_text(getAllUnitsStatement, 4) != nil)
        {
            unit.unitEnrollmentNumber = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllUnitsStatement, 4)];
        }
        else{
            
            unit.unitEnrollmentNumber=@"";
        }
        
        if(sqlite3_column_text(getAllUnitsStatement, 5) != nil)
        {
            unit.unitLegalDes = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllUnitsStatement, 5)];
            
        }
        else{
            unit.unitLegalDes=@"";
        }
        
        unit.isPendingUnit =  sqlite3_column_int(getAllUnitsStatement, 6);
        
        unit.unitNumber =  [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllUnitsStatement, 7)];
        
        unit.projectId =  [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllUnitsStatement, 8)];
        
        unit.ownersList = [[OwnerDBManager sharedManager] getAllOwnersForUnit:unit.unitId];
        
//        unit.locationList = [[LocationDBManager sharedManager] getAllLocationsForUnit:unit.unitId];
        
        [allUnitsArray addObject:unit];
        
    }
    
    sqlite3_reset(getAllUnitsStatement);
    return allUnitsArray;
}


- (Unit *)getUnitForUnitId:(NSString *)unitId
{
    
    
    sqlite3_bind_text(getUnitForUnitId, 1, [unitId UTF8String], -1, SQLITE_TRANSIENT);
    
    Unit *unit = [[Unit alloc]init];
    
    while (sqlite3_step(getUnitForUnitId)==SQLITE_ROW)
    {
        
        unit.unitId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUnitForUnitId, 0)];
        
        
        if(sqlite3_column_text(getUnitForUnitId, 1) != nil)
        {
            unit.address = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUnitForUnitId, 1)];
        }
        else{
            unit.address=@"";
        }
        
        if(sqlite3_column_text(getUnitForUnitId, 2) != nil)
        {
            unit.completionDate = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUnitForUnitId, 2)];
        }
        else
        {
            unit.completionDate=@"";
        }
        if(sqlite3_column_text(getUnitForUnitId, 3) != nil)
        {
            unit.possessionDate = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUnitForUnitId, 3)];
        }
        else{
            unit.possessionDate=@"";
            
        }
        if(sqlite3_column_text(getUnitForUnitId, 4) != nil)
        { unit.unitEnrollmentNumber = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUnitForUnitId, 4)];
        }
        else{
            
            unit.unitEnrollmentNumber=@"";
        }
        
        if(sqlite3_column_text(getUnitForUnitId, 5) != nil)
        {
            unit.unitLegalDes = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUnitForUnitId, 5)];
            
        }
        else{
            unit.unitLegalDes=@"";
        }
        
        unit.isPendingUnit =  sqlite3_column_int(getUnitForUnitId, 6);
        
        unit.unitNumber =  [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUnitForUnitId, 7)];
        
        unit.projectId =  [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getUnitForUnitId, 8)];
        
        
    }
    
    sqlite3_reset(getUnitForUnitId);
    return unit;
}



- (void)deleteUnit:(Unit *)unit{
    
    sqlite3_bind_text(deleteUnitStatement, 1, [unit.projectId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(deleteUnitStatement, 2, [unit.unitId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(deleteUnitStatement);
    sqlite3_reset(deleteUnitStatement);
}



- (void)deleteAllUnits:(NSString *)projectId{
    
    sqlite3_bind_text(deleteAllUnitsStatement, 1, [projectId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(deleteAllUnitsStatement);
    sqlite3_reset(deleteAllUnitsStatement);
}


- (void)updateUnit:(Unit *)unit{
    
    
    sqlite3_bind_text(updateUnitStatement, 1, [unit.address UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateUnitStatement, 2, [unit.completionDate UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateUnitStatement, 3, [unit.possessionDate UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateUnitStatement, 4, [unit.unitEnrollmentNumber UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateUnitStatement, 5, [unit.unitLegalDes UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(updateUnitStatement, 6, unit.isPendingUnit);
    
    sqlite3_bind_text(updateUnitStatement, 7, [unit.unitNumber UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(updateUnitStatement, 8, [unit.unitId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(updateUnitStatement);
    
    sqlite3_reset(updateUnitStatement);
}


- (int)getPendingUnitsCountForProject:(NSString *)projectId{
    
    int count = 0;
    
	
    sqlite3_bind_text(countPendingUnitStatement, 2, [projectId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(countPendingUnitStatement)==SQLITE_ROW)
    {
        count =  sqlite3_column_int(countPendingUnitStatement, 0);
    }
    
    sqlite3_reset(countPendingUnitStatement);
    
    return count;
}


- (NSMutableArray *)getAllUnitIdsForProjectId:(NSString *)projectId
{
    
    NSMutableArray *allUnitsArray = [NSMutableArray new];
    sqlite3_bind_text(getAllUnitIdsStatement, 1, [projectId UTF8String], -1, SQLITE_TRANSIENT);
    while (sqlite3_step(getAllUnitIdsStatement)==SQLITE_ROW)
    {
        
        [allUnitsArray addObject:[NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllUnitIdsStatement, 0)]];
    }
    sqlite3_reset(getAllUnitIdsStatement);
    return allUnitsArray;
}

- (int)getLocationRowIdForOtherLocation:(NSString *)UnitId{
	
	sqlite3_bind_text(getUnitIdForOtherFieldStatement, 1, [UnitId UTF8String], -1, SQLITE_TRANSIENT);
	
	int locationRowIdForOtherField;
	if (sqlite3_step(getUnitIdForOtherFieldStatement)==SQLITE_ROW)
	{
		locationRowIdForOtherField =  sqlite3_column_int(getUnitIdForOtherFieldStatement, 0);
	}
	sqlite3_reset(getUnitIdForOtherFieldStatement);
	return locationRowIdForOtherField;
}



@end
