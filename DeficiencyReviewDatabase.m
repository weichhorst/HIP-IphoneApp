//
//  DeficiencyReviewDatabase.m
//  Conasys
//
//  Created by user on 8/1/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "DeficiencyReviewDatabase.h"
#import "ReviewOwnerDatabase.h"
#import "ReviewItemDatabase.h"

@implementation DeficiencyReviewDatabase

static sqlite3_stmt *insertIntoReviewStatement;
static sqlite3_stmt *getAllReviewStatement;
static sqlite3_stmt *getDeficiencyReviewForUnitStatement;
static sqlite3_stmt *deleteReviewStatement;
static sqlite3_stmt *updateDeficiencyReviewStatement;
static sqlite3_stmt *switchParagmaON;
static sqlite3_stmt *deleteExecutedReviewStatement;
static sqlite3_stmt *deleteReviewStatementForUnit;
static sqlite3_stmt *getPendingCountForUserStatement;

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


-(void)customInit
{
    
    [self initializingItemTableStatements];
    
}


- (void)initializingItemTableStatements{
    
    static const char *insertReview = "Insert into DeficiencyReview (userId, unitId, developerName, performedByEmail, performedByName, reviewInitiationTimeStamp, additionalComments, serviceTypeId, possessionDate, unitEnrolmentPolicy, isPDI) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    sqlite3_prepare_v2(self.connection, insertReview, -1, &insertIntoReviewStatement, NULL);
    
    static const char *getAllReview = "SELECT * From DeficiencyReview where isUploaded = 0 and isPending = 0 and isSyncing=0";
    sqlite3_prepare_v2(self.connection, getAllReview, -1, &getAllReviewStatement, NULL);
    
    // New on 11-sept-2014
    static const char *getPendingCount = "SELECT count(*) From DeficiencyReview where isUploaded = 0 and isPending = 0 and userId = ?";
    sqlite3_prepare_v2(self.connection, getPendingCount, -1, &getPendingCountForUserStatement, NULL);
    //
    
    static const char *getReviewForUnit = "SELECT * From DeficiencyReview where isPending = 1 and isUploaded = 0 and unitId=?";
    sqlite3_prepare_v2(self.connection, getReviewForUnit, -1, &getDeficiencyReviewForUnitStatement, NULL);
    
    static const char *pragmaON = "PRAGMA foreign_keys = ON";
    sqlite3_prepare_v2(self.connection, pragmaON, -1, &switchParagmaON, NULL);
    
    static const char *deleteReview = "Delete from DeficiencyReview where reviewRowId = ?";
    sqlite3_prepare_v2(self.connection, deleteReview, -1, &deleteReviewStatement, NULL);
    
    
    static const char *deleteItemReview = "Delete from DeficiencyReview where isPending=1 and unitId = ?";
    sqlite3_prepare_v2(self.connection, deleteItemReview, -1, &deleteReviewStatementForUnit, NULL);
    
    static const char *deleteExecutedReview = "delete from DeficiencyReview where isUploaded = 1";
    sqlite3_prepare_v2(self.connection, deleteExecutedReview, -1, &deleteExecutedReviewStatement, NULL);
    
    
    static const char *updateReview = "update DeficiencyReview set performedBySignature = ?, developerSignature = ?, developerName = ?, performedByEmail = ?, performedByName = ?, reviewInitiationTimeStamp = ?, ownerNextTimeStamp = ?, itemNextTimeStamp = ?, confirmationSubmitTimestamp =?, additionalComments = ?, isPending = ?, lastPageNumber =?, selectedServiceTypeIndex = ?, isUploaded=?, serviceTypeId=?, possessionDate=?, unitEnrolmentPolicy=?, isPDI = ?, isSyncing=?  where userId = ? and unitId = ? and reviewRowId = ?";
    sqlite3_prepare_v2(self.connection, updateReview, -1, &updateDeficiencyReviewStatement, NULL);
    
}


- (int)pendingProjectsForUser:(NSString *)userId{
    
    int count = 0;
    
    sqlite3_bind_text(getPendingCountForUserStatement, 1, [userId UTF8String], -1, SQLITE_TRANSIENT);

    while (sqlite3_step(getPendingCountForUserStatement)==SQLITE_ROW)
    {
        count =  sqlite3_column_int(getPendingCountForUserStatement, 0);
    }
    
    sqlite3_reset(getPendingCountForUserStatement);
    
    NSLog(@"Count ==%d", count);
    return count;
}


