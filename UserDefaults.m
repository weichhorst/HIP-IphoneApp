//
//  UserDefaults.m
//  Celebrity
//
//  Created by user on 3/4/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults


+ (void)saveObject:(id)object forKey:(NSString *)key{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:object forKey:key];
    [userDefaults synchronize];
}


+ (id)valueForKey:(NSString *)key{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}


+ (void)removeValueForKey:(NSString *)key{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}


+ (void)clearUserDefaults{
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}


+(void) setUserDefaultValue:(NSString*)value forKey:(NSString*)key
{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	[defs setObject:value forKey:key];
    [defs synchronize];
}

-(NSString *) getUserDefaultValue:(NSString *)key
{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	NSString *returnVal = (NSString *) [defs objectForKey:key];
	if (returnVal){
		return returnVal;
	}
	else{
		return nil;
	}
	[defs synchronize];
}

@end
