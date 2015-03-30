//
//  ProductDataBase.m
//  Conasys
//
//  Created by abhi on 6/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ProductDataBase.h"
#import "Macros.h"

@implementation ProductDataBase

static Database *sharedDatabase = nil;

+ (id)sharedDatabase
{
    
    if (!sharedDatabase) {
        sharedDatabase = [[self alloc] init];
        
        [sharedDatabase createDb:sharedDatabase];
        [sharedDatabase customInit];
        
    }
    return sharedDatabase;
}


static sqlite3_stmt *insertProductStatement;
static sqlite3_stmt *getAllProductStatement;
//static sqlite3_stmt *deleteProductStatement;
//static sqlite3_stmt *deleteAllProductsStatement;

-(void)customInit
{
    
    static const char *insertRecord = "Insert into Product (productId, productName, isIndented, locationRowId,parentID) values (?, ?, ?, ?,?)";
	
	
    sqlite3_prepare_v2(self.connection, insertRecord, -1, &insertProductStatement, NULL);
    
    static const char *getUser = "SELECT * From Product where locationRowId = ?";
    sqlite3_prepare_v2(self.connection, getUser, -1, &getAllProductStatement, NULL);
    
    
//    static const char *deleteRecord = "DELETE FROM Product WHERE productId = ?";
//    sqlite3_prepare_v2(self.connection, deleteRecord, -1, &deleteProductStatement, NULL);
//    
//    
//    static const char *userCount = "DELETE FROM Product WHERE locationId = ?";
//    sqlite3_prepare_v2(self.connection, userCount, -1, &deleteAllProductsStatement, NULL);
    
}


- (void)insertIntoProductTable:(Product *)product
{
	
    sqlite3_bind_text(insertProductStatement, 1, [product.productId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertProductStatement, 2, [product.productName UTF8String], -1, SQLITE_TRANSIENT);

    sqlite3_bind_int(insertProductStatement, 3, product.isIndented);
	
	  sqlite3_bind_int(insertProductStatement, 4, product.locationRowId);
	
	  sqlite3_bind_text(insertProductStatement, 5, [product.parentID UTF8String], -1, SQLITE_TRANSIENT);

	
    if(SQLITE_DONE != sqlite3_step(insertProductStatement))
    {
        
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(self.connection));
    }
    
    sqlite3_reset(insertProductStatement);
}



- (NSMutableArray *)getAllProductsForLocation:(int)locationRowId
{
        
    NSMutableArray *allProductsArray = [NSMutableArray new];
    
    sqlite3_bind_int(getAllProductStatement, 1, locationRowId);
    
    while (sqlite3_step(getAllProductStatement)==SQLITE_ROW)
    {
        
        Product *product = [[Product alloc]init];
        
        product.productRowId = sqlite3_column_int(getAllProductStatement, 0);
        
        product.productId = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProductStatement, 1)];
			
		
        product.productName = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProductStatement, 2)];
        
        product.isIndented = sqlite3_column_int(getAllProductStatement, 3);
			
  			product.parentID = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(getAllProductStatement, 5)];

			
        product.locationRowId = sqlite3_column_int(getAllProductStatement, 4);
        
        [allProductsArray addObject:product];
    }
    
    sqlite3_reset(getAllProductStatement);
    return allProductsArray;
}


/*
- (void)deleteProduct:(Product *)product
{
    
    sqlite3_bind_text(deleteProductStatement, 1, [product.productId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_step(deleteProductStatement);
    sqlite3_reset(deleteProductStatement);
}



- (void)deleteAllProducts:(NSString *)locationId
{
    
    sqlite3_bind_text(deleteAllProductsStatement, 1, [locationId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(deleteAllProductsStatement);
    sqlite3_reset(deleteAllProductsStatement);
    
}
 
 */

@end
