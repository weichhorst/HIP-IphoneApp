//
//  Product.m
//  Conasys
//
//  Created by user on 5/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Product.h"

@implementation Product


-(NSDictionary *) jsonMapping {
    
	return [[NSDictionary alloc] initWithObjectsAndKeys:
            @"productName",PRODUCT_NAME,
            nil];
}



+(NSMutableArray *) productsFromArray:(NSMutableArray *)array {
	
    
    NSMutableArray *projectArray = [NSMutableArray new];
    
    if ([array count]) {
     
        for (NSDictionary *responseDictionary in array) {
            
            id response = [self productFromDictionary:responseDictionary];
            
            if (response) {
                
                [projectArray addObject:response];
            }
        }
    }
    
	return projectArray;
}



+(Product *) productFromDictionary:(NSDictionary *)responseDictionary {
	
    
	if ([responseDictionary isDictionaryExist]) {
        
		Product *product = [[Product alloc] init];
        
		NSDictionary *mappingDict = [product jsonMapping];
        
		for (NSString *key in [mappingDict allKeys]){
            
			NSString *classProperty = [mappingDict objectForKey:key];
            
			NSString *attributeValue = [responseDictionary objectForKey:key];
			
			if (attributeValue!=nil && !([attributeValue isKindOfClass:[NSNull class]])) {
                
				[product setValue:attributeValue forKeyPath:classProperty];
			}
            
            product.isIndented = [[responseDictionary objectForKey:@"IsIndent"] intValue];
            
            product.productId = [NSString stringWithFormat:@"%@", [responseDictionary objectForKey:PRODUCT_ID]];
			
			      product.parentID =[NSString stringWithFormat:@"%@", [responseDictionary objectForKey:PARENT_ID]];
		}
        
		return product;
	}
	else {
		return nil;
	}
}


@end
