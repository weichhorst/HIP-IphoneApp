//
//  OwnerDataBase.m
//  Conasys
//
//  Created by user on 6/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "OwnerDataBase.h"

@implementation OwnerDataBase


static Database *sharedDatabase = nil;

+ (id)sharedDatabase{
    
    if (!sharedDatabase) {
        sharedDatabase = [[self alloc] init];
        
        [sharedDatabase createDb:sharedDatabase];
        [sharedDatabase customInit];
        
    }
    return sharedDatabase;
}


static sqlite3_stmt *insertOwnerStatement;
static sqlite3_stmt *getAllOwnersStatement;
//static sqlite3_stmt *deleteOwnerStatement;
//static sqlite3_stmt *deleteAllOwnersStatement;
static sqlite3_stmt *updateStatement;
static sqlite3_stmt *lastRecordInserted;
static sqlite3_stmt *getOwnerFromId;
static sqlite3_stmt *getAllOfflineOwnersStatement;
static sqlite3_stmt *getOfflineOwnersCountStatement;
static sqlite3_stmt *getOfflineOwnersStatement;


// This method will initialliace all sqlite statement(insertion, fetching, deletion) at once and can be used to perform DB Operations.
-(void)customInit {
    
    
    static const char *insertRecord = "Insert into Owner (ownerId, username, firstName, lastName, email, phoneNumber, enableEmailNotification, unitId, isEdited, isNewOwner, password, builderName, builderToken) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    sqlite3_prepare_v2(self.connection, insertRecord, -1, &insertOwnerStatement, NULL);
    
    static const char *getOwners = "SELECT * From Owner where unitId = ?";
    sqlite3_prepare_v2(self.connection, getOwners, -1, &getAllOwnersStatement, NULL);
    
    static const char *getSingleOwner = "SELECT * From Owner where ownerRowId = ?";
    sqlite3_prepare_v2(self.connection, getSingleOwner, -1, &getOwnerFromId, NULL);

    
    const char *updateOwner = "update Owner Set firstName = ?, lastName = ?, email = ?, phoneNumber = ?, enableEmailNotification = ?, isEdited=?, isNewOwner=?, isSyncing=?, password=?, builderName=?, builderToken=? Where unitId=? and ownerRowId=?";
    sqlite3_prepare_v2(self.connection, updateOwner, -1, &updateStatement, NULL);
    
    
    const char *lastOwner = "select * from Owner order by rowId DESC LIMIT 1";
    sqlite3_prepare_v2(self.connection, lastOwner, -1, &lastRecordInserted, NULL);
    
    
    static const char *getOfflineOwners = "SELECT * From Owner where isEdited = ? or isNewOwner = ?";
    sqlite3_prepare_v2(self.connection, getOfflineOwners, -1, &getAllOfflineOwnersStatement, NULL);
    
    
    static const char *getOfflineOwnersCount = "SELECT count(*) From Owner where isSyncing = ?";
    sqlite3_prepare_v2(self.connection, getOfflineOwnersCount, -1, &getOfflineOwnersCountStatement, NULL);
    
    static const char *getOfflineOwnersStatemnt = "SELECT * From Owner where isSyncing = ?";
    sqlite3_prepare_v2(self.connection, getOfflineOwnersStatemnt, -1, &getOfflineOwnersStatement, NULL);
    
    

}


