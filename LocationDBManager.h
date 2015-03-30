//
//  LocationDBManager.h
//  Conasys
//
//  Created by user on 6/9/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseDBManager.h"

@interface LocationDBManager : BaseDBManager



- (void)saveLocationToDB:(NSMutableArray *)locationArray;

- (NSMutableArray *)getAllLocationsForUnit:(NSString *)unitId;

@end
