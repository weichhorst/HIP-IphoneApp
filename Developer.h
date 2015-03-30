//
//  Developer.h
//  Conasys
//
//  Created by user on 7/17/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Database.h"

@interface Developer : NSObject

@property(nonatomic, retain)NSString *userId;
@property(nonatomic, readwrite)int unitsRowId;
@property(nonatomic, retain)NSString *developerName;
@property (nonatomic, retain)NSString *base64String;

@end

@interface DeveloperDB : Database


+ (id)sharedDatabase;

- (void)insertIntoDeveloperTable:(Developer *)developer;
- (Developer *)fetchDeveloper:(NSString *)userId andUnitRowId:(int)unitsRowId;
- (void)deleteDeveloperFromTable:(Developer *)developer;
- (void)updateDeveloper:(Developer *)developer;


@end
