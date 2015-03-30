//
//  ProductDataBase.h
//  Conasys
//
//  Created by abhi on 6/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Database.h"
#import "Product.h"


@interface ProductDataBase : Database


+ (id)sharedDatabase;


- (void)insertIntoProductTable:(Product *)product;
- (NSMutableArray *)getAllProductsForLocation:(int)locationId;
//- (void)deleteProduct:(Product *)product;
//- (void)deleteAllProducts:(NSString *)locationId;


@end