- (DeficiencyReview *)getDeficiencyReviewForUnit:(NSString *)unitId{
    
    
    DeficiencyReview *review = [[DeficiencyReview alloc]init];
    
     sqlite3_bind_text(getDeficiencyReviewForUnitStatement, 1, [unitId UTF8String], -1, SQLITE_TRANSIENT);
    
    while (sqlite3_step(getDeficiencyReviewForUnitStatement)==SQLITE_ROW)
    {
        
        
        review.reviewRowId = sqlite3_column_int(getDeficiencyReviewForUnitStatement, 0);
        
        review.userId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeficiencyReviewForUnitStatement, 1)];

        review.unitId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeficiencyReviewForUnitStatement, 2)];
        
        
        if(sqlite3_column_text(getDeficiencyReviewForUnitStatement, 3) != nil){
            
            review.performedBySignature = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeficiencyReviewForUnitStatement, 3)];
        }
        else{
            
            review.performedBySignature = @"";
        }
        
        
        if(sqlite3_column_text(getDeficiencyReviewForUnitStatement, 4) != nil){
            
            review.developerSignature = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeficiencyReviewForUnitStatement, 4)];
        }
        else{
            
            review.developerSignature = @"";
        }
        
        
        if(sqlite3_column_text(getDeficiencyReviewForUnitStatement, 5) != nil){
            
            review.developerName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeficiencyReviewForUnitStatement, 5)];
        }
        else{
            
            review.developerName = @"";
        }
        
        if(sqlite3_column_text(getDeficiencyReviewForUnitStatement, 6) != nil){
            
            review.performedByEmail = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeficiencyReviewForUnitStatement, 6)];
        }
        else{
            
            review.performedByEmail = @"";
        }
        
        
        if(sqlite3_column_text(getDeficiencyReviewForUnitStatement, 7) != nil){
            
            review.performedByName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeficiencyReviewForUnitStatement, 7)];
        }
        else{
            
            review.performedByName = @"";
        }

        review.reviewInitiationTimeStamp = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeficiencyReviewForUnitStatement, 8)];
        
        if(sqlite3_column_text(getDeficiencyReviewForUnitStatement, 9) != nil){
            
            review.ownerNextTimeStamp = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeficiencyReviewForUnitStatement, 9)];
        }
        else{
            
            review.ownerNextTimeStamp = @"";
        }

        if(sqlite3_column_text(getDeficiencyReviewForUnitStatement, 10) != nil){
            
            review.itemNextTimeStamp = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeficiencyReviewForUnitStatement, 10)];
        }
        else{
            
            review.itemNextTimeStamp = @"";
        }

        if(sqlite3_column_text(getDeficiencyReviewForUnitStatement, 11) != nil){
            
            review.confirmationSubmitTimestamp = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeficiencyReviewForUnitStatement, 11)];
        }
        else{
            
            review.confirmationSubmitTimestamp = @"";
        }
        
        if(sqlite3_column_text(getDeficiencyReviewForUnitStatement, 12) != nil){
            
            review.additionalComments = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeficiencyReviewForUnitStatement, 12)];
        }
        else{
            
            review.additionalComments = @"";
        }

        review.isPending = sqlite3_column_int(getDeficiencyReviewForUnitStatement, 13);

        review.lastPageNumber = sqlite3_column_int(getDeficiencyReviewForUnitStatement, 14);

        review.selectedServiceTypeIndex = sqlite3_column_int(getDeficiencyReviewForUnitStatement, 15);
        
        
        review.isUploaded = sqlite3_column_int(getDeficiencyReviewForUnitStatement, 16);
        
        if(sqlite3_column_text(getDeficiencyReviewForUnitStatement, 17) != nil){
            
            review.serviceTypeId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeficiencyReviewForUnitStatement, 17)];
        }
        else{
            
            review.serviceTypeId = @"0";
        }
        
        
        if(sqlite3_column_text(getDeficiencyReviewForUnitStatement, 18) != nil){
            
            review.possessionDate = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeficiencyReviewForUnitStatement, 18)];
        }
        else{
            
            review.possessionDate = @"";
        }
        
        
        if(sqlite3_column_text(getDeficiencyReviewForUnitStatement, 19) != nil){
            
            review.unitEnrolmentPolicy = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getDeficiencyReviewForUnitStatement, 19)];
        }
        else{
            
            review.unitEnrolmentPolicy = @"";
        }
        
        review.isPDI = sqlite3_column_int(getDeficiencyReviewForUnitStatement, 20);

        review.isSyncing = sqlite3_column_int(getDeficiencyReviewForUnitStatement, 21);
        
        review.reviewOwners = [[ReviewOwnerDatabase sharedDatabase]getAllReviewOwnersForReviewId:review.reviewRowId];
                
        review.deficienceyReviewItems = [[ReviewItemDatabase sharedDatabase] getAllReviewItemsForReview:review.reviewRowId];

    }
    
    sqlite3_reset(getDeficiencyReviewForUnitStatement);
    
    return review;
}