- (void)insertIntoOwnerTable:(Owner *)owner{
    
  
    sqlite3_bind_text(insertOwnerStatement, 1, [owner.ownerId UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_text(insertOwnerStatement, 2, [owner.userName UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_text(insertOwnerStatement, 3, [owner.firstName UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_text(insertOwnerStatement, 4, [owner.lastName UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_text(insertOwnerStatement, 5, [owner.email UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_text(insertOwnerStatement, 6, [owner.phoneNumber UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_text(insertOwnerStatement, 7, [owner.enableEmailNotification UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_text(insertOwnerStatement, 8, [owner.unitId UTF8String], -1, SQLITE_TRANSIENT);
    
    // 12-sept-2014
    sqlite3_bind_int(insertOwnerStatement, 9, owner.isEdited);
    
    sqlite3_bind_int(insertOwnerStatement, 10, owner.isNewOwner);
    
    sqlite3_bind_text(insertOwnerStatement, 11, [owner.password UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertOwnerStatement, 12, [owner.builderName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertOwnerStatement, 13, [owner.builderToken UTF8String], -1, SQLITE_TRANSIENT);

    if(SQLITE_DONE != sqlite3_step(insertOwnerStatement)){
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }

    sqlite3_reset(insertOwnerStatement);
    
}



- (NSMutableArray *)getAllOwnersForUnit:(NSString *)unitId{
    
    NSMutableArray *allOwnerArray = [NSMutableArray new];
    
    sqlite3_bind_text(getAllOwnersStatement, 1, [unitId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(getAllOwnersStatement)==SQLITE_ROW) {
        
        Owner *owner = [[Owner alloc]init];
        
        owner.ownerRowId = sqlite3_column_int(getAllOwnersStatement, 0);
        
        owner.ownerId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOwnersStatement, 1)];
        
        owner.userName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOwnersStatement, 2)];
        
        owner.firstName= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOwnersStatement, 3)];
        
        owner.lastName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOwnersStatement, 4)];
        
        owner.email = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOwnersStatement, 5)];
        
        owner.phoneNumber = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOwnersStatement, 6)];
        
        owner.enableEmailNotification = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOwnersStatement, 7)];
        
        owner.unitId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOwnersStatement, 8)];
        
        owner.isEdited = sqlite3_column_int(getAllOwnersStatement, 9);

        owner.isNewOwner = sqlite3_column_int(getAllOwnersStatement, 10);

        owner.isSyncing = sqlite3_column_int(getAllOwnersStatement, 11);
        
//        owner.password = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOwnersStatement, 12)];
        
        if(sqlite3_column_text(getAllOwnersStatement, 12) != nil){
            
            owner.password = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOwnersStatement, 12)];
        }
        else{
            
            owner.password = @"";
        }
        
        owner.builderName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOwnersStatement, 13)];
        
        owner.builderToken = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOwnersStatement, 14)];
        
        [allOwnerArray addObject:owner];
        
    }
    
    sqlite3_reset(getAllOwnersStatement);
    return allOwnerArray;
}


- (Owner *)getOwnerForOwnerId:(int)ownerRowId{
    
    Owner *owner = [[Owner alloc]init];
    
    sqlite3_bind_int(getOwnerFromId, 1, ownerRowId);
    
    while (sqlite3_step(getOwnerFromId)==SQLITE_ROW) {
        
        owner.ownerRowId = sqlite3_column_int(getOwnerFromId, 0);
        
        owner.ownerId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOwnerFromId, 1)];
        
        owner.userName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOwnerFromId, 2)];
        
        owner.firstName= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOwnerFromId, 3)];
        
        owner.lastName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOwnerFromId, 4)];
        
        owner.email = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOwnerFromId, 5)];
        
        owner.phoneNumber = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOwnerFromId, 6)];
        
        owner.enableEmailNotification = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOwnerFromId, 7)];
        
        owner.unitId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOwnerFromId, 8)];
        
        owner.isEdited = sqlite3_column_int(getOwnerFromId, 9);
        
        owner.isNewOwner = sqlite3_column_int(getOwnerFromId, 10);
        
        owner.isSyncing = sqlite3_column_int(getOwnerFromId, 11);
        
//        owner.password = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOwnerFromId, 12)];
        
        if(sqlite3_column_text(getOwnerFromId, 12) != nil){
            
            owner.password = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOwnerFromId, 12)];
        }
        else{
            
            owner.password = @"";
        }
        
        owner.builderName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOwnerFromId, 13)];
        
        owner.builderToken = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOwnerFromId, 14)];
        
    }
    
    sqlite3_reset(getOwnerFromId);

    return owner;
}


