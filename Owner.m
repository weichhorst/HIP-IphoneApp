//
//  Owner.m
//  Conasys
//
//  Created by user on 5/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Owner.h"

@implementation Owner



-(NSDictionary *) jsonMapping {
    
	return [[NSDictionary alloc] initWithObjectsAndKeys:
            @"userName", OWNER_USER_NAME,
            @"firstName", OWNER_FIRST_NAME,
            @"lastName", OWNER_LAST_NAME,
            @"email", OWNER_EMAIL,
            @"phoneNumber", OWNER_PHONE_NUMBER,
            nil];
}



+(NSMutableArray *) ownersFromArray:(NSMutableArray *)array forUnit:(NSString *)unitId {
	
    NSMutableArray *ownerArray = [NSMutableArray new];
    if ([array count]) {
        for (NSDictionary *responseDictionary in array) {
            id response = [self ownerFromDictionary:responseDictionary forUnit:unitId];
            if (response) {
                [ownerArray addObject:response];
            }
        }
    }
    
	return ownerArray;
}



+(Owner *) ownerFromDictionary:(NSDictionary *)responseDictionary forUnit:(NSString *)unitId{
	
    
	if ([responseDictionary isDictionaryExist]) {
        
		Owner *owner = [[Owner alloc] init];
        
		NSDictionary *mappingDict = [owner jsonMapping];
        
		for (NSString *key in [mappingDict allKeys]){
            
			NSString *classProperty = [mappingDict objectForKey:key];
            
			NSString *attributeValue = [responseDictionary objectForKey:key];
			
			if (attributeValue!=nil && !([attributeValue isKindOfClass:[NSNull class]])) {
                
				[owner setValue:attributeValue forKeyPath:classProperty];
			}
		}
        
        owner.ownerId = [NSString stringWithFormat:@"%@", [responseDictionary objectForKey:@"OwnerId"]];
        
        owner.enableEmailNotification = [NSString stringWithFormat:@"%@",[responseDictionary objectForKey:OWNER_ENABLE_EMAIL_NOTIFICATION]];
        
        owner.unitId = unitId;
        
        owner.isEdited = NO;
        owner.isNewOwner = NO;
        owner.password = @"";
        owner.isSyncing = NO;
        owner.builderName = CURRENT_USERNAME;
        owner.builderToken = CURRENT_USER_TOKEN;
        
		return owner;
	}
	else {
		return nil;
	}
}



@end
