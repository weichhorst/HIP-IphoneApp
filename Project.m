//
//  Project.m
//  Conasys
//
//  Created by user on 5/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Project.h"
#import "Unit.h"
#import "Service.h"

@implementation Project


-(NSDictionary *) jsonMapping {
    
	return [[NSDictionary alloc] initWithObjectsAndKeys:
            @"logohref",PROJECT_LOGOHREF,
            @"address", PROJECT_ADDRESS,
            @"builderRefNum", PROJECT_BUILDER_REF_NUM,
            @"primaryColor", PROJECT_PRIMARY_COLOR,
            @"secondaryColor", PROJECT_SECONDARY_COLOR,
            @"projectName", PROJECT_NAME,
            @"builderLogo", PROJECT_BUILDER_LOGO,
            nil];
}


+(NSMutableArray *) projectsFromArray:(NSMutableArray *)array andConstructionDict:(NSDictionary *)dict {
	

    NSMutableArray *projectArray = [NSMutableArray new];
    
    if (array == (id)[NSNull null] || [array count]==0) {
        
        return projectArray;
        
    }
    else{
        for (NSDictionary *responseDictionary in array) {
                        
            id response = [self projectFromDictionary:responseDictionary andConstructionDict:dict];
            
            if (response) {
                
                [projectArray addObject:response];
            }
        }
    }
	return projectArray;
}


+(Project *) projectFromDictionary:(NSDictionary *)responseDictionary andConstructionDict:(NSDictionary *)dict{
	
    
	if ([responseDictionary isDictionaryExist]) {
        
		Project *project = [[Project alloc] init];
        
		NSDictionary *mappingDict = [project jsonMapping];
        
		for (NSString *key in [mappingDict allKeys]){
            
			NSString *classProperty = [mappingDict objectForKey:key];
            
			NSString *attributeValue = [responseDictionary objectForKey:key];
			
			if (attributeValue!=nil && !([attributeValue isKindOfClass:[NSNull class]])) {
                
				[project setValue:attributeValue forKeyPath:classProperty];
			}
		}
        
        project.userId = CURRENT_BUILDER_ID;
        
        project.projectId = [NSString stringWithFormat:@"%@",[responseDictionary objectForKey:PROJECT_ID]];
        
        project.units = [Unit unitsFromArray:[responseDictionary objectForKey:PROJECT_UNITS] forProject:project.projectId];
       
        project.serviceTypes = [Service serviceFromArray:[responseDictionary objectForKey:PROJECT_SERVICE_TYPES] forProject:project.projectId];
                
		return project;
	}
	else {
		return nil;
	}
}



@end
