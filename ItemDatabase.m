//
//  ItemDatabase.m
//  Conasys
//
//  Created by user on 6/25/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ItemDatabase.h"
#import "MyAsset.h"
#import "ItemImage.h"

@implementation ItemDatabase


static sqlite3_stmt *insertIntoItemStatement;
static sqlite3_stmt *insertIntoItemDescriptionStatement;
static sqlite3_stmt *insertItemPhotoStatement;
static sqlite3_stmt *insertItemOwnerStatement;

static sqlite3_stmt *updateItemStatement;
static sqlite3_stmt *updateItemEmailNameStatement;
static sqlite3_stmt *updateItemDescStatement;

static sqlite3_stmt *countItemRecordStatement;

static sqlite3_stmt *getAllItemStatement;
static sqlite3_stmt *getAllItemDescriptionStatement;
static sqlite3_stmt *getAllItemPhotosStatement;
static sqlite3_stmt *getItemOwnerStatement;
static sqlite3_stmt *getLastItemDescInserted;


static sqlite3_stmt *deleteItemStatement;
static sqlite3_stmt *deleteItemDescriptionStatement;
static sqlite3_stmt *deleteItemImageTable;
static sqlite3_stmt *switchParagmaON;
static sqlite3_stmt *deleteItemImageWithPath;

//static sqlite3_stmt *deleteLocationStatement;
//static sqlite3_stmt *deleteAllLocationStatement;


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

    
    [self initializingItemTableStatements];
    [self initializingItemDescStatements];
    [self initializingItemImageTableStatements];
    [self initializingItemOwnerStatements];
    
}

// done
- (void)initializingItemTableStatements{
 
    
    static const char *insertItem = "Insert into ItemTable (unitId, itemAddress, itemComment, PerformedByEmail, PerformedByName, isPdiView) values (?, ?, ?, ?, ?, ?)";
    sqlite3_prepare_v2(self.connection, insertItem, -1, &insertIntoItemStatement, NULL);
    
    static const char *getAllItem = "SELECT * From ItemTable where unitId = ?";
    sqlite3_prepare_v2(self.connection, getAllItem, -1, &getAllItemStatement, NULL);
    
    
    static const char *updateItemStat = "Update ItemTable set itemAddress=?, itemComment = ?, PerformedByEmail = ?, PerformedByName = ?, isPdiView = ? where unitId = ?";

    sqlite3_prepare_v2(self.connection, updateItemStat, -1, &updateItemStatement, NULL);
    
    static const char *updateItemEname = "Update ItemTable set PerformedByEmail = ?, PerformedByName = ? where unitId = ?";
    
    sqlite3_prepare_v2(self.connection, updateItemEname, -1, &updateItemEmailNameStatement, NULL);
    
    
    static const char *countItemStat = "select count(itemId) from ItemTable where unitId = ?";
    sqlite3_prepare_v2(self.connection, countItemStat, -1, &countItemRecordStatement, NULL);
    
    
    static const char *deleteItem = "delete from ItemTable where itemId=? and unitId = ?";
    sqlite3_prepare_v2(self.connection, deleteItem, -1, &deleteItemStatement, NULL);
    
    
}

- (void)initializingItemDescStatements{
    
    
    static const char *insertItemDesc = "Insert into ItemDescTable (itemId, itemLocationId, itemProductId, itemLocation, itemProduct, itemDescription) values (?, ?, ?, ?, ?, ?)";
    sqlite3_prepare_v2(self.connection, insertItemDesc, -1, &insertIntoItemDescriptionStatement, NULL);
    
    static const char *getAllItemDesc = "SELECT *, rowid From ItemDescTable where itemId = ? order by rowid DESC";
    sqlite3_prepare_v2(self.connection, getAllItemDesc, -1, &getAllItemDescriptionStatement, NULL);
    
    static const char *getLastItemDesc = "SELECT *, rowid From ItemDescTable order by rowid DESC LIMIT 1";
    sqlite3_prepare_v2(self.connection, getLastItemDesc, -1, &getLastItemDescInserted, NULL);
    
    static const char *updateItemStat = "Update ItemDescTable set itemLocationId=?, itemProductId = ?, itemLocation = ?, itemProduct = ?, itemDescription = ? where rowid = ? and itemId = ?";
    sqlite3_prepare_v2(self.connection, updateItemStat, -1, &updateItemDescStatement, NULL);
    
    
    static const char *deleteItemDesc = "delete from ItemDescTable where itemId=? and rowid = ?";
    sqlite3_prepare_v2(self.connection, deleteItemDesc, -1, &deleteItemDescriptionStatement, NULL);
    
}



