//
//  LocationDataBase.h
//  Conasys
//
//  Created by abhi on 6/6/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Database.h"
#import "Location.h"

@interface LocationDataBase : Database


+ (id)sharedDatabase;

- (long long)insertIntoLocationTable:(Location *)location;
- (NSMutableArray *)getAllLocationsForUnit:(NSString *)unitId;


@end
