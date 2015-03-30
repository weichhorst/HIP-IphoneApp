//
//  LocationDBManager.m
//  Conasys
//
//  Created by user on 6/9/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "LocationDBManager.h"
#import "OwnerDataBase.h"
#import "Location.h"
#import "LocationDataBase.h"
#import "ProductDBManager.h"

@implementation LocationDBManager


static LocationDBManager *locationDBManager = nil;

+ (id)sharedManager{
    
    if (!locationDBManager) {
        
        locationDBManager = [[LocationDBManager alloc] init];
    }
    return locationDBManager;
}



- (void)saveLocationToDB:(NSMutableArray *)locationArray{
    
    LocationDataBase *locationDataBase = [LocationDataBase sharedDatabase];
    ProductDBManager *productDBManager = [ProductDBManager sharedManager];
    
    for (Location *location in locationArray) {
        
        long long locationRowId = [locationDataBase insertIntoLocationTable:location];
        
        
        [productDBManager saveProductsToDB:location.products withLocationRowId:(int)locationRowId];
        
    }
}


- (NSMutableArray *)getAllLocationsForUnit:(NSString *)unitId{
    
    LocationDataBase *locationDatabase = [LocationDataBase sharedDatabase];
    return [locationDatabase getAllLocationsForUnit:unitId];
}

@end
