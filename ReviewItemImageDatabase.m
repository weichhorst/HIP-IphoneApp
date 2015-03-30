//
//  ReviewItemImageDatabase.m
//  Conasys
//
//  Created by user on 8/4/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ReviewItemImageDatabase.h"

@implementation ReviewItemImageDatabase

static sqlite3_stmt *insertItemPhotoStatement;
static sqlite3_stmt *getAllItemPhotosStatement;
static sqlite3_stmt *deleteItemImageTable;
static sqlite3_stmt *deleteItemImageWithPath;

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
    
    static const char *insertPhotoPath = "Insert into ReviewItemImage (itemImagePath, base64String, reviewItemRowId) values (?, ?, ?)";
    sqlite3_prepare_v2(self.connection, insertPhotoPath, -1, &insertItemPhotoStatement, NULL);
    
    static const char *getAllPhotos = "SELECT *, rowid From ReviewItemImage where reviewItemRowId = ?";
    sqlite3_prepare_v2(self.connection, getAllPhotos, -1, &getAllItemPhotosStatement, NULL);
    
    static const char *deleteItemImages = "delete from ReviewItemImage where reviewItemRowId = ?";
    sqlite3_prepare_v2(self.connection, deleteItemImages, -1, &deleteItemImageTable, NULL);
    
    static const char *deleteImage = "delete from ReviewItemImage where reviewItemRowId = ? and rowid = ?";
    sqlite3_prepare_v2(self.connection, deleteImage, -1, &deleteItemImageWithPath, NULL);
    
}


- (void)insertItemImages:(NSMutableArray *)array{
    
    
    for (ReviewItemImage *reviewItemImage in array) {
        
        sqlite3_bind_text(insertItemPhotoStatement, 1, [[reviewItemImage itemImagePath] UTF8String], -1, SQLITE_TRANSIENT);
        
        sqlite3_bind_text(insertItemPhotoStatement, 2, [reviewItemImage.base64String UTF8String], -1, SQLITE_TRANSIENT);
        
        sqlite3_bind_int(insertItemPhotoStatement, 3, reviewItemImage.reviewItemRowId);
        
        sqlite3_step(insertItemPhotoStatement);
        sqlite3_reset(insertItemPhotoStatement);
        
    }
}


- (NSMutableArray *)getAllItemImagesForReviewItem:(int )reviewItemId{
    
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    sqlite3_bind_int(getAllItemPhotosStatement, 1, reviewItemId);
    
    while (sqlite3_step(getAllItemPhotosStatement)==SQLITE_ROW)
    {
        
        ReviewItemImage *reviewItemImage = [[ReviewItemImage alloc]init];
        
        
        if(sqlite3_column_text(getAllItemPhotosStatement, 0) != nil)
        {
            
            reviewItemImage.itemImagePath = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllItemPhotosStatement, 0)];
            
        }
        else{
            
            reviewItemImage.itemImagePath = [NSURL URLWithString:@""];
        }
        
        if(sqlite3_column_text(getAllItemPhotosStatement, 1) != nil)
        {
            
            reviewItemImage.base64String = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllItemPhotosStatement, 1)];
            
        }
        else{
            
            reviewItemImage.base64String = [NSURL URLWithString:@""];
        }
        
        reviewItemImage.reviewItemRowId = sqlite3_column_int(getAllItemPhotosStatement, 2);
        
        reviewItemImage.reviewItemImageRowId = sqlite3_column_int64(getAllItemPhotosStatement, 3);
        
        [imageArray addObject:reviewItemImage];
    }
    
    sqlite3_reset(getAllItemPhotosStatement);
    
    return imageArray;
}




- (void)deleteFromItemImageTable:(int)reviewItemRowId{
    
    sqlite3_bind_int(deleteItemImageTable, 1, reviewItemRowId);
    sqlite3_step(deleteItemImageTable);
    sqlite3_reset(deleteItemImageTable);
}


- (void)deleteItemImage:(NSMutableArray *)itemImages{
    
    
    for (ReviewItemImage *reviewItemImage in itemImages) {
        
        sqlite3_bind_int(deleteItemImageWithPath, 1, reviewItemImage.reviewItemRowId);
        sqlite3_bind_int64(deleteItemImageWithPath, 2, reviewItemImage.reviewItemImageRowId);
        
        sqlite3_step(deleteItemImageWithPath);
        sqlite3_reset(deleteItemImageWithPath);
    }
}


@end
