//
//  ServiceDBManager.h
//  Conasys
//
//  Created by user on 6/9/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "BaseDBManager.h"
#import "Service.h"

@interface ServiceDBManager : BaseDBManager


- (void)saveServicesToDB:(NSMutableArray *)serviceArray;
- (NSMutableArray *)getAllServicesForProject:(NSString *)projectId;
- (Service *)getServiceForServiceId:(NSString *)serviceId;

@end
