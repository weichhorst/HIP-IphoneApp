//
//  LocationDataBase.m
//  Conasys
//
//  Created by abhi on 6/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "LocationDataBase.h"
#import "ProductDBManager.h"

@implementation LocationDataBase

static Database *sharedDatabase = nil;

+ (id)sharedDatabase
{
    
    if (!sharedDatabase)
    {
        sharedDatabase = [[self alloc] init];
        
        [sharedDatabase createDb:sharedDatabase];
        [sharedDatabase customInit];
        
    }
    return sharedDatabase;
}


static sqlite3_stmt *insertLocationStatement;
static sqlite3_stmt *getAllLocationStatement;
//static sqlite3_stmt *deleteLocationStatement;
//static sqlite3_stmt *deleteAllLocationStatement;

-(void)customInit
{
    
    static const char *insertRecord = "Insert into Location (locationId, unitId, locationName) values (?, ?, ?)";
    sqlite3_prepare_v2(self.connection, insertRecord, -1, &insertLocationStatement, NULL);
    
    
    static const char *getUser = "SELECT * From Location where unitId = ?";
    sqlite3_prepare_v2(self.connection, getUser, -1, &getAllLocationStatement, NULL);
    
    
//    static const char *deleteRecord = "DELETE FROM Location WHERE locationId = ? AND unitId = ?";
//    sqlite3_prepare_v2(self.connection, deleteRecord, -1, &deleteLocationStatement, NULL);
    
    
//    static const char *deleteAll = "DELETE FROM Location WHERE unitId = ?";
//    sqlite3_prepare_v2(self.connection, deleteAll, -1, &deleteAllLocationStatement, NULL);
    
}


- (long long)insertIntoLocationTable:(Location *)location
{
    
    sqlite3_bind_text(insertLocationStatement, 1, [location.locationId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertLocationStatement, 2, [location.unitId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertLocationStatement, 3, [location.locationName UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(insertLocationStatement))
    {
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    
    sqlite3_reset(insertLocationStatement);
    
    return sqlite3_last_insert_rowid(self.connection);

}


- (NSMutableArray *)getAllLocationsForUnit:(NSString *)unitId
{
    
    NSMutableArray *allServiceArray = [NSMutableArray new];
    
    
    sqlite3_bind_text(getAllLocationStatement, 1, [unitId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(getAllLocationStatement)==SQLITE_ROW)
    {
        Location *location = [[Location alloc]init];
        
        location.locationRowId = sqlite3_column_int(getAllLocationStatement, 0);
        
        location.locationId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllLocationStatement, 1)];
        
        location.locationName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllLocationStatement, 2)];

        location.unitId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllLocationStatement, 3)];;
        
        location.products = [[ProductDBManager sharedManager] getAllProductsForLocation:location.locationRowId];
                
        [allServiceArray addObject:location];
    }
    
    sqlite3_reset(getAllLocationStatement);
    return allServiceArray;
}



//- (void)deleteLocation:(Location *)Location
//{
//  
//    sqlite3_bind_text(deleteLocationStatement, 1, [Location.locationId UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(deleteLocationStatement, 2, [Location.unitId UTF8String], -1, SQLITE_TRANSIENT);
//
//
//    sqlite3_step(deleteLocationStatement);
//    sqlite3_reset(deleteLocationStatement);
//    
//}
//
//
//
//- (void)deleteAllLocation:(NSString *)locationId
//{
//    
//    sqlite3_bind_text(deleteAllLocationStatement, 1, [locationId UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_step(deleteAllLocationStatement);
//    sqlite3_reset(deleteAllLocationStatement);
//    
//}

@end
