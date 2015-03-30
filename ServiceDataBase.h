//
//  ServiceDataBase.h
//  Conasys
//
//  Created by user on 5/12/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Database.h"
#import "Service.h"

@interface ServiceDataBase : Database

+ (id)sharedDatabase;

- (void)insertIntoServiceTable:(Service *)service;

- (NSMutableArray *)getAllServicesForProject:(NSString *)projectId;
- (Service *)getProjectService;
- (Service *)getServiceForServiceId:(NSString *)serviceTypeId;

- (void)deleteService:(Service *)service;
- (void)deleteAllServices:(NSString *)projectId;


@end