- (Owner *)getLastOwnerInserted{
    
   Owner *owner = [[Owner alloc]init];
    
    while (sqlite3_step(lastRecordInserted)==SQLITE_ROW) {
        
        owner.ownerRowId = sqlite3_column_int(lastRecordInserted, 0);
        
        owner.ownerId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(lastRecordInserted, 1)];
        
        owner.userName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(lastRecordInserted, 2)];
        
        owner.firstName= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(lastRecordInserted, 3)];
        
        owner.lastName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(lastRecordInserted, 4)];
        
        owner.email = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(lastRecordInserted, 5)];
        
        owner.phoneNumber = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(lastRecordInserted, 6)];
        
        owner.enableEmailNotification = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(lastRecordInserted, 7)];
        
        owner.unitId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(lastRecordInserted, 8)];
        
        owner.isEdited = sqlite3_column_int(lastRecordInserted, 9);
        
        owner.isNewOwner = sqlite3_column_int(lastRecordInserted, 10);
        
        owner.isSyncing = sqlite3_column_int(lastRecordInserted, 11);
        
//        owner.password = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(lastRecordInserted, 12)];
        
        if(sqlite3_column_text(lastRecordInserted, 12) != nil){
            
            owner.password = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(lastRecordInserted, 12)];
        }
        else{
            
            owner.password = @"";
        }
        
        owner.builderName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(lastRecordInserted, 13)];
        
        owner.builderToken = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(lastRecordInserted, 14)];
        
    }
    
    sqlite3_reset(lastRecordInserted);
    return owner;
}



- (void)updateIntoOwnerTable:(Owner *)owner
{
//    update Owner Set firstName = ?, lastName = ?, email = ?, phoneNumber = ?, enableEmailNotification = ?, isEdited=?, isNewOwner=?, isSyncing=?, password=?, builderName=?, builderToken=? Where unitId=? and ownerRowId=?
    sqlite3_bind_text(updateStatement, 1, [owner.firstName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateStatement, 2, [owner.lastName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateStatement, 3, [owner.email UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateStatement, 4, [owner.phoneNumber UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateStatement, 5, [owner.enableEmailNotification UTF8String], -1, SQLITE_TRANSIENT);
    
    //12-sept-2014
    sqlite3_bind_int(updateStatement, 6, owner.isEdited);
    
    sqlite3_bind_int(updateStatement, 7, owner.isNewOwner);
    
    
    sqlite3_bind_int(updateStatement, 8, owner.isSyncing);
    
    sqlite3_bind_text(updateStatement, 9, [owner.password UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateStatement, 10, [owner.builderName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateStatement, 11, [owner.builderToken UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateStatement, 12, [owner.unitId UTF8String], -1, SQLITE_TRANSIENT);
    
//    sqlite3_bind_text(updateStatement, 9, [owner.ownerId UTF8String], -1, SQLITE_TRANSIENT);
    
    NSLog(@"owner Row Id== %d", owner.ownerRowId);
    
    sqlite3_bind_int(updateStatement, 13, owner.ownerRowId);
    
    
    if(SQLITE_DONE != sqlite3_step(updateStatement))
    {
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    
    sqlite3_reset(updateStatement);
}


- (NSMutableArray *)allOfflineOwners{
    
    NSMutableArray *recordArray = [[NSMutableArray alloc]init];
    
    
    sqlite3_bind_int(getAllOfflineOwnersStatement, 1, 1); // isEdited; 1 depicts that it was edited.
    
    sqlite3_bind_int(getAllOfflineOwnersStatement, 2, 1); // isNewOwner 1 depicts that it is New User.
    
    while (sqlite3_step(getAllOfflineOwnersStatement)==SQLITE_ROW) {
        
        Owner *owner = [[Owner alloc]init];
        
        owner.ownerRowId = sqlite3_column_int(getAllOfflineOwnersStatement, 0);
        
        owner.ownerId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOfflineOwnersStatement, 1)];
        
        owner.userName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOfflineOwnersStatement, 2)];
        
        owner.firstName= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOfflineOwnersStatement, 3)];
        
        owner.lastName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOfflineOwnersStatement, 4)];
        
        owner.email = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOfflineOwnersStatement, 5)];
        
        owner.phoneNumber = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOfflineOwnersStatement, 6)];
        
        owner.enableEmailNotification = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOfflineOwnersStatement, 7)];
        
        owner.unitId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOfflineOwnersStatement, 8)];
        
        owner.isEdited = sqlite3_column_int(getAllOfflineOwnersStatement, 9);
        
        owner.isNewOwner = sqlite3_column_int(getAllOfflineOwnersStatement, 10);
        
        owner.isSyncing = sqlite3_column_int(getAllOfflineOwnersStatement, 11);
        
        
        if(sqlite3_column_text(getAllOfflineOwnersStatement, 12) != nil){
            
            owner.password = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOfflineOwnersStatement, 12)];
        }
        else{
            
            owner.password = @"";
        }
        
        owner.builderName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOfflineOwnersStatement, 13)];
        
        owner.builderToken = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllOfflineOwnersStatement, 14)];
        
        if (!owner.isSyncing) {

            [recordArray addObject:owner];
        }
        
    }
    
    sqlite3_reset(getAllOfflineOwnersStatement);
    
    return recordArray;
}


