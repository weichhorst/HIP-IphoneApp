//
//  NSDictionary + common.m
//  franchisee
//
//  Created by shail on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+NSNullHandler.h"


@implementation NSDictionary (addition)

+(BOOL)valueForKeyInDict :(NSDictionary *)dict WithKey:(NSString *)key {
	BOOL result = YES;
	if ([[dict valueForKey:key] isEqual:[NSNull null]] || [dict valueForKey:key] == nil) {
		result = NO;
	}
	return result;
}

-(BOOL)isDictionaryExist {
	
	if (self!=nil || !([self isKindOfClass:[NSNull class]])) {
	
		return YES;
	}
	else {
		return NO;
	}
}


-(id)objectForKeyWithNullCheck:(id)key {
    
    if ([self objectForKey:key] == [NSNull null] || [self objectForKey:key] == NULL) {
        return nil;
    }
    return [self objectForKey:key];
}

-(id)valueForKeyWithNullCheck:(NSString*)key {
    
    if ([self valueForKey:key] == [NSNull null] || [self valueForKey:key] == NULL) {
        return nil;
    }
    return [self valueForKey:key];
    
}

@end
