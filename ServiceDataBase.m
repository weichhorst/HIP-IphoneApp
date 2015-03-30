//
//  ServiceDataBase.m
//  Conasys
//
//  Created by user on 5/12/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ServiceDataBase.h"
#import "HeaderFiles.h"

@implementation ServiceDataBase


static Database *sharedDatabase = nil;

+ (id)sharedDatabase{

    if (!sharedDatabase) {
        sharedDatabase = [[self alloc] init];
        
        [sharedDatabase createDb:sharedDatabase];
        [sharedDatabase customInit];
        
    }
    return sharedDatabase;
}



static sqlite3_stmt *insertServiceStatement;
static sqlite3_stmt *getAllServicesStatement;
static sqlite3_stmt *deleteServiceStatement;
static sqlite3_stmt *deleteAllServicesStatement;
static sqlite3_stmt *getAllServicesWithId;


// This method will initialliace all sqlite statement(insertion, fetching, deletion) at once and can be used to perform DB Operations.

-(void)customInit {

    static const char *insertRecord = "Insert into ServiceType (serviceTypeId, name, isConstructionView, legalTerms, projectId) values (?, ?, ?, ?, ?)";
    sqlite3_prepare_v2(self.connection, insertRecord, -1, &insertServiceStatement, NULL);
    
    
    static const char *getUser = "SELECT * From ServiceType where projectId = ?";
    sqlite3_prepare_v2(self.connection, getUser, -1, &getAllServicesStatement, NULL);
    
    static const char *getService = "SELECT * From ServiceType where serviceId = ?";
    sqlite3_prepare_v2(self.connection, getService, -1, &getAllServicesWithId, NULL);

    
    static const char *deleteRecord = "DELETE FROM ServiceType WHERE projectId = ? AND serviceTypeId = ?";
    sqlite3_prepare_v2(self.connection, deleteRecord, -1, &deleteServiceStatement, NULL);
    
    
    static const char *userCount = "DELETE FROM ServiceType WHERE projectId = ?";
    sqlite3_prepare_v2(self.connection, userCount, -1, &deleteAllServicesStatement, NULL);
    
}


// Inserting Service to DB.

- (void)insertIntoServiceTable:(Service *)service{
    

    sqlite3_bind_text(insertServiceStatement, 1, [service.serviceTypeId UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_text(insertServiceStatement, 2, [service.name UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_text(insertServiceStatement, 3, [[NSString stringWithFormat:@"%d", service.isConstructionView] UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_text(insertServiceStatement, 4, [service.legalTerms UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertServiceStatement, 5, [service.projectId UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(insertServiceStatement)){
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }

    sqlite3_reset(insertServiceStatement);

}



// Fetching all services from DB.

- (NSMutableArray *)getAllServicesForProject:(NSString *)projectId
{
    
    NSMutableArray *allServiceArray = [NSMutableArray new];
    
    sqlite3_bind_text(getAllServicesStatement, 1, [projectId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(getAllServicesStatement)==SQLITE_ROW)
    {
        
        [allServiceArray addObject:[self getProjectService]];
    }
    
    sqlite3_reset(getAllServicesStatement);
    return allServiceArray;
}


- (Service *)getProjectService{
    
    
    Service *service = [[Service alloc]init];
    
    
    service.serviceTypeId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllServicesStatement, 0)];
    
    
    if(sqlite3_column_text(getAllServicesStatement, 1) != nil)
    {
        service.name = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllServicesStatement, 1)];
    }
    else
    {
        service.name=@"";
    }
    
    service.isConstructionView = sqlite3_column_int(getAllServicesStatement, 2);
    
    if(sqlite3_column_text(getAllServicesStatement, 3) != nil)
    {
        service.legalTerms = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllServicesStatement, 3)];
    }
    else
    {
        service.legalTerms=@"";
    }
    
    service.projectId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllServicesStatement, 4)];;
    
    return service;
}



- (Service *)getServiceForServiceId:(NSString *)serviceTypeId{
    
    
    Service *service = [[Service alloc]init];
    
    sqlite3_bind_text(getAllServicesWithId, 1, [service.serviceTypeId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(getAllServicesWithId)==SQLITE_ROW)
    {
        
        
        service.serviceTypeId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllServicesWithId, 0)];
        
        if(sqlite3_column_text(getAllServicesWithId, 1) != nil)
        {
            service.name = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllServicesWithId, 1)];
        }
        else
        {
            service.name=@"";
        }
        
        service.isConstructionView = sqlite3_column_int(getAllServicesWithId, 2);
        
        if(sqlite3_column_text(getAllServicesWithId, 3) != nil)
        {
            service.legalTerms = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllServicesWithId, 3)];
        }
        else
        {
            service.legalTerms=@"";
        }
        
        service.projectId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllServicesWithId, 4)];
        
    }
    
    sqlite3_reset(getAllServicesWithId);
   
    return service;
    
}


// Deleting a particular Service from DB.
- (void)deleteService:(Service *)service{
    
    sqlite3_bind_text(deleteServiceStatement, 1, [service.projectId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(deleteServiceStatement, 2, [service.serviceTypeId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(deleteServiceStatement);
    sqlite3_reset(deleteServiceStatement);

}



// Deleting all services from DB.
- (void)deleteAllServices:(NSString *)projectId{
    
    sqlite3_bind_text(deleteAllServicesStatement, 1, [projectId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(deleteAllServicesStatement);
    sqlite3_reset(deleteAllServicesStatement);

}


@end