- (void)initializingItemImageTableStatements{

    
    static const char *insertPhotoPath = "Insert into ItemImageTable (itemDescRowId, itemId, itemImagePath, base64String) values (?, ?, ?, ?)";
    sqlite3_prepare_v2(self.connection, insertPhotoPath, -1, &insertItemPhotoStatement, NULL);
    
    static const char *getAllPhotos = "SELECT * From ItemImageTable where itemId = ? and itemDescRowId = ?";
    sqlite3_prepare_v2(self.connection, getAllPhotos, -1, &getAllItemPhotosStatement, NULL);
    
    
    static const char *deleteItemImages = "delete from ItemImageTable where itemDescRowId = ?";
    sqlite3_prepare_v2(self.connection, deleteItemImages, -1, &deleteItemImageTable, NULL);
    
    static const char *deleteItemImgWPath = "delete from ItemImageTable where itemDescRowId = ? and itemImagePath = ?";
    sqlite3_prepare_v2(self.connection, deleteItemImgWPath, -1, &deleteItemImageWithPath, NULL);
    
}



- (void)initializingItemOwnerStatements{
 
    
    //ItemOwner queries
    static const char *insertItemOwner = "Insert into ItemOwner (itemId, ownerId, ownerName) values (?, ?, ?)";
    sqlite3_prepare_v2(self.connection, insertItemOwner, -1, &insertItemOwnerStatement, NULL);
    
    static const char *getItemOwner = "SELECT * From ItemOwner where item = ?";
    sqlite3_prepare_v2(self.connection, getItemOwner, -1, &getItemOwnerStatement, NULL);
}


- (BOOL)hasItemInTableForUnit:(int)unitId{
    
    BOOL result = NO;
 
    sqlite3_bind_int(getAllItemStatement, 1, unitId);
    
    while (sqlite3_step(getAllItemStatement)==SQLITE_ROW)
    {
        
        result = YES;
    }
    
    sqlite3_reset(getAllItemStatement);
    
    return result;
}


// done



