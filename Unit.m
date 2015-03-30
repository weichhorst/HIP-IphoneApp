//
//  Unit.m
//  Conasys
//
//  Created by user on 5/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Unit.h"
#import "Location.h"
#import "Owner.h"

@implementation Unit





-(NSDictionary *) jsonMapping {
    
	return [[NSDictionary alloc] initWithObjectsAndKeys:
            @"completionDate",UNIT_COMPLETION_DATE,
            @"address", UNIT_ADDRESS,
            @"possessionDate", UNIT_POSSESSION_DATE,
            @"unitEnrollmentNumber", UNIT_ENROLLMENT_NUMBER,
            @"unitLegalDes", UNIT_LEGAL_DESC,
            @"unitNumber", UNIT_UNITNUMBER,
            nil];
}



+(NSMutableArray *) unitsFromArray:(NSMutableArray *)array forProject:(NSString *)projectId{
    
    NSMutableArray *projectArray = [NSMutableArray new];
    
    if ([array count]) {
        
        for (NSDictionary *responseDictionary in array) {
            
            id response = [self unitFromDictionary:responseDictionary forProject:projectId];
            
            if (response) {
                
                [projectArray addObject:response];
            }
        }
    }
    
	return projectArray;
}



+(Unit *) unitFromDictionary:(NSDictionary *)responseDictionary forProject:(NSString *)projectId {
	
    
	if ([responseDictionary isDictionaryExist]) {
        
		Unit *unit = [[Unit alloc] init];
        
		NSDictionary *mappingDict = [unit jsonMapping];
        
		for (NSString *key in [mappingDict allKeys]){
            
			NSString *classProperty = [mappingDict objectForKey:key];
            
			NSString *attributeValue = [responseDictionary objectForKey:key];
			
			if (attributeValue!=nil && !([attributeValue isKindOfClass:[NSNull class]])) {
              
				[unit setValue:attributeValue forKeyPath:classProperty];
            }
		}
        
        unit.projectId = projectId;
        
        unit.unitId = [NSString stringWithFormat:@"%@", [responseDictionary objectForKey:UNIT_ID]];
        
        unit.locationList = [Location locationsFromArray:[responseDictionary objectForKey:@"Locations"] forUnit:unit.unitId];
        
        unit.ownersList = [Owner ownersFromArray:[responseDictionary objectForKey:@"OwenerList"] forUnit:unit.unitId];
        
        unit.isPendingUnit = 0;
        
		return unit;
	}
	else {
		return nil;
	}
}


@end