- (long long)insertDeficiencyReview:(DeficiencyReview *)review{
    
    
    sqlite3_bind_text(insertIntoReviewStatement, 1, [review.userId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertIntoReviewStatement, 2, [review.unitId UTF8String], -1, SQLITE_TRANSIENT);
   
//    sqlite3_bind_text(insertIntoReviewStatement, 3, [review.performedBySignature UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(insertIntoReviewStatement, 4, [review.developerSignature UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertIntoReviewStatement, 3, [review.developerName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertIntoReviewStatement, 4, [review.performedByEmail UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertIntoReviewStatement, 5, [review.performedByName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertIntoReviewStatement, 6, [review.reviewInitiationTimeStamp UTF8String], -1, SQLITE_TRANSIENT);
    
//    sqlite3_bind_text(insertIntoReviewStatement, 9, [review.ownerNextTimeStamp UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(insertIntoReviewStatement, 10, [review.itemNextTimeStamp UTF8String], -1, SQLITE_TRANSIENT);
//    
//    sqlite3_bind_text(insertIntoReviewStatement, 11, [review.confirmationSubmitTimestamp UTF8String], -1, SQLITE_TRANSIENT);
   
    sqlite3_bind_text(insertIntoReviewStatement,7, [review.additionalComments UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertIntoReviewStatement,8, [review.serviceTypeId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertIntoReviewStatement,9, [review.possessionDate UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertIntoReviewStatement,10, [review.unitEnrolmentPolicy UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(insertIntoReviewStatement, 11, review.isPDI);

    
//    sqlite3_bind_int(insertIntoReviewStatement, 13, review.isPending);
//    sqlite3_bind_int(insertIntoReviewStatement, 8, review.lastPageNumber);
//    sqlite3_bind_int(insertIntoReviewStatement, 9, review.selectedServiceTypeIndex);
    
    
    if(SQLITE_DONE != sqlite3_step(insertIntoReviewStatement)){
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    sqlite3_reset(insertIntoReviewStatement);
    
    return sqlite3_last_insert_rowid(self.connection);
}


- (NSMutableArray *)getAllDeficiencyReviews{
    
    NSMutableArray *recordArray = [NSMutableArray new];
    while (sqlite3_step(getAllReviewStatement)==SQLITE_ROW)
    {
        
        DeficiencyReview *review = [[DeficiencyReview alloc]init];
        
        review.reviewRowId = sqlite3_column_int(getAllReviewStatement, 0);
        
        review.userId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 1)];
        
        review.unitId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 2)];
        
        
        
        if(sqlite3_column_text(getAllReviewStatement, 3) != nil){
            
            review.performedBySignature = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 3)];
        }
        else{
            
            review.performedBySignature = @"";
        }

        
        
        if(sqlite3_column_text(getAllReviewStatement, 4) != nil){
            
            review.developerSignature = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 4)];
        }
        else{
            
            review.developerSignature = @"";
        }

        
        
        if(sqlite3_column_text(getAllReviewStatement, 5) != nil){
            
            review.developerName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 5)];
        }
        else{
            
            review.developerName = @"";
        }
        
        
        
        
        if(sqlite3_column_text(getAllReviewStatement, 6) != nil){
            
            review.performedByEmail = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 6)];
        }
        else{
            
            review.performedByEmail = @"";
        }
        
        
        
        if(sqlite3_column_text(getAllReviewStatement, 7) != nil){
            
            review.performedByName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 7)];
        }
        else{
            
            review.performedByName = @"";
        }
        
        review.reviewInitiationTimeStamp = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 8)];
        
        
        if(sqlite3_column_text(getAllReviewStatement, 9) != nil){
            
            review.ownerNextTimeStamp = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 9)];
        }
        else{
            
            review.ownerNextTimeStamp = @"";
        }
        
        if(sqlite3_column_text(getAllReviewStatement, 10) != nil){
            
            review.itemNextTimeStamp = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 10)];
        }
        else{
            
            review.itemNextTimeStamp = @"";
        }
        
        if(sqlite3_column_text(getAllReviewStatement, 11) != nil){
            
            review.confirmationSubmitTimestamp = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 11)];
        }
        else{
            
            review.confirmationSubmitTimestamp = @"";
        }
        
        
        if(sqlite3_column_text(getAllReviewStatement, 12) != nil){
            
            review.additionalComments = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 12)];
        }
        else{
            
            review.additionalComments = @"";
        }
        
        review.isPending = sqlite3_column_int(getAllReviewStatement, 13);
        
        review.lastPageNumber = sqlite3_column_int(getAllReviewStatement, 14);
        
        review.selectedServiceTypeIndex = sqlite3_column_int(getAllReviewStatement, 15);
        
        review.isUploaded = sqlite3_column_int(getAllReviewStatement, 16);
        
        
        if(sqlite3_column_text(getAllReviewStatement, 17) != nil){
            
            review.serviceTypeId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 17)];
        }
        else{
            
            review.serviceTypeId = @"0";
        }
        
        
        if(sqlite3_column_text(getAllReviewStatement, 18) != nil){
            
            review.possessionDate = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 18)];
        }
        else{
            
            review.possessionDate = @"";
        }
        
        
        if(sqlite3_column_text(getAllReviewStatement, 19) != nil){
            
            review.unitEnrolmentPolicy = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 19)];
        }
        else{
            
            review.unitEnrolmentPolicy = @"";
        }
        
        
        review.isPDI = sqlite3_column_int(getAllReviewStatement, 20);
        
        review.isSyncing = sqlite3_column_int(getAllReviewStatement, 21);
        
        review.reviewOwners = [[ReviewOwnerDatabase sharedDatabase]getAllReviewOwnersForReviewId:review.reviewRowId];
        
        review.deficienceyReviewItems = [[ReviewItemDatabase sharedDatabase] getAllReviewItemsForReview:review.reviewRowId];
        
        review.builderUser = [[BuilderUsersDB sharedDatabase]fetchUser:review.userId];
        
        [recordArray addObject:review];
    }
    
    sqlite3_reset(getAllReviewStatement);
    
    return recordArray;
}


