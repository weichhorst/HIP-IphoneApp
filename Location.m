//
//  Location.m
//  Conasys
//
//  Created by user on 5/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Location.h"
#import "Product.h"

@implementation Location



-(NSDictionary *) jsonMapping {
    
	return [[NSDictionary alloc] initWithObjectsAndKeys:
            @"locationName", LOCATION_NAME,
            nil];
}



+(NSMutableArray *) locationsFromArray:(NSMutableArray *)array forUnit:(NSString *)unitId {
	
    
    NSMutableArray *ownerArray = [NSMutableArray new];
    
    if ([array count]) {
     
        for (NSDictionary *responseDictionary in array) {
            
            
            id response = [self locationFromDictionary:responseDictionary forUnit:unitId];
            
            if (response) {
                
                [ownerArray addObject:response];
            }
        }
    }
    
	return ownerArray;
}



+(Location *) locationFromDictionary:(NSDictionary *)responseDictionary forUnit:(NSString *)unitId{
	
    
	if ([responseDictionary isDictionaryExist]) {
        
		Location *location = [[Location alloc] init];
        
		NSDictionary *mappingDict = [location jsonMapping];
        
		for (NSString *key in [mappingDict allKeys]){
            
			NSString *classProperty = [mappingDict objectForKey:key];
            
			NSString *attributeValue = [responseDictionary objectForKey:key];
			
			if (attributeValue!=nil && !([attributeValue isKindOfClass:[NSNull class]])) {
                
				[location setValue:attributeValue forKeyPath:classProperty];
			}
		}
        
        location.unitId = unitId;
        
        location.products = [Product productsFromArray:[responseDictionary objectForKey:LOCATION_PRODUCTS]];
        
        location.locationId = [NSString stringWithFormat:@"%@", [responseDictionary objectForKey:@"LocationId"]];

		return location;
	}
	else {
		return nil;
	}
}

@end
