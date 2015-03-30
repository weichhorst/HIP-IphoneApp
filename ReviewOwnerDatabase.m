//
//  ReviewOwnerDatabase.m
//  Conasys
//
//  Created by user on 7/7/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ReviewOwnerDatabase.h"
#import "OwnerDBManager.h"

@implementation ReviewOwnerDatabase

static sqlite3_stmt *insertIntoReviewOwnerStatement;
static sqlite3_stmt *getAllReviewOwnerStatement;
static sqlite3_stmt *deleteReviewOwnerStatement;
static sqlite3_stmt *updateReviewOwnerStatement;

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
    
    static const char *insertReviewOwner = "Insert into ReviewOwner (ownerSignature, isSelectedOwner, printName, reviewRowId, ownerRowId, userName, email) values (?, ?, ?, ?, ?, ?, ?)";
    sqlite3_prepare_v2(self.connection, insertReviewOwner, -1, &insertIntoReviewOwnerStatement, NULL);
    
    static const char *updateReviewOwner = "Update ReviewOwner set ownerSignature = ?, isSelectedOwner = ?, printName = ?, userName=?, email=? where reviewRowId = ? and ownerRowId = ?";
    sqlite3_prepare_v2(self.connection, updateReviewOwner, -1, &updateReviewOwnerStatement, NULL);

    
    static const char *getAllReviewOwner = "SELECT rowid, * From ReviewOwner where reviewRowId=?";
    sqlite3_prepare_v2(self.connection, getAllReviewOwner, -1, &getAllReviewOwnerStatement, NULL);
    
    static const char *deleteReviewOwner = "delete from ReviewOwner where reviewRowId=?";
    sqlite3_prepare_v2(self.connection, deleteReviewOwner, -1, &deleteReviewOwnerStatement, NULL);
    
}



- (void)insertIntoReviewOwnerTable:(ReviewOwner *)reviewOwner{
    
    
    sqlite3_bind_text(insertIntoReviewOwnerStatement, 1, [reviewOwner.ownerSignature UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(insertIntoReviewOwnerStatement, 2, reviewOwner.isSelectedOwner);
    
    sqlite3_bind_text(insertIntoReviewOwnerStatement, 3, [reviewOwner.printName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(insertIntoReviewOwnerStatement, 4, reviewOwner.reviewRowId);
    
    sqlite3_bind_int(insertIntoReviewOwnerStatement, 5, reviewOwner.ownerRowId);
    
    //12-sept-2014
    sqlite3_bind_text(insertIntoReviewOwnerStatement, 6, [reviewOwner.userName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertIntoReviewOwnerStatement, 7, [reviewOwner.email UTF8String], -1, SQLITE_TRANSIENT);
    
    if(SQLITE_DONE != sqlite3_step(insertIntoReviewOwnerStatement)){
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    
    sqlite3_reset(insertIntoReviewOwnerStatement);
}


- (NSMutableArray *)getAllReviewOwnersForReviewId:(int)reviewRowId{

    NSMutableArray *recordArray = [NSMutableArray new];
    
    sqlite3_bind_int(getAllReviewOwnerStatement, 1, reviewRowId);
    
    while (sqlite3_step(getAllReviewOwnerStatement)==SQLITE_ROW)
    {
        
        ReviewOwner *reviewOwner = [[ReviewOwner alloc]init];
        
        reviewOwner.reviewOwnerRowId = sqlite3_column_int64(getAllReviewOwnerStatement, 0);
        
        reviewOwner.ownerSignature = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewOwnerStatement, 1)];

        reviewOwner.isSelectedOwner = sqlite3_column_int(getAllReviewOwnerStatement, 2);
        
        reviewOwner.printName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewOwnerStatement, 3)];
        
        reviewOwner.reviewRowId = sqlite3_column_int(getAllReviewOwnerStatement, 4);
        
        reviewOwner.ownerRowId = sqlite3_column_int(getAllReviewOwnerStatement, 5);
        
        //12-sept-2014
        reviewOwner.userName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewOwnerStatement, 6)];
        
        reviewOwner.email = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllReviewOwnerStatement, 7)];
        
        
        reviewOwner.owner = [[OwnerDBManager sharedManager]getOwnerFromId:reviewOwner.ownerRowId];
        
        [recordArray addObject:reviewOwner];
    }
    
    sqlite3_reset(getAllReviewOwnerStatement);
    return recordArray;
}

- (void)updateReviewOwnerTable:(ReviewOwner *)reviewOwner{
    

    sqlite3_bind_text(updateReviewOwnerStatement, 1, [reviewOwner.ownerSignature UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(updateReviewOwnerStatement, 2, reviewOwner.isSelectedOwner);
    
    sqlite3_bind_text(updateReviewOwnerStatement, 3, [reviewOwner.printName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateReviewOwnerStatement, 4, [reviewOwner.userName UTF8String], -1, SQLITE_TRANSIENT);
    
    //12-sept-2014
    sqlite3_bind_text(updateReviewOwnerStatement, 5, [reviewOwner.email UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(updateReviewOwnerStatement, 6, reviewOwner.reviewRowId);

    sqlite3_bind_int(updateReviewOwnerStatement, 7, reviewOwner.ownerRowId);

    if(SQLITE_DONE != sqlite3_step(updateReviewOwnerStatement)){
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    
    sqlite3_reset(updateReviewOwnerStatement);
    
}

- (void)deleteReviewOwners:(int)reviewRowId{
    
    sqlite3_bind_int(deleteReviewOwnerStatement, 1, reviewRowId);
    sqlite3_step(deleteReviewOwnerStatement);
    sqlite3_reset(deleteReviewOwnerStatement);
}


@end
