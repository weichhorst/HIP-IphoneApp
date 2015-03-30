//
//  ServiceDBManager.m
//  Conasys
//
//  Created by user on 6/9/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "ServiceDBManager.h"
#import "ServiceDataBase.h"

@implementation ServiceDBManager

static ServiceDBManager *serviceDBManager = nil;


+ (id)sharedManager{
    
    if (!serviceDBManager) {
        
        serviceDBManager = [[ServiceDBManager alloc] init];
    }
    return serviceDBManager;
}


- (void)saveServicesToDB:(NSMutableArray *)serviceArray{
    

    for (Service *service in serviceArray) {
        
        [[ServiceDataBase sharedDatabase]insertIntoServiceTable:service];
    }
    
}


- (NSMutableArray *)getAllServicesForProject:(NSString *)projectId
{
    
    ServiceDataBase *services=[ServiceDataBase sharedDatabase];
    
    return [services getAllServicesForProject:projectId];
}



- (Service *)getServiceForServiceId:(NSString *)serviceId{
    
    return [[ServiceDataBase sharedDatabase] getServiceForServiceId:serviceId];
}

@end
