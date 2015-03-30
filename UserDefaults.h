//
//  UserDefaults.h
//  Celebrity
//
//  Created by user on 3/4/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject


+(id)valueForKey:(NSString *)key;

+(void)saveObject:(id)object forKey:(NSString *)key;

+ (void)removeValueForKey:(NSString *)key;

+ (void)clearUserDefaults;

-(NSString *) getUserDefaultValue:(NSString *)key;

+(void) setUserDefaultValue:(NSString*)value forKey:(NSString*)key;


@end
