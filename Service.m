//
//  Service.m
//  Conasys
//
//  Created by user on 5/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Service.h"

@implementation Service



-(NSDictionary *) jsonMapping {
    
	return [[NSDictionary alloc] initWithObjectsAndKeys:
            @"name",SERVICE_NAME,
            @"legalTerms",SERVICE_LEGAL_TERMS,
            nil];
}


+(NSMutableArray *) serviceFromArray:(NSArray *)responseArray forProject:(NSString *)projectId {
	
	NSMutableArray *serviceArray = [NSMutableArray new];
    
    if ([responseArray count]) {
        
        for (NSDictionary *responseDictionary in responseArray) {
            
            id response = [self serviceFromDictionary:responseDictionary forProject:projectId];
            
            if (response) {
                
                [serviceArray addObject:response];
            }
        }
    }    
    
	return serviceArray;
}



+(Service *) serviceFromDictionary:(NSDictionary *)responseDictionary forProject:(NSString *)projectId {
	
    
	if ([responseDictionary isDictionaryExist]) {
        
		Service *service = [[Service alloc] init];
        
		NSDictionary *mappingDict = [service jsonMapping];
        
		for (NSString *key in [mappingDict allKeys]){
            
			NSString *classProperty = [mappingDict objectForKey:key];
            
			NSString *attributeValue = [responseDictionary objectForKey:key];
			
			if (attributeValue!=nil && !([attributeValue isKindOfClass:[NSNull class]])) {
                
				[service setValue:attributeValue forKeyPath:classProperty];
			}
		}
        
        service.isConstructionView = [[responseDictionary objectForKey:SERVICE_IsCONSTRUCTION_VIEW] integerValue];
        
        service.serviceTypeId = [NSString stringWithFormat:@"%@", [responseDictionary objectForKey:SERVICE_ID]];
        
        service.projectId = projectId;
        
		return service;
	}
	else {
        
		return nil;
	}
}

 

@end
