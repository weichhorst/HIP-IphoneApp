//
//  ProductDBManager.h
//  Conasys
//
//  Created by user on 6/9/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseDBManager.h"

@interface ProductDBManager : BaseDBManager


- (void)saveProductsToDB:(NSMutableArray *)locationArray withLocationRowId:(int)locationRowId;

- (NSMutableArray *)getAllProductsForLocation:(int)locationRowId;


@end
