//
//  ItemDBManager.h
//  Conasys
//
//  Created by user on 6/25/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseDBManager.h"
#import "Item.h"
#import "ItemDescription.h"

@interface ItemDBManager : BaseDBManager

+ (id)sharedManager;

// INSERTION
- (void)insertIntoItemTable:(Item *)item;
- (void )insertItemImages:(NSMutableArray *)array;
- (void)insertIntoItemDescriptionTable:(ItemDescription *)itemDesc;


// FETCHING
- (Item *)getItemForUnit:(int )unitId;
- (NSMutableArray *)getAllItemsDescForItem:(int)itemId;
- (ItemDescription *)getLastItemDescInserted;
- (NSMutableArray *)getAllItemImagesForItem:(int )itemId andItemDescRowId:(long long)itemDescRowId;


// UPDATIONS
- (void)updateItem:(Item *)item;
- (void)updateItemDescription:(ItemDescription *)itemDesc;

- (BOOL)hasItemInTableForUnit:(int)unitId;
- (void)updateItemEmail:(NSString *)email name:(NSString *)name forUnitId:(int)unitId;

//DELETION

- (void)deleteItem:(Item *)item;
- (void)deleteItemDescription:(ItemDescription *)itemDesc;
- (void)deleteFromItemImageTable:(long long)itemDescRowId;
- (void)deleteItemImage:(NSMutableArray *)itemImages;


@end
