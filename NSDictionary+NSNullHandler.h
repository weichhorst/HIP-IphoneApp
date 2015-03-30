//
//  NSDictionary + common.h
//  franchisee
//
//  Created by shail on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (addition) 

+(BOOL)valueForKeyInDict :(NSDictionary *)dict WithKey:(NSString *)key ;
-(BOOL)isDictionaryExist;
-(id)objectForKeyWithNullCheck:(id)key;
-(id)valueForKeyWithNullCheck:(NSString*)key;

@end
