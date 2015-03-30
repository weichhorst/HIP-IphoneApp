//
//  NSMutableArray+NullHandler.m
//  Conasys
//
//  Created by user on 6/19/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "NSMutableArray+NullHandler.h"

@implementation NSMutableArray (NullHandler)

-(BOOL)isArrayExist {
	
	if (self!=nil) {
        
		return YES;
	}
	else {
		return NO;
	}
}


@end
