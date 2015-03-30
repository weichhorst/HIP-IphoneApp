//
//  ReviewItemDatabase.m
//  Conasys
//
//  Created by user on 8/4/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ReviewItemDatabase.h"
#import "ReviewItemImageDatabase.h"

@implementation ReviewItemDatabase



static sqlite3_stmt *insertIntoItemDescriptionStatement;
static sqlite3_stmt *updateItemDescStatement;
static sqlite3_stmt *getAllItemDescriptionStatement;
static sqlite3_stmt *getLastItemDescInserted;
static sqlite3_stmt *deleteItemDescriptionStatement;
static sqlite3_stmt *switchParagmaON;


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
    
    static const char *pragmaON = "PRAGMA foreign_keys = ON";
    sqlite3_prepare_v2(self.connection, pragmaON, -1, &switchParagmaON, NULL);
    
    
    static const char *insertItemDesc = "Insert into ReviewItem (reviewRowId, itemLocationRowId, itemProductRowId, itemLocation, itemProduct, itemDescription, productId) values (?, ?, ?, ?, ?, ?, ?)";
    sqlite3_prepare_v2(self.connection, insertItemDesc, -1, &insertIntoItemDescriptionStatement, NULL);
    
    static const char *getAllItemDesc = "SELECT * From ReviewItem where reviewRowId = ? order by reviewItemRowId DESC";
    sqlite3_prepare_v2(self.connection, getAllItemDesc, -1, &getAllItemDescriptionStatement, NULL);
    
    static const char *getLastItemDesc = "SELECT * From ReviewItem order by reviewItemRowId DESC LIMIT 1";
    sqlite3_prepare_v2(self.connection, getLastItemDesc, -1, &getLastItemDescInserted, NULL);
    
    static const char *updateItemStat = "Update ReviewItem set itemLocationRowId=?, itemProductRowId = ?, itemLocation = ?, itemProduct = ?, itemDescription = ?, productId=? where reviewItemRowId = ? and reviewRowId = ?";
    sqlite3_prepare_v2(self.connection, updateItemStat, -1, &updateItemDescStatement, NULL);
    
    
    static const char *deleteItemDesc = "delete from ReviewItem where reviewRowId=? and reviewItemRowId = ?";
    sqlite3_prepare_v2(self.connection, deleteItemDesc, -1, &deleteItemDescriptionStatement, NULL);
    
}


