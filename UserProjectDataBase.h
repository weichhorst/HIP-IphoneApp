//
//  UserProjectDataBase.h
//  Conasys
//
//  Created by user on 6/9/14.
//  Copyright (c) 2014 Evon technologies. All rights reserved.
//

#import "Database.h"

@interface UserProjectDataBase : Database


+ (id)sharedDatabase;

- (void)insertIntoUserProjectTable:(NSString *)projectId;

- (NSMutableArray *)getAllProjectForUser:(NSString *)userId;


@end