- (void)switchPragmaOn{
    
    sqlite3_step(switchParagmaON);
    sqlite3_reset(switchParagmaON);
}


- (void)deleteDeficiencyReview:(int)reviewRowId{

    [self switchPragmaOn];
    sqlite3_bind_int(deleteReviewStatement, 1, reviewRowId);
    
    if(SQLITE_DONE != sqlite3_step(deleteReviewStatement)){
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    sqlite3_reset(deleteReviewStatement);
}


- (void)deleteDeficiencyReviewForUnit:(NSString *)unitId{
    
    [self switchPragmaOn];
    sqlite3_bind_text(deleteReviewStatementForUnit, 1, [unitId UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(deleteReviewStatementForUnit)){
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    sqlite3_reset(deleteReviewStatementForUnit);
}


- (void)deleteExecutedDeficiencyReviews{
    
    [self switchPragmaOn];
    sqlite3_step(deleteExecutedReviewStatement);
    sqlite3_reset(deleteExecutedReviewStatement);
}


- (void)updateDeficiencyReview:(DeficiencyReview *)review{
    
    
    sqlite3_bind_text(updateDeficiencyReviewStatement, 1, [review.performedBySignature UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateDeficiencyReviewStatement, 2, [review.developerSignature UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateDeficiencyReviewStatement, 3, [review.developerName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateDeficiencyReviewStatement, 4, [review.performedByEmail UTF8String], -1, SQLITE_TRANSIENT);
        
    sqlite3_bind_text(updateDeficiencyReviewStatement, 5, [review.performedByName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateDeficiencyReviewStatement, 6, [review.reviewInitiationTimeStamp UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateDeficiencyReviewStatement, 7, [review.ownerNextTimeStamp UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateDeficiencyReviewStatement, 8, [review.itemNextTimeStamp UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateDeficiencyReviewStatement, 9, [review.confirmationSubmitTimestamp UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateDeficiencyReviewStatement,10, [review.additionalComments UTF8String], -1, SQLITE_TRANSIENT);
    
    
    sqlite3_bind_int(updateDeficiencyReviewStatement, 11, review.isPending);
    sqlite3_bind_int(updateDeficiencyReviewStatement, 12, review.lastPageNumber);
    sqlite3_bind_int(updateDeficiencyReviewStatement, 13, review.selectedServiceTypeIndex);
    
//    isUploaded=?, legalDescription=?, possessionDate=?, unitEnrolmentPolicy=?, isPDI = ?
    
    sqlite3_bind_int(updateDeficiencyReviewStatement, 14, review.isUploaded);
    
    sqlite3_bind_text(updateDeficiencyReviewStatement, 15, [review.serviceTypeId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateDeficiencyReviewStatement, 16, [review.possessionDate UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateDeficiencyReviewStatement, 17, [review.unitEnrolmentPolicy UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(updateDeficiencyReviewStatement, 18, review.isPDI);
    
    sqlite3_bind_int(updateDeficiencyReviewStatement, 19, review.isSyncing);
    
    sqlite3_bind_text(updateDeficiencyReviewStatement, 20, [review.userId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateDeficiencyReviewStatement, 21, [review.unitId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(updateDeficiencyReviewStatement, 22, review.reviewRowId);
    
    
    if(SQLITE_DONE != sqlite3_step(updateDeficiencyReviewStatement)){
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    sqlite3_reset(updateDeficiencyReviewStatement);
}



@end