- (NSMutableArray *)getAllOfflineOwners{
    
    NSMutableArray *recordArray = [[NSMutableArray alloc]init];
    
    
    sqlite3_bind_int(getOfflineOwnersStatement, 1, 1); // isSyncing; 1 depicts that it was edited.
    
    while (sqlite3_step(getOfflineOwnersStatement)==SQLITE_ROW) {
        
        Owner *owner = [[Owner alloc]init];
        
        owner.ownerRowId = sqlite3_column_int(getOfflineOwnersStatement, 0);
        
        owner.ownerId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOfflineOwnersStatement, 1)];
        
        owner.userName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOfflineOwnersStatement, 2)];
        
        owner.firstName= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOfflineOwnersStatement, 3)];
        
        owner.lastName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOfflineOwnersStatement, 4)];
        
        owner.email = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOfflineOwnersStatement, 5)];
        
        owner.phoneNumber = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOfflineOwnersStatement, 6)];
        
        owner.enableEmailNotification = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOfflineOwnersStatement, 7)];
        
        owner.unitId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOfflineOwnersStatement, 8)];
        
        owner.isEdited = sqlite3_column_int(getOfflineOwnersStatement, 9);
        
        owner.isNewOwner = sqlite3_column_int(getOfflineOwnersStatement, 10);
        
        owner.isSyncing = sqlite3_column_int(getOfflineOwnersStatement, 11);
        
        
        if(sqlite3_column_text(getOfflineOwnersStatement, 12) != nil){
            
            owner.password = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOfflineOwnersStatement, 12)];
        }
        else{
            
            owner.password = @"";
        }
        
        owner.builderName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOfflineOwnersStatement, 13)];
        
        owner.builderToken = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getOfflineOwnersStatement, 14)];
        
        if (!owner.isSyncing) {
            
            [recordArray addObject:owner];
        }
        
    }
    
    sqlite3_reset(getOfflineOwnersStatement);
    
    return recordArray;
}


- (int)sycingOwnerCount{
    
    
//    int count = 0;
//    
//    
//    NSMutableArray *orr  = [self getAllOwnersForUnit:@"544524"];
    
//    return (int)orr.count;
    
//    for (int i=0;i<orr.count;i++) {
//
//        Owner *owner = [orr objectAtIndex:i];
//        NSLog(@"%@",owner.userName);
//        NSLog(@"%d",owner.isSyncing);
//        NSString *isSyncStr = [NSString stringWithFormat:@"%d",owner.isSyncing];
//        if(owner.isSyncing || [isSyncStr isEqualToString:@"?"])
//        {
//            count++;
//        }
        
//    }
    
    
    
//    int count = 0;
//    
//    sqlite3_bind_int(getOfflineOwnersCountStatement, 1, 1); //here 1 is the value to
//    
//    while (sqlite3_step(getOfflineOwnersCountStatement)==SQLITE_ROW)
//    {
//        count =  sqlite3_column_int(getOfflineOwnersCountStatement, 0);
//    }
    
    
    
//    for (int i=0;i<arr.count;i++) {
//        
//        Owner *owner = [arr objectAtIndex:i];
//        NSLog(@"%@",owner.userName);
//        NSLog(@"%d",owner.isSyncing);
//        
//        
//        
//    }

    NSMutableArray *arr = [self getAllOfflineOwners];
    
    sqlite3_reset(getOfflineOwnersStatement);

    if(arr.count)
        return 1;
    else
        return 0;
    
    
    //return count;
}

@end
