//
//  ProductDBManager.m
//  Conasys
//
//  Created by user on 6/9/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ProductDBManager.h"
#import "ProductDataBase.h"
#import "Product.h"

@implementation ProductDBManager


static ProductDBManager *productDBManager = nil;

+ (id)sharedManager{
    
    if (!productDBManager) {
        
        productDBManager = [[ProductDBManager alloc] init];
    }
    return productDBManager;
}



- (void)saveProductsToDB:(NSMutableArray *)productArray withLocationRowId:(int)locationRowId{
    
    ProductDataBase *productDataBase = [ProductDataBase sharedDatabase];
    
    for (Product *product in productArray) {
        
        product.locationRowId = locationRowId;
        [productDataBase insertIntoProductTable:product];
    }
}

- (NSMutableArray *)getAllProductsForLocation:(int )locationRowId{
    
    ProductDataBase *productDataBase = [ProductDataBase sharedDatabase];
    
    return [productDataBase getAllProductsForLocation:locationRowId];
}

@end
