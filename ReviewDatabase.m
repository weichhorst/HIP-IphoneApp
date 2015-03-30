//
//  ReviewDatabase.m
//  Conasys
//
//  Created by user on 7/7/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ReviewDatabase.h"
#import "ReviewOwnerDatabase.h"
#import "ProjectDBManager.h"
#import "UnitsDBManager.h"
#import "ServiceDBManager.h"
#import "ItemDBManager.h"

@implementation ReviewDatabase


static sqlite3_stmt *insertIntoReviewStatement;
static sqlite3_stmt *getAllReviewStatement;
static sqlite3_stmt *deleteReviewStatement;
static sqlite3_stmt *updateReviewStatement;
static sqlite3_stmt *switchParagmaON;
static sqlite3_stmt *deleteExecutedReviewStatement;

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
    
    static const char *insertReview = "Insert into ReviewTable (userId, projectRowId, unitsRowId, serviceRowId, itemId, userSignBase64String) values (?, ?, ?, ?, ?, ?)";
    sqlite3_prepare_v2(self.connection, insertReview, -1, &insertIntoReviewStatement, NULL);
    
    static const char *getAllReview = "SELECT * From ReviewTable where isPending = 1";
    sqlite3_prepare_v2(self.connection, getAllReview, -1, &getAllReviewStatement, NULL);
    
    static const char *pragmaON = "PRAGMA foreign_keys = ON";
    sqlite3_prepare_v2(self.connection, pragmaON, -1, &switchParagmaON, NULL);

    static const char *deleteReview = "delete from ReviewTable where reviewTable = ?";
    sqlite3_prepare_v2(self.connection, deleteReview, -1, &deleteReviewStatement, NULL);
    
    
    static const char *deleteExecutedReview = "delete from ReviewTable where isPending = 0";
    sqlite3_prepare_v2(self.connection, deleteExecutedReview, -1, &deleteExecutedReviewStatement, NULL);
    
    
    static const char *updateReview = "update ReviewTable set userId = ?, projectRowId = ?, unitsRowId = ?, serviceRowId = ?, itemId = ?, userSignBase64String = ?, isPending = ? where reviewRowId = ?";
    sqlite3_prepare_v2(self.connection, updateReview, -1, &updateReviewStatement, NULL);
    
}


- (long long)insertReview:(Review *)review{
    
    
    sqlite3_bind_text(insertIntoReviewStatement, 1, [review.userId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(insertIntoReviewStatement, 2, review.projectRowId);
    sqlite3_bind_int(insertIntoReviewStatement, 3, review.unitsRowId);
    sqlite3_bind_int(insertIntoReviewStatement, 4, review.serviceRowId);
    sqlite3_bind_int(insertIntoReviewStatement, 5, review.itemId);
    sqlite3_bind_text(insertIntoReviewStatement, 6, [review.userSignBase64String UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(insertIntoReviewStatement)){
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    sqlite3_reset(insertIntoReviewStatement);
    
    return sqlite3_last_insert_rowid(self.connection);
}


- (NSMutableArray *)getAllSubmittedReviews{

    NSMutableArray *recordArray = [NSMutableArray new];
    while (sqlite3_step(getAllReviewStatement)==SQLITE_ROW)
    {
        
        Review *review = [[Review alloc]init];
        
        review.reviewRowId = sqlite3_column_int(getAllReviewStatement, 0);
        review.userId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 1)];
        review.projectRowId = sqlite3_column_int(getAllReviewStatement, 2);
        review.unitsRowId = sqlite3_column_int(getAllReviewStatement, 3);
        review.serviceRowId = sqlite3_column_int(getAllReviewStatement, 4);
        review.itemId = sqlite3_column_int(getAllReviewStatement, 5);
        
        
        if(sqlite3_column_text(getAllReviewStatement, 6) != nil)
        {
            
            review.userSignBase64String = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewStatement, 6)];
        }
        else
        {
            review.userSignBase64String=@" ";
        }
        
        review.user = [[UsersDB sharedDatabase] fetchUser:review.userId];
        review.project = [[ProjectDBManager sharedManager]getProjectWithRowId:review.projectRowId];
        review.unit = [[UnitsDBManager sharedManager]getUnitForUnitRowId:review.unitsRowId];
        review.service = [[ServiceDBManager sharedManager]getServiceForServiceRowId:review.serviceRowId];
        review.item = [[ItemDBManager sharedManager] getItemForUnit:review.unitsRowId];
        review.reviewOwners = review.unit.ownersList;
        
        review.developer = [[DeveloperDB sharedDatabase] fetchDeveloper:review.userId andUnitRowId:review.unitsRowId];
        
        [recordArray addObject:review];
    }
    
    sqlite3_reset(getAllReviewStatement);

    return recordArray;
}


- (void)switchPragmaOn{
    
    sqlite3_step(switchParagmaON);
    sqlite3_reset(switchParagmaON);
}


- (void)deleteReview:(int)reviewRowId{
    
    sqlite3_bind_int(deleteReviewStatement, 1, reviewRowId);
    
    if(SQLITE_DONE != sqlite3_step(deleteReviewStatement)){
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    sqlite3_reset(deleteReviewStatement);
}


- (void)deleteExecutedReviews{
    
    sqlite3_step(deleteExecutedReviewStatement);
    sqlite3_reset(deleteExecutedReviewStatement);
}


- (void)updateReview:(Review *)review{
    
    sqlite3_bind_text(insertIntoReviewStatement, 1, [review.userId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(updateReviewStatement, 2, review.projectRowId);
    sqlite3_bind_int(updateReviewStatement, 3, review.unitsRowId);
    sqlite3_bind_int(updateReviewStatement, 4, review.serviceRowId);
    sqlite3_bind_int(updateReviewStatement, 5, review.itemId);
    sqlite3_bind_text(updateReviewStatement, 6, [review.userSignBase64String UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(updateReviewStatement, 7, review.isPending);
    sqlite3_bind_int(updateReviewStatement, 8, review.reviewRowId);
    
    if(SQLITE_DONE != sqlite3_step(updateReviewStatement)){
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    sqlite3_reset(updateReviewStatement);
}


@end