- (void)insertIntoItemTable:(Item *)item{
    
    sqlite3_bind_int(insertIntoItemStatement, 1, item.unitId);
    
    sqlite3_bind_text(insertIntoItemStatement, 2, [item.itemAddress UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertIntoItemStatement, 3, [item.itemComment UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertIntoItemStatement, 4, [item.PerformedByEmail UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertIntoItemStatement, 5, [item.PerformedByName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(insertIntoItemStatement, 6, item.isPdiView);
    
    if(SQLITE_DONE != sqlite3_step(insertIntoItemStatement)){
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    
    sqlite3_reset(insertIntoItemStatement);
}



// done
- (void)insertIntoItemDescriptionTable:(ItemDescription *)itemDesc{
    
    
    sqlite3_bind_int(insertIntoItemDescriptionStatement, 1, itemDesc.itemId);
    
    sqlite3_bind_int(insertIntoItemDescriptionStatement, 2, itemDesc.itemLocationId);

    sqlite3_bind_int(insertIntoItemDescriptionStatement, 3, itemDesc.itemProductId);
    
    sqlite3_bind_text(insertIntoItemDescriptionStatement, 4, [itemDesc.itemLocation UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_text(insertIntoItemDescriptionStatement, 5, [itemDesc.itemProduct UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertIntoItemDescriptionStatement, 6, [itemDesc.itemDescription UTF8String], -1, SQLITE_TRANSIENT);
    
    
    if(SQLITE_DONE != sqlite3_step(insertIntoItemDescriptionStatement))
    {
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    
    sqlite3_reset(insertIntoItemDescriptionStatement);
}



- (void)updateItem:(Item *)item{
    
    
    sqlite3_bind_text(updateItemStatement, 1, [item.itemAddress UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateItemStatement, 2, [item.itemComment UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateItemStatement, 3, [item.PerformedByEmail UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateItemStatement, 4, [item.PerformedByName UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(updateItemStatement, 5, item.isPdiView);
    
    sqlite3_bind_int(updateItemStatement, 6, item.unitId);
    
    
    sqlite3_step(updateItemStatement);
    
    sqlite3_reset(updateItemStatement);
}


- (void)updateItemEmail:(NSString *)email name:(NSString *)name forUnitId:(int)unitId{
    
    sqlite3_bind_text(updateItemEmailNameStatement, 1, [email UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateItemEmailNameStatement, 2, [name UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int(updateItemEmailNameStatement, 3, unitId);
    
    sqlite3_step(updateItemEmailNameStatement);
    
    sqlite3_reset(updateItemEmailNameStatement);
}





- (void)updateItemDescription:(ItemDescription *)itemDesc{
    
    
    sqlite3_bind_int(updateItemDescStatement, 1, itemDesc.itemLocationId);
    
    sqlite3_bind_int(updateItemDescStatement, 2, itemDesc.itemProductId);
    
    sqlite3_bind_text(updateItemDescStatement, 3, [itemDesc.itemLocation UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateItemDescStatement, 4, [itemDesc.itemProduct UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(updateItemDescStatement, 5, [itemDesc.itemDescription UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_int64(updateItemDescStatement, 6, itemDesc.itemDescRowId);
    
    sqlite3_bind_int(updateItemDescStatement, 7, itemDesc.itemId);
    
    sqlite3_step(updateItemDescStatement);
    
    sqlite3_reset(updateItemDescStatement);
}



//done
- (Item *)getItemForUnit:(int )unitId{
    
    sqlite3_bind_int(getAllItemStatement, 1, unitId);
    
    Item *item = [[Item alloc]init];
    
    while (sqlite3_step(getAllItemStatement)==SQLITE_ROW)
    {
        
        item.itemId = sqlite3_column_int(getAllItemStatement, 0);
        
        item.unitId = sqlite3_column_int(getAllItemStatement, 1);
        
        item.itemAddress = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllItemStatement, 2)];
        
        item.itemComment = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllItemStatement, 3)];
        
        item.PerformedByEmail = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllItemStatement, 4)];
        
        item.PerformedByName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllItemStatement, 5)];
        
        item.isPdiView = sqlite3_column_int(getAllItemStatement, 6);
        
        // fetching all item descriptions here
        item.itemDescriptionArray = [self getAllItemsDescForItem:item.itemId];
        
    }
    
    sqlite3_reset(getAllItemStatement);
    
    return item;
}


//done
- (NSMutableArray *)getAllItemsDescForItem:(int)itemId{
    
    NSMutableArray *recordArray = [NSMutableArray new];
    
    sqlite3_bind_int(getAllItemDescriptionStatement, 1, itemId);
    
    while (sqlite3_step(getAllItemDescriptionStatement)==SQLITE_ROW)
    {
        
        ItemDescription *itemDesc = [[ItemDescription alloc]init];
        
        itemDesc.itemId = sqlite3_column_int(getAllItemDescriptionStatement, 0);
        
        itemDesc.itemLocationId = sqlite3_column_int(getAllItemDescriptionStatement, 1);
        
        itemDesc.itemProductId = sqlite3_column_int(getAllItemDescriptionStatement, 2);
        
        if(sqlite3_column_text(getAllItemDescriptionStatement, 3) != nil)
        {
            
            itemDesc.itemLocation = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllItemDescriptionStatement, 3)];
        }
        else{
            
            itemDesc.itemLocation = @"";
        }
        
        if(sqlite3_column_text(getAllItemDescriptionStatement, 4) != nil)
        {
            
            itemDesc.itemProduct= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllItemDescriptionStatement, 4)];

        }
        else{
            
            itemDesc.itemProduct = @"";
        }
        
        if(sqlite3_column_text(getAllItemDescriptionStatement, 5) != nil)
        {
            
            itemDesc.itemDescription= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllItemDescriptionStatement, 5)];
            
        }
        else{
            
            itemDesc.itemDescription = @"";
        }
        
        
        itemDesc.itemDescRowId = sqlite3_column_int64(getAllItemDescriptionStatement, 6);
        
        itemDesc.itemImages = [self getAllItemImagesForItem:itemDesc.itemId andItemDescRowId:itemDesc.itemDescRowId];
                
        [recordArray addObject:itemDesc];
        
    }
    
    sqlite3_reset(getAllItemDescriptionStatement);
    
    return recordArray;
}


- (ItemDescription *)getLastItemDescInserted{
    
    
    ItemDescription *itemDesc = [[ItemDescription alloc]init];
    
    while (sqlite3_step(getLastItemDescInserted)==SQLITE_ROW)
    {
        
        itemDesc.itemId = sqlite3_column_int(getLastItemDescInserted, 0);
        
        itemDesc.itemLocationId = sqlite3_column_int(getLastItemDescInserted, 1);
        
        itemDesc.itemProductId = sqlite3_column_int(getLastItemDescInserted, 2);
        
        itemDesc.itemLocation = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getLastItemDescInserted, 3)];
        
        itemDesc.itemProduct= [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getLastItemDescInserted, 4)];
        
        itemDesc.itemDescription = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getLastItemDescInserted, 5)];
        
        itemDesc.itemDescRowId = sqlite3_column_int64(getLastItemDescInserted, 6);
        
    }
    
    sqlite3_reset(getLastItemDescInserted);
    
    return itemDesc;
}


- (void)insertItemImages:(NSMutableArray *)array{
    
//    NSMutableArray *base64Array = [NSMutableArray new];
    
    for (MyAsset *myAsset in array) {

        sqlite3_bind_int64(insertItemPhotoStatement, 1, myAsset.itemDescRowId);
        sqlite3_bind_int(insertItemPhotoStatement, 2, myAsset.itemId);
        sqlite3_bind_text(insertItemPhotoStatement, 3, [[myAsset itemImagePath] UTF8String], -1, SQLITE_TRANSIENT);
        
        
//        NSData * data = [UIImageJPEGRepresentation(myAsset.fullScreenImage, 0.1) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        
//        NSString *string = [NSString stringWithUTF8String:[data bytes]];
        
//        myAsset.base64String = string;
        
//        [base64Array addObject:string];
        
        sqlite3_bind_text(insertItemPhotoStatement, 4, [myAsset.base64String UTF8String], -1, SQLITE_TRANSIENT);
                               
        sqlite3_step(insertItemPhotoStatement);
        sqlite3_reset(insertItemPhotoStatement);

    }
    
}


- (NSMutableArray *)getAllItemImagesForItem:(int )itemId andItemDescRowId:(long long)itemDescRowId{
    
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    sqlite3_bind_int(getAllItemPhotosStatement, 1, itemId);
    
    sqlite3_bind_int64(getAllItemPhotosStatement, 2, itemDescRowId);
    
    while (sqlite3_step(getAllItemPhotosStatement)==SQLITE_ROW)
    {
        
        MyAsset *myAsset = [[MyAsset alloc]init];
        
        myAsset.itemDescRowId = sqlite3_column_int64(getAllItemPhotosStatement, 0);
        
        myAsset.itemId = sqlite3_column_int(getAllItemPhotosStatement, 1);
        
        
        if(sqlite3_column_text(getAllItemPhotosStatement, 2) != nil)
        {
            
            myAsset.itemImagePath = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllItemPhotosStatement, 2)];
            
        }
        else{
           
            myAsset.itemImagePath = [NSURL URLWithString:@""];
        }
        
        if(sqlite3_column_text(getAllItemPhotosStatement, 3) != nil)
        {
            
            myAsset.base64String = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllItemPhotosStatement, 3)];
            
        }
        else{
            
            myAsset.base64String = [NSURL URLWithString:@""];
        }
        
        
        [imageArray addObject:myAsset];
        
    }
    
    sqlite3_reset(getAllItemPhotosStatement);
    
    return imageArray;
}


