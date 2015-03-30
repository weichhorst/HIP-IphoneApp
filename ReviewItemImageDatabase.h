//
//  ReviewItemImageDatabase.h
//  Conasys
//
//  Created by user on 8/4/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Database.h"
#import "ReviewItemImage.h"

@interface ReviewItemImageDatabase : Database


- (void)insertItemImages:(NSMutableArray *)array;
- (NSMutableArray *)getAllItemImagesForReviewItem:(int )reviewItemId;

- (void)deleteFromItemImageTable:(int)reviewItemRowId;
- (void)deleteItemImage:(NSMutableArray *)itemImages;

@end
