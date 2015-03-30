//
//  ItemDatabase.h
//  Conasys
//
//  Created by user on 6/25/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Database.h"
#import "Item.h"
#import "ItemDescription.h"

@interface ItemDatabase : Database


+ (id)sharedDatabase;

//INSERTION

- (void)insertIntoItemTable:(Item *)item;
- (void)insertItemImages:(NSMutableArray *)array;
- (void)insertIntoItemDescriptionTable:(ItemDescription *)itemDesc;


// FETCHING

- (Item *)getItemForUnit:(int )unitId;
- (ItemDescription *)getLastItemDescInserted;
- (NSMutableArray *)getAllItemsDescForItem:(int)itemId;
- (NSMutableArray *)getAllItemImagesForItem:(int )itemId andItemDescRowId:(long long)itemDescRowId;


// Updation

- (void)updateItem:(Item *)item;
- (BOOL)hasItemInTableForUnit:(int)unitId;
- (void)updateItemDescription:(ItemDescription *)itemDesc;
- (void)updateItemEmail:(NSString *)email name:(NSString *)name forUnitId:(int)unitId;


// DELETION

- (void)deleteItem:(Item *)item;
- (void)deleteItemDescription:(ItemDescription *)itemDesc;
- (void)deleteFromItemImageTable:(long long)itemDescRowId;
- (void)deleteItemImage:(NSMutableArray *)itemImages;



@end