// done
- (void)insertIntoReviewItemTable:(ReviewItem *)reviewItem{
    
    

    sqlite3_bind_int(insertIntoItemDescriptionStatement, 1, reviewItem.reviewRowId);

    sqlite3_bind_int(insertIntoItemDescriptionStatement, 2, reviewItem.itemLocationRowId);

    sqlite3_bind_int(insertIntoItemDescriptionStatement, 3, reviewItem.itemProductRowId);

    sqlite3_bind_text(insertIntoItemDescriptionStatement, 4, [reviewItem.itemLocation UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_text(insertIntoItemDescriptionStatement, 5, [reviewItem.itemProduct UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_text(insertIntoItemDescriptionStatement, 6, [reviewItem.itemDescription UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertIntoItemDescriptionStatement, 7, [reviewItem.productId UTF8String], -1, SQLITE_TRANSIENT);

    
    if(SQLITE_DONE != sqlite3_step(insertIntoItemDescriptionStatement))
    {
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }

    sqlite3_reset(insertIntoItemDescriptionStatement);
}



- (void)updateReviewItem:(ReviewItem *)reviewItem{
    
    
    sqlite3_bind_int(updateItemDescStatement, 1, reviewItem.itemLocationRowId);
    
    sqlite3_bind_int(updateItemDescStatement, 2, reviewItem.itemProductRowId);
    
    sqlite3_bind_text(updateItemDescStatement, 3, [reviewItem.itemLocation UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateItemDescStatement, 4, [reviewItem.itemProduct UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateItemDescStatement, 5, [reviewItem.itemDescription UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateItemDescStatement, 6, [reviewItem.productId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int64(updateItemDescStatement, 7, reviewItem.reviewItemRowId);
    
    sqlite3_bind_int(updateItemDescStatement, 8, reviewItem.reviewRowId);
    
    sqlite3_step(updateItemDescStatement);
    
    sqlite3_reset(updateItemDescStatement);
}



- (NSMutableArray *)getAllReviewItemsForReview:(int)reviewRowId{
    
    NSMutableArray *recordArray = [NSMutableArray new];
    
    sqlite3_bind_int(getAllItemDescriptionStatement, 1, reviewRowId);
    
    while (sqlite3_step(getAllItemDescriptionStatement)==SQLITE_ROW)
    {
        
        ReviewItem *reviewItem = [[ReviewItem alloc]init];
        
        reviewItem.reviewItemRowId = sqlite3_column_int(getAllItemDescriptionStatement, 0);
        
        reviewItem.itemLocationRowId = sqlite3_column_int(getAllItemDescriptionStatement, 1);
        
        reviewItem.itemProductRowId = sqlite3_column_int(getAllItemDescriptionStatement, 2);
        
        if(sqlite3_column_text(getAllItemDescriptionStatement, 3) != nil)
        {
            
            reviewItem.itemLocation = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllItemDescriptionStatement, 3)];
        }
        else{
            
            reviewItem.itemLocation = @"";
        }
        
        if(sqlite3_column_text(getAllItemDescriptionStatement, 4) != nil)
        {
            
            reviewItem.itemProduct= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllItemDescriptionStatement, 4)];
            
        }
        else{
            
            reviewItem.itemProduct = @"";
        }
        
        if(sqlite3_column_text(getAllItemDescriptionStatement, 5) != nil)
        {
            
            reviewItem.itemDescription= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllItemDescriptionStatement, 5)];
            
        }
        else{
            
            reviewItem.itemDescription = @"";
        }
        
        
        reviewItem.reviewRowId = sqlite3_column_int(getAllItemDescriptionStatement, 6);
        
        if(sqlite3_column_text(getAllItemDescriptionStatement, 7) != nil)
        {
            
            reviewItem.productId= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllItemDescriptionStatement, 7)];
            
        }
        else{
            
            reviewItem.productId = @"0";
        }
        
        reviewItem.reviewItemImages = [[ReviewItemImageDatabase sharedDatabase] getAllItemImagesForReviewItem:reviewItem.reviewItemRowId];
        
        [recordArray addObject:reviewItem];
        
    }
    
    sqlite3_reset(getAllItemDescriptionStatement);
    
    return recordArray;
}


- (ReviewItem *)getLastInsertedReviewItem{
    
    
    ReviewItem *reviewItem = [[ReviewItem alloc]init];
    
    while (sqlite3_step(getLastItemDescInserted)==SQLITE_ROW)
    {
        
        reviewItem.reviewItemRowId = sqlite3_column_int(getLastItemDescInserted, 0);
        
        reviewItem.itemLocationRowId = sqlite3_column_int(getLastItemDescInserted, 1);
        
        reviewItem.itemProductRowId = sqlite3_column_int(getLastItemDescInserted, 2);
        
        reviewItem.itemLocation = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getLastItemDescInserted, 3)];
        
        reviewItem.itemProduct= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getLastItemDescInserted, 4)];
        
        reviewItem.itemDescription = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getLastItemDescInserted, 5)];
        
        reviewItem.reviewRowId = sqlite3_column_int(getLastItemDescInserted, 6);
        
        if(sqlite3_column_text(getLastItemDescInserted, 7) != nil)
        {
            
            reviewItem.productId= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getLastItemDescInserted, 7)];
            
        }
        else{
            
            reviewItem.productId = @"0";
        }
        
        reviewItem.reviewItemImages = [[NSMutableArray alloc]init];
        
    }
    
    sqlite3_reset(getLastItemDescInserted);
    
    return reviewItem;
}


- (void)deleteReviewItem:(ReviewItem *)reviewItem{
    
    [self switchPragmaOn];
    sqlite3_bind_int(deleteItemDescriptionStatement, 1, reviewItem.reviewRowId);
    sqlite3_bind_int64(deleteItemDescriptionStatement, 2, reviewItem.reviewItemRowId);
    
    sqlite3_step(deleteItemDescriptionStatement);
    sqlite3_reset(deleteItemDescriptionStatement);
    
}


- (void)switchPragmaOn{
    
    sqlite3_step(switchParagmaON);
    sqlite3_reset(switchParagmaON);
}


@end