- (void)deleteItem:(Item *)item{
    
    [self switchPragmaOn];
    sqlite3_bind_int(deleteItemStatement, 1, item.itemId);
    sqlite3_bind_int(deleteItemStatement, 2, item.unitId);
    sqlite3_step(deleteItemStatement);
    sqlite3_reset(deleteItemStatement);
    
}


- (void)deleteItemDescription:(ItemDescription *)itemDesc{
    
    [self switchPragmaOn];
    sqlite3_bind_int(deleteItemDescriptionStatement, 1, itemDesc.itemId);
    sqlite3_bind_int64(deleteItemDescriptionStatement, 2, itemDesc.itemDescRowId);
    
    sqlite3_step(deleteItemDescriptionStatement);
    sqlite3_reset(deleteItemDescriptionStatement);
    
    [self deleteFromItemImageTable:itemDesc.itemDescRowId];
}


- (void)deleteFromItemImageTable:(long long)itemDescRowId{
    
    sqlite3_bind_int64(deleteItemImageTable, 1, itemDescRowId);
    sqlite3_step(deleteItemImageTable);
    sqlite3_reset(deleteItemImageTable);
}


- (void)deleteItemImage:(NSMutableArray *)itemImages{
    
    
    for (MyAsset *asset in itemImages) {

        sqlite3_bind_int64(deleteItemImageWithPath, 1, asset.itemDescRowId);
        sqlite3_bind_text(deleteItemImageWithPath, 2, [asset.itemImagePath UTF8String], -1, SQLITE_TRANSIENT);
        
        sqlite3_step(deleteItemImageWithPath);
        sqlite3_reset(deleteItemImageWithPath);
    }
}


- (void)switchPragmaOn{
    
    sqlite3_step(switchParagmaON);
    sqlite3_reset(switchParagmaON);
}



@end
