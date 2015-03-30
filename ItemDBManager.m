//
//  ItemDBManager.m
//  Conasys
//
//  Created by user on 6/25/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ItemDBManager.h"
#import "ItemDatabase.h"

@implementation ItemDBManager


static ItemDBManager *itemDBManager = nil;

+ (id)sharedManager{
    
    if (!itemDBManager) {
        
        itemDBManager = [[ItemDBManager alloc] init];
    }
    return itemDBManager;
}


- (void)insertIntoItemTable:(Item *)item{
    
    [[ItemDatabase sharedDatabase] insertIntoItemTable:item];
}


- (void)insertIntoItemDescriptionTable:(ItemDescription *)itemDesc{
    
    [[ItemDatabase sharedDatabase] insertIntoItemDescriptionTable:itemDesc];
}


- (Item *)getItemForUnit:(int )unitId{
    
    return [[ItemDatabase sharedDatabase]getItemForUnit:unitId];
}


- (NSMutableArray *)getAllItemsDescForItem:(int)itemId{
    
    return [[ItemDatabase sharedDatabase] getAllItemsDescForItem:itemId];
}


- (ItemDescription *)getLastItemDescInserted{
    
    return [[ItemDatabase sharedDatabase]getLastItemDescInserted];
}


- (void)updateItem:(Item *)item{
    
    [[ItemDatabase sharedDatabase] updateItem:item];
}

- (void)updateItemEmail:(NSString *)email name:(NSString *)name forUnitId:(int)unitId{
    
    [[ItemDatabase sharedDatabase] updateItemEmail:email name:name forUnitId:unitId];
}

- (void)updateItemDescription:(ItemDescription *)itemDesc{
    
    [[ItemDatabase sharedDatabase] updateItemDescription:itemDesc];
}

- (BOOL)hasItemInTableForUnit:(int)unitId{
    
    return [[ItemDatabase sharedDatabase] hasItemInTableForUnit:unitId];
}

- (void )insertItemImages:(NSMutableArray *)array{

    [[ItemDatabase sharedDatabase] insertItemImages:array];
}


- (NSMutableArray *)getAllItemImagesForItem:(int )itemId andItemDescRowId:(long long)itemDescRowId{
    
    return [[ItemDatabase sharedDatabase] getAllItemImagesForItem:itemId andItemDescRowId:itemDescRowId];
}


- (void)deleteItem:(Item *)item{
    
    [[ItemDatabase sharedDatabase] deleteItem:item];
}

- (void)deleteItemDescription:(ItemDescription *)itemDesc{
    
    [[ItemDatabase sharedDatabase] deleteItemDescription:itemDesc];
}


- (void)deleteFromItemImageTable:(long long)itemDescRowId{
    
    [[ItemDatabase sharedDatabase] deleteFromItemImageTable:itemDescRowId];
}


- (void)deleteItemImage:(NSMutableArray *)itemImages{
    
    [[ItemDatabase sharedDatabase] deleteItemImage:itemImages];
}

@end
